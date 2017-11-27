//
//  AppDelegate.swift
//  NTAC
//
//  Created by user on 20.11.17.
//  Copyright © 2017 Dante. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var audioPlayer: AVAudioPlayer?
    let alarmScheduler: AlarmSchedulerDelegate = Scheduler()
    var alarms: [AlarmItem] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        
        let item = AlarmItem(date: notification.fireDate!, title: notification.userInfo!["title"] as! String, UUID: notification.userInfo!["UUID"] as! String!, enabled: notification.userInfo!["enabled"] as! Bool)
        switch (identifier!) {
        case "Snooze":
            alarmScheduler.scheduleReminder(forItem: item)
        default: // switch statements must be exhaustive - this condition should never be met
            print("Error: unexpected notification action identifier!")
        }
        completionHandler() // per developer documentation, app will terminate if we fail to call this
    }
    
    func playSound() {
        
        //vibrate phone first
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        //set vibrate callback
        AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil, nil,
        {
            (_:SystemSoundID, _:UnsafeMutableRawPointer?) -> Void in
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }, nil)
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "alarm", ofType: "mp3")!)
        
        var error: NSError?
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if let err = error {
            print("audioPlayer error \(err.localizedDescription)")
            return
        } else {
            audioPlayer!.prepareToPlay()
        }
        
        //negative number means loop infinity
        audioPlayer!.numberOfLoops = -1
        audioPlayer!.play()
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        var uuid: String = ""
        if let userInfo = notification.userInfo {
                uuid = userInfo["UUID"] as! String
        }
        playSound()
        let storageController = UIAlertController(title: "Alarm", message: nil, preferredStyle: .alert)
        let stopOption = UIAlertAction(title: "OK", style: .default) {
            (action:UIAlertAction)->Void in self.audioPlayer?.stop()
            AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
            self.alarms = AlarmList.sharedInstance.allItems()
            for i in 0..<self.alarms.count{
                if(self.alarms[i].UUID == uuid){
                    self.alarms[i].enabled = false
                    AlarmList.sharedInstance.changeItem(self.alarms[i])
                    self.alarmScheduler.removeNotification(self.alarms[i])
                }
            }
            
        }
        storageController.addAction(stopOption)
        window?.rootViewController?.present(storageController, animated: true, completion: nil)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {

    }
    
    //AVAudioPlayerDelegate protocol
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

