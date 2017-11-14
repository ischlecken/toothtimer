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
  
  let dateFormatter = DateFormatter()
  
  override func viewDidLoad()
  { super.viewDidLoad()
    
    dateFormatter.dateStyle = DateFormatter.Style.short
    dateFormatter.timeStyle = DateFormatter.Style.short
    self.tableView.backgroundColor = UIColor.clear
    
    CKLogsDataModel.sharedInstance.delegate = self
    CKLogsDataModel.sharedInstance.fetchLogs()
    
    CKBadgesDataModel.sharedInstance.delegate = self
    CKBadgesDataModel.sharedInstance.fetchBadges()
    
    logTypeControl.selectedSegmentIndex = 0
    
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int
  { return 1 }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  { let result = self.logTypeControl.selectedSegmentIndex==0 ? self.logs.count : self.badges.count
    
    print("tableView(): numberOfRowsInSection=\(result)")
    
    return result
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    if self.logTypeControl.selectedSegmentIndex==0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      let log  = logs[indexPath.row]
      
      cell.textLabel?.text = "\(log.what):\(log.durationinseconds)"
      cell.detailTextLabel?.text = self.dateFormatter.string(from: log.logts as Date)
      
      return cell
    }
    else {
      let cell   = tableView.dequeueReusableCell(withIdentifier: "badgeCell", for: indexPath) as! BadgeTableViewCell
      let badge  = self.badges[indexPath.row]
      
      cell.badgeNameLabel.text      = badge.name
      cell.badgeTimestampLabel.text = self.dateFormatter.string(from: badge.createts as Date) + badge.userID.recordName
      cell.badgeImageView.image     = UIImage(named: "badge-"+badge.name)
      
      cell.badgeImageView.image     = cell.badgeImageView.image?.circleImageWithSize((cell.badgeImageView.image?.size)!,
        circleColor: UIColor.colorWithName(ColorName.titleColor.rawValue) as! UIColor,
        disabled: false)
      
      cell.badgeImageView.image     = cell.badgeImageView.image?.dropShadow(UIColor.white)
      
      return cell
    }
  }
  
  // MARK: ModelDelegate
  
  func errorUpdating(_ error: Error) {
    print("errorUpdating(%@)",error)
    
    self.logs = CKLogsDataModel.sharedInstance.logItems
    self.badges = CKBadgesDataModel.sharedInstance.badges
    
    DispatchQueue.main.async { () -> Void in
      self.tableView.reloadData()
    }
  }
  
  func modelUpdatesWillBegin() {
    print("modelUpdatesWillBegin()")
    
  }
  
  func modelUpdatesDone() {
    self.logs = CKLogsDataModel.sharedInstance.logItems
    self.badges = CKBadgesDataModel.sharedInstance.badges
    
    print("modelUpdatesDone(): logsCount=\(self.logs.count)")
    
    DispatchQueue.main.async { () -> Void in
      self.tableView.reloadData()
    }
  }
  
  func recordAdded(_ indexPath:IndexPath!) {
    print("recordAdded()")
    
  }
  
  func recordUpdated(_ indexPath:IndexPath!) {
    print("recordUpdated()")
    
  }

  @IBAction func logTypeAction(_ sender: AnyObject) {
    self.tableView.reloadData()
  }
  
  @IBAction func doneAction(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
  }
}
