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
  let dateFormatter = NSDateFormatter()
  
  override func viewDidLoad()
  { super.viewDidLoad()
    
    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    self.tableView.backgroundColor = UIColor.clearColor()
    
    CKLogsDataModel.sharedInstance.delegate = self
    
    CKLogsDataModel.sharedInstance.fetchLogs()
    
  }

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int
  { return 1 }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  { let result = self.logs.count
    
    NSLog("tableView(): numberOfRowsInSection=\(result)")
    
    return result
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  { let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
    let log  = logs[indexPath.row]
    
    cell.textLabel?.text = "\(log.status):\(log.durationinseconds)"
    cell.detailTextLabel?.text = self.dateFormatter.stringFromDate(log.logts)
    
    return cell
  }
  
  // MARK: ModelDelegate
  
  func errorUpdating(error: NSError) {
    NSLog("errorUpdating(%@)",error)
    
    self.logs = CKLogsDataModel.sharedInstance.logItems
    
    dispatch_async(dispatch_get_main_queue()) { () -> Void in
      self.tableView.reloadData()
    }
  }
  
  func modelUpdatesWillBegin() {
    NSLog("modelUpdatesWillBegin()")
    
  }
  
  func modelUpdatesDone() {
    self.logs = CKLogsDataModel.sharedInstance.logItems
    
    NSLog("modelUpdatesDone(): logsCount=\(self.logs.count)")
    
    dispatch_async(dispatch_get_main_queue()) { () -> Void in
      self.tableView.reloadData()
    }
  }
  
  func recordAdded(indexPath:NSIndexPath!) {
    NSLog("recordAdded()")
    
  }
  
  func recordUpdated(indexPath:NSIndexPath!) {
    NSLog("recordUpdated()")
    
  }

}
