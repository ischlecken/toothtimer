//
//  CKDataModel.swift
//  ToothTimer
//
//  Created by Feldmaus on 30.08.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//
import Foundation
import CloudKit


class CKBadgesDataModel : CKDataModel
{
  static let sharedInstance = CKBadgesDataModel()
  
  var badges = [CKBadge]()
  
  override init() {
    super.init()
    
    self.usedDB = self.publicDB
  }
  
  
  func addCreationSubscriptionForBadges()
  {
    let predicate = NSPredicate(format: "TRUEPREDICATE")
    let subscription = CKSubscription(recordType: CKBadge.recordType,predicate: predicate, options: .FiresOnRecordCreation)
    let notificationInfo = CKNotificationInfo()
    
    notificationInfo.alertBody = "A Badge was added"
    notificationInfo.shouldBadge = true
    
    subscription.notificationInfo = notificationInfo
    
    self.publicDB.saveSubscription(subscription,
      completionHandler: ({ returnRecord, error in
        if let err = error {
          NSLog("subscription failed %@",err.localizedDescription)
        } else {
          NSLog("Subscription set up successfully")
        }
      }))
  }
  
  func addDeletionSubscriptionForBadges()
  {
    let predicate = NSPredicate(format: "TRUEPREDICATE")
    let subscription = CKSubscription(recordType: CKBadge.recordType,predicate: predicate, options: .FiresOnRecordDeletion)
    let notificationInfo = CKNotificationInfo()
    
    notificationInfo.alertBody = "A Badge was deleted"
    notificationInfo.shouldBadge = true
    
    subscription.notificationInfo = notificationInfo
    
    self.publicDB.saveSubscription(subscription,
      completionHandler: ({ returnRecord, error in
        if let err = error {
          NSLog("subscription failed %@",err.localizedDescription)
        } else {
          NSLog("Subscription set up successfully")
        }
      }))
  }
  
  func fetchBadges()
  {
    userInfo.userID { (userRecordID, error) -> () in
      if let userRecordID = userRecordID
      { NSLog("fetchBadges(): usvard:\(userRecordID)");
        
        var newItems = [CKBadge]()
        let queryOperation = self.createQueryOperation(userRecordID,recordType: CKBadge.recordType,resultLimit: 100)
        
        queryOperation.queryCompletionBlock =
          { (queryCursor:CKQueryCursor?, error:NSError?) -> Void in
            
            NSLog("Query completed.")
            
            if let error = error {
              self.delegate?.errorUpdating(error)
            }
            else {
              self.badges = newItems
              self.delegate?.modelUpdatesDone()
            }
        };
        
        queryOperation.recordFetchedBlock =
          { (record:CKRecord)->Void in
            
            let badge = CKBadge(record: record, database: self.usedDB)
            
            newItems.append(badge)
        }
        
        self.delegate?.modelUpdatesWillBegin()
        
        self.usedDB.addOperation(queryOperation)
      }
    }
  }
  
  func addBadge(badge:CKBadge)
  { NSLog("addBadge(\(badge))");
    
    userInfo.userID { (userRecordID, error) -> () in
      if let userRecordID = userRecordID
      { NSLog("addBadge(): userId:\(userRecordID)");
        
        let modifyRecordsOperation = CKModifyRecordsOperation()
    
        modifyRecordsOperation.recordsToSave = [badge.record]
        
        modifyRecordsOperation.modifyRecordsCompletionBlock = {
          (records: [CKRecord]?, deletedRecordIDs: [CKRecordID]?, error: NSError?) -> Void in
          
          if let error = error {
            self.delegate?.errorUpdating(error)
          }
          else {
            self.badges.insert(badge, atIndex: 0)
            
            self.delegate?.modelUpdatesDone()
          }
        };
        
        self.delegate?.modelUpdatesWillBegin()
        self.usedDB.addOperation(modifyRecordsOperation)
      }
    }
  }
}
