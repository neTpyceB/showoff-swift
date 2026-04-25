import Foundation

struct FieldServiceLocalDatabase {
    private let defaults: UserDefaults
    private let jobsKey: String
    private let queueKey: String

    init(
        defaults: UserDefaults = .standard,
        jobsKey: String = "fieldservice.jobs",
        queueKey: String = "fieldservice.queue"
    ) {
        self.defaults = defaults
        self.jobsKey = jobsKey
        self.queueKey = queueKey
    }

    func loadJobs() -> [FieldJob] {
        guard let data = defaults.data(forKey: jobsKey) else { return [] }
        return (try? JSONDecoder().decode([FieldJob].self, from: data)) ?? []
    }

    func loadQueue() -> [FieldMutation] {
        guard let data = defaults.data(forKey: queueKey) else { return [] }
        return (try? JSONDecoder().decode([FieldMutation].self, from: data)) ?? []
    }

    func saveJobs(_ jobs: [FieldJob]) {
        defaults.set(try! JSONEncoder().encode(jobs), forKey: jobsKey)
    }

    func saveQueue(_ queue: [FieldMutation]) {
        defaults.set(try! JSONEncoder().encode(queue), forKey: queueKey)
    }
}

struct FieldServiceRemoteDatabase {
    private let defaults: UserDefaults
    private let key: String

    init(defaults: UserDefaults = .standard, key: String = "fieldservice.remote") {
        self.defaults = defaults
        self.key = key
    }

    func load() -> [FieldJob] {
        guard let data = defaults.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([FieldJob].self, from: data)) ?? []
    }

    func save(_ jobs: [FieldJob]) {
        defaults.set(try! JSONEncoder().encode(jobs), forKey: key)
    }
}

struct FieldServiceConflictResolver {
    func resolve(local: FieldJob, remote: FieldJob) -> FieldJob {
        if local.version != remote.version {
            return local.version > remote.version ? local : remote
        }
        if local.updatedAt != remote.updatedAt {
            return local.updatedAt >= remote.updatedAt ? local : remote
        }
        return local
    }
}

struct FieldServiceSyncResult: Sendable {
    let jobs: [FieldJob]
    let queue: [FieldMutation]
    let syncedMutations: Int
    let conflictCount: Int
    let didSync: Bool
}

struct FieldServiceSyncEngine {
    private let remoteDatabase: FieldServiceRemoteDatabase
    private let resolver = FieldServiceConflictResolver()

    init(remoteDatabase: FieldServiceRemoteDatabase = FieldServiceRemoteDatabase()) {
        self.remoteDatabase = remoteDatabase
    }

    func sync(localJobs: [FieldJob], queuedMutations: [FieldMutation], isOnline: Bool) -> FieldServiceSyncResult {
        guard isOnline else {
            return FieldServiceSyncResult(
                jobs: localJobs,
                queue: queuedMutations,
                syncedMutations: 0,
                conflictCount: 0,
                didSync: false
            )
        }

        var remoteByID = Dictionary(uniqueKeysWithValues: remoteDatabase.load().map { ($0.id, $0) })
        var conflictCount = 0

        for mutation in queuedMutations {
            if let remoteJob = remoteByID[mutation.job.id], remoteJob.version > mutation.baseVersion {
                conflictCount += 1
                remoteByID[mutation.job.id] = resolver.resolve(local: mutation.job, remote: remoteJob)
            } else {
                remoteByID[mutation.job.id] = mutation.job
            }
        }

        let remoteJobs = remoteByID.values.sorted { $0.updatedAt > $1.updatedAt }
        remoteDatabase.save(remoteJobs)

        var mergedByID = Dictionary(uniqueKeysWithValues: localJobs.map { ($0.id, $0) })
        for remoteJob in remoteJobs {
            if let localJob = mergedByID[remoteJob.id] {
                mergedByID[remoteJob.id] = resolver.resolve(local: localJob, remote: remoteJob)
            } else {
                mergedByID[remoteJob.id] = remoteJob
            }
        }

        let mergedJobs = mergedByID.values.sorted { $0.updatedAt > $1.updatedAt }
        return FieldServiceSyncResult(
            jobs: mergedJobs,
            queue: [],
            syncedMutations: queuedMutations.count,
            conflictCount: conflictCount,
            didSync: true
        )
    }

    func saveRemoteSnapshot(_ jobs: [FieldJob]) {
        remoteDatabase.save(jobs)
    }
}
