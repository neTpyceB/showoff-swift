import XCTest
@testable import FieldServiceApp

@MainActor
final class FieldServiceStoreTests: XCTestCase {
    func testOfflineCreatePersistsQueue() {
        let defaults = UserDefaults(suiteName: UUID().uuidString)!
        let store = FieldServiceStore(
            defaults: defaults,
            jobsKey: "fieldservice.jobs.tests.offline",
            queueKey: "fieldservice.queue.tests.offline",
            remoteKey: "fieldservice.remote.tests.offline",
            isOnline: false
        )

        let initialCount = store.jobs.count
        store.execute(.createJob(title: "Valve Check", location: "Plant 1", note: "Night shift", priority: .high))

        XCTAssertEqual(store.jobs.count, initialCount + 1)
        XCTAssertEqual(store.pendingSyncCount, 1)

        let restored = FieldServiceStore(
            defaults: defaults,
            jobsKey: "fieldservice.jobs.tests.offline",
            queueKey: "fieldservice.queue.tests.offline",
            remoteKey: "fieldservice.remote.tests.offline",
            isOnline: false
        )
        XCTAssertEqual(restored.pendingSyncCount, 1)
    }

    func testSyncFlushesQueueWhenOnline() {
        let defaults = UserDefaults(suiteName: UUID().uuidString)!
        let store = FieldServiceStore(
            defaults: defaults,
            jobsKey: "fieldservice.jobs.tests.sync",
            queueKey: "fieldservice.queue.tests.sync",
            remoteKey: "fieldservice.remote.tests.sync",
            isOnline: false
        )

        store.execute(.createJob(title: "Meter Read", location: "Warehouse", note: "", priority: .medium))
        XCTAssertEqual(store.pendingSyncCount, 1)

        store.setOnline(true)

        XCTAssertEqual(store.pendingSyncCount, 0)
        XCTAssertNotNil(store.lastSyncAt)
    }

    func testConflictResolutionPrefersHigherVersion() {
        let defaults = UserDefaults(suiteName: UUID().uuidString)!
        let store = FieldServiceStore(
            defaults: defaults,
            jobsKey: "fieldservice.jobs.tests.conflict",
            queueKey: "fieldservice.queue.tests.conflict",
            remoteKey: "fieldservice.remote.tests.conflict",
            isOnline: false
        )

        let jobID = store.jobs[0].id
        store.execute(.updateStatus(jobID: jobID, status: .inProgress))

        var remoteJob = store.jobs.first { $0.id == jobID }!
        remoteJob.status = .completed
        remoteJob.version += 1
        remoteJob.updatedAt = remoteJob.updatedAt.addingTimeInterval(60)

        store.seedRemoteStateForTests([remoteJob])
        store.setOnline(true)

        XCTAssertEqual(store.jobs.first { $0.id == jobID }?.status, .completed)
        XCTAssertEqual(store.lastConflictCount, 1)
    }
}
