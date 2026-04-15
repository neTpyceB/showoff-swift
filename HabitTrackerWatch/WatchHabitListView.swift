import SwiftUI

struct WatchHabitListView: View {
    @ObservedObject var store: HabitStore
    let sync: HabitSync

    var body: some View {
        List(store.habits) { habit in
            Button {
                sync.markDone(id: habit.id)
            } label: {
                HStack {
                    Text(habit.name)
                    Spacer()
                    Image(systemName: habit.isDoneToday ? "checkmark.circle.fill" : "circle")
                }
            }
        }
    }
}
