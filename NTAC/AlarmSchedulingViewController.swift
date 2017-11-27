//
//  AlarmSchedulingViewController.swift
//  NTAC
//
//  Created by user on 20.11.17.
//  Copyright © 2017 Dante. All rights reserved.
//

import UIKit

class AlarmSchedulingViewController: UIViewController {


    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var DatePic: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Save(_ sender: Any) {
        var date = DatePic.date
        let timeInterval = floor(date .timeIntervalSinceReferenceDate / 60.0) * 60.0
        date = NSDate(timeIntervalSinceReferenceDate: timeInterval) as Date
        let alarmItem = AlarmItem(date: date, title: titleField.text!, UUID: UUID().uuidString, enabled: true)
        AlarmList.sharedInstance.addItem(alarmItem) // schedule a local notification to persist this item
        let _ = self.navigationController?.popToRootViewController(animated: true) // return to list view
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
