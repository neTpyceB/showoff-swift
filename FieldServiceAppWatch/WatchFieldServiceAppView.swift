import SwiftUI

struct WatchFieldServiceAppView: View {
    @ObservedObject var store: FieldServiceStore

    var body: some View {
        List {
            Section("Sync") {
                Toggle(
                    "Online",
                    isOn: Binding(
                        get: { store.isOnline },
                        set: { store.setOnline($0) }
                    )
                )
                .accessibilityIdentifier("watch-online-toggle")

                Text("Pending \(store.pendingSyncCount)")

                if store.lastConflictCount > 0 {
                    Text("Conflicts \(store.lastConflictCount)")
                }
            }

            Section("Jobs") {
                ForEach(store.jobs.prefix(5)) { job in
                    Button {
                        let nextStatus: FieldJobStatus
                        switch job.status {
                        case .open:
                            nextStatus = .inProgress
                        case .inProgress:
                            nextStatus = .completed
                        case .completed:
                            nextStatus = .completed
                        }
                        store.execute(.updateStatus(jobID: job.id, status: nextStatus))
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(job.title)
                            Text(job.status.rawValue)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .accessibilityIdentifier("watch-job-\(job.id.uuidString)")
                }
            }

            Section {
                Button("Sync Now") {
                    store.syncNow()
                }
                .accessibilityIdentifier("watch-sync-now")
            }
        }
        .navigationTitle("Field")
    }
}
