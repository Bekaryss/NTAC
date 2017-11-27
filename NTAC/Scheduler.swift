//
//  Scheduler.swift
//  NTAC
//
//  Created by Alua Kosamanova on 24.11.2017.
//  Copyright © 2017 Dante. All rights reserved.
//

import Foundation
import UIKit

class Scheduler: AlarmSchedulerDelegate
{
    func setupNotificationSettings(){
        // Specify the notification types.
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.sound]
        // Specify the notification actions.
        let stopAction = UIMutableUserNotificationAction()
        stopAction.identifier = "Alarm"
        stopAction.title = "OK"
        stopAction.activationMode = UIUserNotificationActivationMode.background
        stopAction.isDestructive = false
        stopAction.isAuthenticationRequired = false
        
        let snoozeAction = UIMutableUserNotificationAction()
        snoozeAction.identifier = "Snooze"
        snoozeAction.title = "Snooze"
        snoozeAction.activationMode = UIUserNotificationActivationMode.background
        snoozeAction.isDestructive = false
        snoozeAction.isAuthenticationRequired = false
        
        let actionsArray = [UIUserNotificationAction](arrayLiteral: stopAction, snoozeAction)
        let actionsArrayMinimal = [UIUserNotificationAction](arrayLiteral: stopAction, snoozeAction)
        
        let alarmCategory = UIMutableUserNotificationCategory()
        alarmCategory.identifier = "myAlarmCategory"
        alarmCategory.setActions(actionsArray, for: .default)
        alarmCategory.setActions(actionsArrayMinimal, for: .minimal)
        let categoriesForSettings = Set(arrayLiteral: alarmCategory)
        // Register the notification settings.
        let newNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: categoriesForSettings)
        UIApplication.shared.registerUserNotificationSettings(newNotificationSettings)
    }
    
    func setNotificationWithDate(_ item: AlarmItem){
        let notification = UILocalNotification()
        notification.alertBody = "Alarm Item \"\(item.title)\" Is Overdue"
        notification.alertAction = "open"
        notification.fireDate = correctDate(item.date) as Date
        notification.soundName = "alarm.mp3"
        notification.userInfo = ["title": item.title, "UUID": item.UUID, "enabled": item.enabled]
        notification.category = "myAlarmCategory"
        UIApplication.shared.scheduleLocalNotification(notification)
        setupNotificationSettings()
    }
    
    func removeNotification(_ item: AlarmItem){
        let scheduledNotifications: [UILocalNotification]? = UIApplication.shared.scheduledLocalNotifications
        guard scheduledNotifications != nil else {return} // Nothing to remove, so return
        
        for notification in scheduledNotifications! { // loop through notifications...
            if (notification.userInfo!["UUID"] as! String == item.UUID) { // ...and cancel the notification that corresponds to this TodoItem instance (matched
                UIApplication.shared.cancelLocalNotification(notification) // there should be a maximum of one match on UUID
                break
            }
        }
    }
    func correctDate(_ date: Date) -> Date
    {
        var correctedDate: Date = Date()
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let now = Date()
        if date < now {
            correctedDate = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: date, options:.matchStrictly)!
        }
        else {
            correctedDate = date
        }
        return correctedDate
    }
    
    func reSchedule() {
        //cancel all and register all is often more convenient
        UIApplication.shared.cancelAllLocalNotifications()
        var alarms: [AlarmItem] = []
        alarms = AlarmList.sharedInstance.allItems()
        for i in 0..<alarms.count{
            let alarm = alarms[i]
            if alarm.enabled {
                setNotificationWithDate(alarm)
            }
        }
    }
    
    func scheduleReminder(forItem item: AlarmItem) {
        let notification = UILocalNotification() // create a new reminder notification
        notification.alertBody = "Reminder: Alarm Item \"\(item.title)\" Is Overdue" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = Date(timeIntervalSinceNow: 60) // 30 minutes from current time
        notification.soundName = "alarm.mp3" // play default sound
        notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification that we can use to retrieve it later
        notification.category = "myAlarmCategory"
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
}
