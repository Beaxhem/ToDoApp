//
//  NotificationCenter.swift
//  ToDoApp
//
//  Created by Ilya Senchukov on 06.11.2020.
//

import UserNotifications

class NotificationCenter {
    static let shared = NotificationCenter()
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleTaskReminderNotification(task: Task) {
        let content = UNMutableNotificationContent()
        content.body = task.title
        content.title = "Notification from ToDoApp"
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: task.startDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification.id.02", content: content, trigger: trigger)
    
        UNUserNotificationCenter.current().add(request)

    }
}
