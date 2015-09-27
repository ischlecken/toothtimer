//
//  LogsViewController.swift
//  ToothTimer
//
//  Created by Feldmaus on 27.09.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation


class LogsViewController : UITableViewController, ModelDelegate {
  
  @IBOutlet weak var logTypeControl: UISegmentedControl!
  
  var logs = [CKLog]()
  var badges = [CKBadge]()
  
  let dateFormatter = NSDateFormatter()
  
  override func viewDidLoad()
  { super.viewDidLoad()
    
    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    self.tableView.backgroundColor = UIColor.clearColor()
    
    CKLogsDataModel.sharedInstance.delegate = self
    CKLogsDataModel.sharedInstance.fetchLogs()
    
    CKBadgesDataModel.sharedInstance.delegate = self
    CKBadgesDataModel.sharedInstance.fetchBadges()
    
    logTypeControl.selectedSegmentIndex = 0
    
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int
  { return 1 }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  { let result = self.logTypeControl.selectedSegmentIndex==0 ? self.logs.count : self.badges.count
    
    NSLog("tableView(): numberOfRowsInSection=\(result)")
    
    return result
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    if self.logTypeControl.selectedSegmentIndex==0 {
      let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
      let log  = logs[indexPath.row]
      
      cell.textLabel?.text = "\(log.what):\(log.durationinseconds)"
      cell.detailTextLabel?.text = self.dateFormatter.stringFromDate(log.logts)
      
      return cell
    }
    else {
      let cell   = tableView.dequeueReusableCellWithIdentifier("badgeCell", forIndexPath: indexPath) as! BadgeTableViewCell
      let badge  = self.badges[indexPath.row]
      
      cell.badgeNameLabel.text      = badge.name
      cell.badgeTimestampLabel.text = self.dateFormatter.stringFromDate(badge.createts) + badge.userID.recordName
      cell.badgeImageView.image     = UIImage(named: "badge-"+badge.name)
      
      cell.badgeImageView.image     = cell.badgeImageView.image?.circleImageWithSize((cell.badgeImageView.image?.size)!,
        circleColor: UIColor.colorWithName(ColorName.titleColor.rawValue) as! UIColor,
        disabled: false)
      
      cell.badgeImageView.image     = cell.badgeImageView.image?.dropShadow(UIColor.whiteColor())
      
      return cell
    }
  }
  
  // MARK: ModelDelegate
  
  func errorUpdating(error: NSError) {
    NSLog("errorUpdating(%@)",error)
    
    self.logs = CKLogsDataModel.sharedInstance.logItems
    self.badges = CKBadgesDataModel.sharedInstance.badges
    
    dispatch_async(dispatch_get_main_queue()) { () -> Void in
      self.tableView.reloadData()
    }
  }
  
  func modelUpdatesWillBegin() {
    NSLog("modelUpdatesWillBegin()")
    
  }
  
  func modelUpdatesDone() {
    self.logs = CKLogsDataModel.sharedInstance.logItems
    self.badges = CKBadgesDataModel.sharedInstance.badges
    
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

  @IBAction func logTypeAction(sender: AnyObject) {
    self.tableView.reloadData()
  }
  
  @IBAction func doneAction(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}