import Foundation
import UserNotifications

struct FitnessReminderScheduler {
    func scheduleDaily() async {
        let center = UNUserNotificationCenter.current()
        _ = try? await center.requestAuthorization(options: [.alert, .sound])

        let content = UNMutableNotificationContent()
        content.title = "Fitness Dashboard"
        content.body = "Log today's workout."

        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: 8), repeats: true)
        let request = UNNotificationRequest(identifier: "daily-fitness-reminder", content: content, trigger: trigger)
        try? await center.add(request)
    }
}
