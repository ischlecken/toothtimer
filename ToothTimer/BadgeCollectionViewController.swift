//
//  LogViewController.swift
//  ToothTimer
//
//  Created by Feldmaus on 27.06.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import UIKit
import CoreData

private let cellIdentifier = "Cell"

class BadgeCollectionViewController: UICollectionViewController, ModelDelegate
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
    
    self.collectionView!.backgroundColor = UIColor.clearColor()
  }

  // MARK: ModelDelegate
  
  func errorUpdating(error: NSError) {
    NSLog("errorUpdating(%@)",error)
    
    self.badges = CKBadgesDataModel.sharedInstance.badges
    
    dispatch_async(dispatch_get_main_queue()) { () -> Void in
      self.collectionView!.reloadData()
    }
    
  }
  
  func modelUpdatesWillBegin() {
    NSLog("modelUpdatesWillBegin()")
    
  }
  
  func modelUpdatesDone() {
    self.badges = CKBadgesDataModel.sharedInstance.badges
    
    NSLog("modelUpdatesDone(): logsCount=\(self.badges.count)")
    
    dispatch_async(dispatch_get_main_queue()) { () -> Void in
      self.collectionView!.reloadData()
    }

  }
  
  func recordAdded(indexPath:NSIndexPath!) {
    NSLog("recordAdded()")
    
  }
  
  func recordUpdated(indexPath:NSIndexPath!) {
    NSLog("recordUpdated()")
    
  }
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.badges.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell      = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
    let badge     = self.badges[indexPath.row]
    let imageView = cell.viewWithTag(100) as! UIImageView
    let nameView  = cell.viewWithTag(101) as! UILabel
    let countView = cell.viewWithTag(102) as! UILabel
    
    imageView.image = UIImage(named: "badge-"+badge.name)
    
    imageView.image = imageView.image?.circleImageWithSize((imageView.image?.size)!,
      circleColor: UIColor.colorWithName(ColorName.titleColor.rawValue) as! UIColor,
      disabled: false)
    
    imageView.image = imageView.image?.dropShadow(UIColor.whiteColor())
    
    nameView.text  = badge.name
    countView.text = "99"
    countView.layer.cornerRadius = countView.bounds.size.height/2.0
    countView.layer.borderColor = UIColor.whiteColor().CGColor
    countView.layer.borderWidth = 2.0
    countView.layer.masksToBounds = true
    
    return cell
  }


  // MARK: UICollectionViewDelegate
  
  override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
  }

}
