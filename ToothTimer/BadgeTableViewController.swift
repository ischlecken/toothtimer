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
  
  override func viewDidLoad()
  { super.viewDidLoad()
    
    CKBadgesDataModel.sharedInstance.delegate = self
    CKBadgesDataModel.sharedInstance.fetchBadges()
    
    CKBadgesDataModel.sharedInstance.addSubscriptionForBadges()
    
    self.tableView.backgroundColor = UIColor.clearColor()
  }

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int
  { return 1 }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  { return self.badges.count }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  { let cell   = tableView.dequeueReusableCellWithIdentifier("badgeCell", forIndexPath: indexPath) as! BadgeTableViewCell
    let badge  = self.badges[indexPath.row]
    
    cell.badgeNameLabel.text      = badge.name
    cell.badgeTimestampLabel.text = "ts:\(badge.createts)"
    cell.badgeImageView.image     = UIImage(named: "badge-"+badge.name)
      
    cell.badgeImageView.image     = cell.badgeImageView.image?.circleImageWithSize((cell.badgeImageView.image?.size)!,
      circleColor: UIColor.colorWithName(ColorName.titleColor.rawValue) as! UIColor,
      disabled: false)
    
    cell.badgeImageView.image     = cell.badgeImageView.image?.dropShadow(UIColor.whiteColor())
    
    return cell
  }
 
  // MARK: ModelDelegate
  
  func errorUpdating(error: NSError) {
    NSLog("errorUpdating(%@)",error)
    
    self.badges = CKBadgesDataModel.sharedInstance.badges
    
    self.tableView.reloadData();
  }
  
  func modelUpdatesWillBegin() {
    NSLog("modelUpdatesWillBegin()")
    
  }
  
  func modelUpdatesDone() {
    self.badges = CKBadgesDataModel.sharedInstance.badges
    
    NSLog("modelUpdatesDone(): logsCount=\(self.badges.count)")
    
    self.tableView.reloadData();
  }
  
  func recordAdded(indexPath:NSIndexPath!) {
    NSLog("recordAdded()")
    
  }
  
  func recordUpdated(indexPath:NSIndexPath!) {
    NSLog("recordUpdated()")
    
  }

}
