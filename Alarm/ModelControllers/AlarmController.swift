//
//  AlarmController.swift
//  Alarm
//
//  Created by Steve Lederer on 12/1/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

import Foundation
import UserNotifications

//var mockAlarms = {
//    [Alarm(fireDate: Date(timeIntervalSinceNow: 100 * 60), name: "Wake Up", enabled: true),
//     Alarm(fireDate: Date(timeIntervalSinceNow: 900 * 60), name: "Gym", enabled: true),
//     Alarm(fireDate: Date(timeIntervalSinceNow: 1200 * 60), name: "Class", enabled: true)
//    ]
//}

protocol AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm) {
        let alarmNotification = UNMutableNotificationContent()
        alarmNotification.title = "\(alarm.name)"
        alarmNotification.body = "Alarm is going off."
        alarmNotification.sound = UNNotificationSound.default
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: alarmNotification, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("💩 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
            }
        }
    }
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}

class AlarmController: AlarmScheduler {
    
    // MARK: - shared instance
    static let shared = AlarmController()
    
    // MARK: - source of truth
    var alarms: [Alarm] = []
    
    init() {
        //        self.alarms = mockAlarms()
        loadFromPersistentStore()
    }
    
    // MARK: - CRUD functions
    @discardableResult
    func addAlarm(fireDate: Date, name: String, enabled: Bool) -> Alarm {
        let alarm = Alarm(fireDate: fireDate, name: name, enabled: enabled)
        alarms.append(alarm)
        saveToPersistentStore()
        scheduleUserNotifications(for: alarm)
        return alarm
    }
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        saveToPersistentStore()
    }
    
    func delete(alarm: Alarm) {
        let alarm = alarm
        guard let indexPath = alarms.index(of: alarm) else { return }
        alarms.remove(at: indexPath)
        cancelUserNotifications(for: alarm)
        saveToPersistentStore()
    }
    
    func toggleEnabled(for alarm: Alarm) {
        let alarm = alarm
        if alarm.enabled == true {
            alarm.enabled = false
            cancelUserNotifications(for: alarm)
        } else {
            alarm.enabled = true
            scheduleUserNotifications(for: alarm)
        }
    }
    
    // MARK: - Persistence
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = "alarm.JSON"
        let fullURL = documentDirectory.appendingPathComponent(fileName)
        return fullURL
    }
    func saveToPersistentStore() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self.alarms)
            try data.write(to: fileURL())
        } catch let e {
            print("There was an error saving to persistent storage: \(e.localizedDescription)")
        }
    }
    func loadFromPersistentStore() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let alarms = try decoder.decode([Alarm].self, from: data)
            self.alarms = alarms
        } catch let e {
            print("There was an error loading from persistent storage: \(e.localizedDescription)")
        }
    }
}

