//
//  NotificationManager.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/17.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    /// 공유 인스턴스
    static let shared = NotificationManager()
    private init() { }
    
    /// Notification Identifier저장 속성
    var uuidString: String?
    
    /// Notification 설정 저장 속성
    var settings: UNNotificationSettings?
    
    /// Notification 권한을 요청합니다.
    /// - Parameter completion: completion 핸들러
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){ (granted, error) in
            self.fetchNotificationSettings()
            completion(granted)
        }
    }
    
    
    /// 현재 Notification 설정을 저장합니다.
    func fetchNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                self.settings = settings
            }
        }
    }
    
    
    /// Notification을 등록합니다.
    /// - Parameters:
    ///   - date: 알림을 지정할 Date객체
    ///   - repeats: 알림 반복 여부
    func scheduleNotification(todo: TodoEntity, repeats: Bool) {
        let content = UNMutableNotificationContent()
        content.title = "StartToEnd에서 알림이 왔습니다."
        content.body = "계획하신 일을 마무리할 시간 입니다 :)"
        
        var trigger: UNNotificationTrigger?
        if let date = todo.notiDate {
            
            trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date), repeats: todo.isRepeat)
        }
        
        if let trigger = trigger {
            let request = UNNotificationRequest(identifier: "\(todo.reminder)", content: content, trigger: trigger)
            
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    func sendNotification(seconds: Double) {
        let content = UNMutableNotificationContent()
        content.title = "알림 테스트"
        content.body = "테스트용입니다."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("ERROR2: \(error.localizedDescription)")
            }
        }
    }
    
    
    /// 등록한 Noticitation을 제거합니다.
    func removeScheduledNotification(todo: TodoEntity?) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(todo?.reminder)"])
    }
}
