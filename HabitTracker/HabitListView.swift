import SwiftUI

struct HabitListView: View {
    @ObservedObject var store: HabitStore
    let sync: HabitSync
    @State private var isAdding = false
    @StateObject private var reminders = ReminderScheduler()

    var body: some View {
        NavigationStack {
            List {
                ProgressView(value: Double(store.completedToday), total: Double(max(store.habits.count, 1)))
                    .accessibilityIdentifier("habit-progress")

                ForEach(store.habits) { habit in
                    Button {
                        store.toggle(id: habit.id)
                        sync.sendSnapshot()
                    } label: {
                        HStack {
                            Text(habit.name)
                            Spacer()
                            Image(systemName: habit.isDoneToday ? "checkmark.circle.fill" : "circle")
                        }
                    }
                    .accessibilityIdentifier("habit-\(habit.name)")
                }
                .onDelete { offsets in
                    store.delete(at: offsets)
                    sync.sendSnapshot()
                }
            }
            .navigationTitle("Habits")
            .toolbar {
                Button("Reminder") {
                    reminders.scheduleDaily()
                }
                .accessibilityIdentifier("schedule-reminder")

                Button {
                    isAdding = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityIdentifier("add-habit")
            }
            .sheet(isPresented: $isAdding) {
                AddHabitView { name in
                    store.add(name)
                    sync.sendSnapshot()
                    isAdding = false
                }
            }
        }
    }
}
