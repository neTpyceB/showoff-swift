import Combine
import Foundation

@MainActor
final class FieldServiceStore: ObservableObject {
    @Published private(set) var jobs: [FieldJob]
    @Published private(set) var pendingMutations: [FieldMutation]
    @Published private(set) var isOnline: Bool
    @Published private(set) var lastSyncAt: Date?
    @Published private(set) var lastConflictCount: Int

    private let localDatabase: FieldServiceLocalDatabase
    private let syncEngine: FieldServiceSyncEngine
    private var backgroundSyncTask: Task<Void, Never>?

    init(
        defaults: UserDefaults = .standard,
        jobsKey: String = "fieldservice.jobs",
        queueKey: String = "fieldservice.queue",
        remoteKey: String = "fieldservice.remote",
        isOnline: Bool = true
    ) {
        localDatabase = FieldServiceLocalDatabase(defaults: defaults, jobsKey: jobsKey, queueKey: queueKey)
        syncEngine = FieldServiceSyncEngine(remoteDatabase: FieldServiceRemoteDatabase(defaults: defaults, key: remoteKey))
        self.isOnline = isOnline

        let loadedJobs = localDatabase.loadJobs()
        let initialJobs = loadedJobs.isEmpty ? FieldJob.seedData() : loadedJobs
        jobs = initialJobs
        pendingMutations = localDatabase.loadQueue()
        lastConflictCount = 0

        if loadedJobs.isEmpty {
            localDatabase.saveJobs(initialJobs)
        }

        if isOnline, !pendingMutations.isEmpty {
            syncNow()
        }
    }

    deinit {
        backgroundSyncTask?.cancel()
    }

    var pendingSyncCount: Int {
        pendingMutations.count
    }

    var openCount: Int {
        jobs.filter { $0.status == .open }.count
    }

    var inProgressCount: Int {
        jobs.filter { $0.status == .inProgress }.count
    }

    var completedCount: Int {
        jobs.filter { $0.status == .completed }.count
    }

    var lastSyncLabel: String {
        guard let lastSyncAt else { return "Never" }
        return lastSyncAt.formatted(date: .omitted, time: .standard)
    }

    func setOnline(_ online: Bool) {
        isOnline = online
        if online {
            syncNow()
        }
    }

    func execute(_ command: FieldCommand) {
        guard let mutation = apply(command: command, at: Date()) else {
            return
        }

        pendingMutations.insert(mutation, at: 0)
        persist()

        if isOnline {
            syncNow()
        }
    }

    func syncNow() {
        let result = syncEngine.sync(localJobs: jobs, queuedMutations: pendingMutations, isOnline: isOnline)
        jobs = result.jobs
        pendingMutations = result.queue
        lastConflictCount = result.conflictCount
        if result.didSync {
            lastSyncAt = Date()
        }
        persist()
    }

    func startBackgroundSync(intervalSeconds: UInt64) {
        stopBackgroundSync()
        backgroundSyncTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: intervalSeconds * 1_000_000_000)
                self?.syncNow()
            }
        }
    }

    func stopBackgroundSync() {
        backgroundSyncTask?.cancel()
        backgroundSyncTask = nil
    }

#if DEBUG
    func seedRemoteStateForTests(_ remoteJobs: [FieldJob]) {
        syncEngine.saveRemoteSnapshot(remoteJobs)
    }
#endif

    private func apply(command: FieldCommand, at now: Date) -> FieldMutation? {
        switch command {
        case .createJob(let title, let location, let note, let priority):
            let job = FieldJob(
                id: UUID(),
                title: title,
                location: location,
                note: note,
                priority: priority,
                status: .open,
                version: 1,
                updatedAt: now
            )
            jobs.insert(job, at: 0)
            return FieldMutation(id: UUID(), job: job, baseVersion: 0, recordedAt: now)

        case .updateStatus(let jobID, let status):
            guard let index = jobs.firstIndex(where: { $0.id == jobID }) else { return nil }
            guard jobs[index].status != status else { return nil }

            let baseVersion = jobs[index].version
            jobs[index].status = status
            jobs[index].version += 1
            jobs[index].updatedAt = now
            sortJobs()
            return FieldMutation(id: UUID(), job: jobs.first(where: { $0.id == jobID })!, baseVersion: baseVersion, recordedAt: now)

        case .updateNote(let jobID, let note):
            guard let index = jobs.firstIndex(where: { $0.id == jobID }) else { return nil }
            guard jobs[index].note != note else { return nil }

            let baseVersion = jobs[index].version
            jobs[index].note = note
            jobs[index].version += 1
            jobs[index].updatedAt = now
            sortJobs()
            return FieldMutation(id: UUID(), job: jobs.first(where: { $0.id == jobID })!, baseVersion: baseVersion, recordedAt: now)
        }
    }

    private func sortJobs() {
        jobs.sort { $0.updatedAt > $1.updatedAt }
    }

    private func persist() {
        localDatabase.saveJobs(jobs)
        localDatabase.saveQueue(pendingMutations)
    }
}
