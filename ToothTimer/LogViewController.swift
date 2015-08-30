//
//  LogViewController.swift
//  ToothTimer
//
//  Created by Feldmaus on 27.06.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import UIKit
import CoreData

class LogViewController: UITableViewController, ModelDelegate
{
  var logs = [CKLog]()
  
  override func viewDidLoad()
  { super.viewDidLoad()
    
    self.tableView.backgroundColor = UIColor.clearColor()
    
    CKDataModel.sharedInstance.delegate = self
    
    CKDataModel.sharedInstance.fetchLogs()
    
  }

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int
  { return 1 }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  { let result = self.logs.count
    
    return result
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  { let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
    let log  = logs[indexPath.row]
    
    cell.textLabel?.text = "\(log.status):\(log.durationinseconds)"
    cell.detailTextLabel?.text = "ts:\(log.logts)"
    
    return cell
  }
  
  // MARK: ModelDelegate
  
  func errorUpdating(error: NSError) {
    NSLog("errorUpdating(%@)",error)
    
  }
  
  func modelUpdatesWillBegin() {
    NSLog("modelUpdatesWillBegin()")
    
  }
  
  func modelUpdatesDone() {
    NSLog("modelUpdatesDone()")
    
    self.logs = CKDataModel.sharedInstance.logItems
  }
  
  func recordAdded(indexPath:NSIndexPath!) {
    NSLog("recordAdded()")
    
  }
  
  func recordUpdated(indexPath:NSIndexPath!) {
    NSLog("recordUpdated()")
    
  }

}
