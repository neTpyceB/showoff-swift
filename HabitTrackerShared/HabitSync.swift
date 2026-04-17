import Foundation
import WatchConnectivity

@MainActor
final class HabitSync: NSObject, ObservableObject, WCSessionDelegate {
    private let store: HabitStore

    init(store: HabitStore) {
        self.store = store
        super.init()
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    func sendSnapshot() {
        if WCSession.default.activationState == .activated {
            try? WCSession.default.updateApplicationContext(["habits": try! JSONEncoder().encode(store.habits)])
        }
    }

    func requestSnapshot() {
        WCSession.default.sendMessage(["snapshot": true], replyHandler: nil)
    }

    func markDone(id: UUID) {
        store.markDone(id: id)
        WCSession.default.sendMessage(["done": id.uuidString], replyHandler: nil)
        sendSnapshot()
    }

    nonisolated func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        Task { @MainActor in
#if os(watchOS)
            requestSnapshot()
#else
            sendSnapshot()
#endif
        }
    }

    nonisolated func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        let data = applicationContext["habits"] as! Data

        Task { @MainActor in
            store.replace(with: try! JSONDecoder().decode([Habit].self, from: data))
        }
    }

    nonisolated func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        let wantsSnapshot = message["snapshot"] as? Bool == true
        let doneID = (message["done"] as? String).flatMap(UUID.init(uuidString:))

        Task { @MainActor in
            if wantsSnapshot {
                sendSnapshot()
            }

            if let id = doneID {
                store.markDone(id: id)
                sendSnapshot()
            }
        }
    }

#if os(iOS)
    nonisolated func sessionDidBecomeInactive(_ session: WCSession) {}

    nonisolated func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
#endif
}
