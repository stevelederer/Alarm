//
//  Alarm.swift
//  Alarm
//
//  Created by Steve Lederer on 12/1/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

import Foundation

class Alarm: Equatable, Codable {
    
    var fireDate: Date
    var name: String
    var enabled: Bool
    let uuid: String = UUID().uuidString
    var fireTimeAsString: String {
        return fireDate.stringValue()
    }
    
    init(fireDate: Date, name: String, enabled: Bool) {
        self.fireDate = fireDate
        self.name = name
        self.enabled = enabled
    }
    
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

extension Date {
    func stringValue() -> String {
        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
