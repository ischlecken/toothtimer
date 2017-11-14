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
  let dateFormatter = DateFormatter()
  
  override func viewDidLoad()
  { super.viewDidLoad()
    
    dateFormatter.dateStyle = DateFormatter.Style.short
    dateFormatter.timeStyle = DateFormatter.Style.short
    
    CKBadgesDataModel.sharedInstance.delegate = self
    CKBadgesDataModel.sharedInstance.fetchBadges()
    
    CKBadgesDataModel.sharedInstance.addCreationSubscriptionForBadges()
    CKBadgesDataModel.sharedInstance.addDeletionSubscriptionForBadges()
    
    self.collectionView!.backgroundColor = UIColor.clear
  }

  // MARK: ModelDelegate
  
  func errorUpdating(_ error: Error) {
    print("errorUpdating(%@)",error)
    
    self.badges = CKBadgesDataModel.sharedInstance.badges
    
    DispatchQueue.main.async { () -> Void in
      self.collectionView!.reloadData()
    }
    
  }
  
  func modelUpdatesWillBegin() {
    print("modelUpdatesWillBegin()")
    
  }
  
  func modelUpdatesDone() {
    self.badges = CKBadgesDataModel.sharedInstance.badges
    
    print("modelUpdatesDone(): logsCount=\(self.badges.count)")
    
    DispatchQueue.main.async { () -> Void in
      self.collectionView!.reloadData()
    }

  }
  
  func recordAdded(_ indexPath:IndexPath!) {
    print("recordAdded()")
    
  }
  
  func recordUpdated(_ indexPath:IndexPath!) {
    print("recordUpdated()")
    
  }
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.badges.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell      = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
    let badge     = self.badges[indexPath.row]
    let imageView = cell.viewWithTag(100) as! UIImageView
    let nameView  = cell.viewWithTag(101) as! UILabel
    let countView = cell.viewWithTag(102) as! UILabel
    
    imageView.image = UIImage(named: "badge-"+badge.name)
    
    imageView.image = imageView.image?.circleImageWithSize((imageView.image?.size)!,
      circleColor: UIColor.colorWithName(ColorName.titleColor.rawValue) as! UIColor,
      disabled: false)
    
    imageView.image = imageView.image?.dropShadow(UIColor.white)
    
    nameView.text  = badge.name
    countView.text = "99"
    countView.layer.cornerRadius = countView.bounds.size.height/2.0
    countView.layer.borderColor = UIColor.white.cgColor
    countView.layer.borderWidth = 2.0
    countView.layer.masksToBounds = true
    
    return cell
  }


  // MARK: UICollectionViewDelegate
  
  override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  }

}
