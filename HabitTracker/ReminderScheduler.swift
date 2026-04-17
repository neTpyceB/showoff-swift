import Combine
import Foundation
import UserNotifications

@MainActor
final class ReminderScheduler: ObservableObject {
    func scheduleDaily() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in
            let content = UNMutableNotificationContent()
            content.title = "Habits"
            content.body = "Mark today's habits."

            let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: 9), repeats: true)
            let request = UNNotificationRequest(identifier: "daily-habits", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
}
