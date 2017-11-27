//
//  AlarmTableViewController.swift
//  NTAC
//
//  Created by user on 20.11.17.
//  Copyright © 2017 Dante. All rights reserved.
//

import UIKit

class AlarmTableViewController: UITableViewController {

    var alarmItems: [AlarmItem] = []
    var alarmScheduler: AlarmSchedulerDelegate = Scheduler()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshList()
    }
    
    func refreshList() {
        alarmItems = AlarmList.sharedInstance.allItems()
        if (alarmItems.count >= 64) {
            self.navigationItem.rightBarButtonItem!.isEnabled = false // disable 'add' button
        }
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return alarmItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath)
        let alarmItem = alarmItems[(indexPath as NSIndexPath).row] as AlarmItem
        cell.detailTextLabel?.text = alarmItem.title as String!
        if (alarmItem.isOverdue) {
            cell.detailTextLabel?.textColor = UIColor.red
        } else {
            cell.detailTextLabel?.textColor = UIColor.black
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        cell.textLabel?.text = dateFormatter.string(from: alarmItem.date as Date)
        
        let sw = UISwitch(frame: CGRect())
        sw.transform = CGAffineTransform(scaleX: 0.9, y: 0.9);
        
        sw.tag = indexPath.row
        sw.addTarget(self, action: #selector(AlarmTableViewController.switchTapped(_:)), for: UIControlEvents.valueChanged)
        if alarmItem.enabled {
            cell.backgroundColor = UIColor.white
            cell.textLabel?.alpha = 1.0
            cell.detailTextLabel?.alpha = 1.0
            sw.setOn(true, animated: false)
        } else {
            cell.backgroundColor = UIColor.groupTableViewBackground
            cell.textLabel?.alpha = 0.5
            cell.detailTextLabel?.alpha = 0.5
        }
        cell.accessoryView = sw
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return cell
    }
    @IBAction func switchTapped(_ sender: UISwitch) {
        let index = sender.tag
        alarmItems[index].enabled = sender.isOn
        if sender.isOn {
            print("switch on")
            alarmScheduler.setNotificationWithDate(alarmItems[index])
            AlarmList.sharedInstance.changeItem(alarmItems[index])
            tableView.reloadData()
        }
        else {
            print("switch off")
            alarmItems[index].enabled = false
            alarmScheduler.removeNotification(alarmItems[index])
            AlarmList.sharedInstance.changeItem(alarmItems[index])
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // all cells are editable
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { // the only editing style we'll support
            // delete the row from the data source
            let item = alarmItems.remove(at: (indexPath as NSIndexPath).row) // remove TodoItem from notifications array, assign removed item to 'item'
            tableView.deleteRows(at: [indexPath], with: .fade)
            AlarmList.sharedInstance.removeItem(item) // delete backing property list entry and unschedule local notification (if it still exists)
            self.navigationItem.rightBarButtonItem!.isEnabled = true // we definitely have under 64 notifications scheduled now, make sure 'add' button is enabled
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
