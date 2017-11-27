//
//  AlarmSchedulerDelegate.swift
//  NTAC
//
//  Created by Alua Kosamanova on 24.11.2017.
//  Copyright © 2017 Dante. All rights reserved.
//

import Foundation

protocol AlarmSchedulerDelegate {
    func setNotificationWithDate(_ item: AlarmItem)
    func removeNotification(_ item: AlarmItem)
    func scheduleReminder(forItem item: AlarmItem)
    func correctDate(_ date: Date) -> Date
}
