//
//  ManageDevicesViewController.swift
//  HomeIoT
//
//  Created by Edwin Tam on 27/3/16.
//  Copyright © 2016 Edwin Tam. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var devices = [NSManagedObject]()

class ManageDevicesViewController: UITableViewController {
    
    let CellIdentifier = "tablecell"
    let SegueManageDevices = "ManageDevices"
    
    @IBAction func addDevice(sender: AnyObject) {
        print("Add device")
        let alert = UIAlertController(title: "New Device",
            message: "Add a new device",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
                let textField2 = alert.textFields![1]
                self.saveDevice(textField!.text!, ipaddr: textField2.text!)
                self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)

    }

    func saveDevice(name: String, ipaddr: String) {
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let managedContext: NSManagedObjectContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Device",
            inManagedObjectContext:managedContext)
        
        let device = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        
        device.setValue(name, forKey: "name")
        device.setValue(ipaddr, forKey: "ipaddr")
        
        
        do {
            try managedContext.save()
            
            devices.append(device)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"Device List\""
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: CellIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Device")
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            devices = results as! [NSManagedObject]
            print("Fetched \(devices.count)")
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return devices.count
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            var cell =
            tableView.dequeueReusableCellWithIdentifier(CellIdentifier)
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: CellIdentifier)
            
            let device = devices[indexPath.row]
            cell!.textLabel!.text = device.valueForKey("name") as? String
            cell!.detailTextLabel!.text = (device.valueForKey("ipaddr") as? String)!
            return cell!
    }

    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let device = devices[indexPath.row]
//            let dname = device.valueForKey("name") as? String
//            let dip = (device.valueForKey("ipaddr") as? String)!
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            managedContext.deleteObject(device)

            do {
                try managedContext.save()
                devices.removeAtIndex(indexPath.row)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

}

