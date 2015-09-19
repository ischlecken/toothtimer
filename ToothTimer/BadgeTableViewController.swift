//
//  LogViewController.swift
//  ToothTimer
//
//  Created by Feldmaus on 27.06.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import UIKit
import CoreData

class BadgeTableViewController: UITableViewController, ModelDelegate
{
  var badges = [CKBadge]()
  let dateFormatter = NSDateFormatter()
  
  override func viewDidLoad()
  { super.viewDidLoad()
    
    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    
    CKBadgesDataModel.sharedInstance.delegate = self
    CKBadgesDataModel.sharedInstance.fetchBadges()
    
    CKBadgesDataModel.sharedInstance.addCreationSubscriptionForBadges()
    CKBadgesDataModel.sharedInstance.addDeletionSubscriptionForBadges()
    
    self.tableView.backgroundColor = UIColor.clearColor()
  }

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int
  { return 1 }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  { let rowCount = self.badges.count
  
    NSLog("tableRowCount:\(rowCount)")
    
    return rowCount
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  { let cell   = tableView.dequeueReusableCellWithIdentifier("badgeCell", forIndexPath: indexPath) as! BadgeTableViewCell
    let badge  = self.badges[indexPath.row]
    
    cell.badgeNameLabel.text      = badge.name
    cell.badgeTimestampLabel.text = self.dateFormatter.stringFromDate(badge.createts) + badge.userID.recordName
    cell.badgeImageView.image     = UIImage(named: "badge-"+badge.name)
      
    cell.badgeImageView.image     = cell.badgeImageView.image?.circleImageWithSize((cell.badgeImageView.image?.size)!,
      circleColor: UIColor.colorWithName(ColorName.titleColor.rawValue) as! UIColor,
      disabled: false)
    
    cell.badgeImageView.image     = cell.badgeImageView.image?.dropShadow(UIColor.whiteColor())
    
    NSLog("cellForRowAtIndex:\(indexPath.row)")
    
    return cell
  }
 
  // MARK: ModelDelegate
  
  func errorUpdating(error: NSError) {
    NSLog("errorUpdating(%@)",error)
    
    self.badges = CKBadgesDataModel.sharedInstance.badges
    
    dispatch_async(dispatch_get_main_queue()) { () -> Void in
      self.tableView.reloadData()
    }
    
  }
  
  func modelUpdatesWillBegin() {
    NSLog("modelUpdatesWillBegin()")
    
  }
  
  func modelUpdatesDone() {
    self.badges = CKBadgesDataModel.sharedInstance.badges
    
    NSLog("modelUpdatesDone(): logsCount=\(self.badges.count)")
    
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
