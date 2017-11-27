//
//  AlarmItem.swift
//  NTAC
//
//  Created by user on 20.11.17.
//  Copyright © 2017 Dante. All rights reserved.
//

import Foundation


struct AlarmItem{
    var title: String
    var date: Date
    var snoozeEnabled: Bool = false
    var enabled: Bool = false
    
    var UUID: String
    
    init(date: Date, title: String, UUID: String, enabled: Bool) {
        self.date = date
        self.title = title
        self.UUID = UUID
        self.enabled = enabled
    }
    var isOverdue: Bool {
        return (Date().compare(self.date) == ComparisonResult.orderedDescending)
    }
}
