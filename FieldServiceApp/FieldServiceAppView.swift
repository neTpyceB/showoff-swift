import SwiftUI

struct FieldServiceAppView: View {
    @ObservedObject var store: FieldServiceStore
    @State private var isCreatingJob = false

    var body: some View {
        NavigationStack {
            List {
                Section("Sync") {
                    Toggle(
                        "Online",
                        isOn: Binding(
                            get: { store.isOnline },
                            set: { store.setOnline($0) }
                        )
                    )
                    .accessibilityIdentifier("online-toggle")

                    HStack {
                        Text("Pending")
                            .accessibilityIdentifier("pending-sync-label")
                        Spacer()
                        Text("\(store.pendingSyncCount)")
                            .accessibilityIdentifier("pending-sync-value")
                    }

                    HStack {
                        Text("Conflicts")
                        Spacer()
                        Text("\(store.lastConflictCount)")
                    }
                    .accessibilityIdentifier("conflict-count")

                    HStack {
                        Text("Last Sync")
                        Spacer()
                        Text(store.lastSyncLabel)
                            .font(.caption)
                    }
                    .accessibilityIdentifier("last-sync-label")
                }

                Section("Jobs") {
                    ForEach(store.jobs) { job in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(job.title)
                                .accessibilityIdentifier("job-row-title")

                            Text("\(job.location) • \(job.priority.rawValue)")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            if !job.note.isEmpty {
                                Text(job.note)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }

                            Picker(
                                "Status",
                                selection: Binding(
                                    get: { job.status },
                                    set: { store.execute(.updateStatus(jobID: job.id, status: $0)) }
                                )
                            ) {
                                ForEach(FieldJobStatus.allCases) { status in
                                    Text(status.rawValue).tag(status)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                }
            }
            .navigationTitle("Field Service")
            .toolbar {
                Button {
                    isCreatingJob = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityIdentifier("add-job")
            }
            .sheet(isPresented: $isCreatingJob) {
                JobEditorView { title, location, note, priority in
                    store.execute(.createJob(title: title, location: location, note: note, priority: priority))
                }
            }
        }
    }
}
