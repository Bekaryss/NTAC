//
//  AlarmList.swift
//  NTAC
//
//  Created by user on 20.11.17.
//  Copyright © 2017 Dante. All rights reserved.
//

import UIKit

class AlarmList{
    
    class var sharedInstance : AlarmList {
        struct Static {
            static let instance: AlarmList = AlarmList()
        }
        return Static.instance
    }
    var alarmScheduler: AlarmSchedulerDelegate = Scheduler()
    fileprivate let ITEMS_KEY = "alarmItems"
    
    func addItem(_ item: AlarmItem) {
        // persist a representation of this todo item in UserDefaults
        var todoDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? Dictionary() 
        // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        todoDictionary[item.UUID] = ["date": alarmScheduler.correctDate(item.date), "title": item.title, "UUID": item.UUID, "enabled": item.enabled]
        // store NSData representation of todo item in dictionary with UUID as key
        UserDefaults.standard.set(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        alarmScheduler.setNotificationWithDate(item)
    }
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
    
    func allItems() -> [AlarmItem] {
        let alarmDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? [:]
        let items = Array(alarmDictionary.values)
        return items.map({
            let item = $0 as! [String:AnyObject]
            return AlarmItem(date: item["date"] as! Date, title: item["title"] as! String, UUID: item["UUID"] as! String!, enabled: item["enabled"] as! Bool )
        }).sorted(by: {(left: AlarmItem, right: AlarmItem) -> Bool in
            (left.date.compare(right.date) == .orderedAscending)
        })
    }
    
    func removeItem(_ item: AlarmItem) {
        alarmScheduler.removeNotification(item)
        if var alarmItems = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) {
            alarmItems.removeValue(forKey: item.UUID)
            UserDefaults.standard.set(alarmItems, forKey: ITEMS_KEY)
        }
    }
    
    func changeItem(_ item: AlarmItem) {
        var alarms: [AlarmItem] = []
        alarms = allItems()
        if var alarmItems = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) {
            alarmItems.removeAll()
            for i in 0..<alarms.count{
                if (alarms[i].UUID == item.UUID){
                    alarms[i] = item
                    
                }
                alarmItems[alarms[i].UUID] = ["date": alarmScheduler.correctDate(alarms[i].date), "title": alarms[i].title, "UUID": alarms[i].UUID, "enabled": alarms[i].enabled]
            }
            UserDefaults.standard.set(alarmItems, forKey: ITEMS_KEY)
        }
        
    }
    
    

}
