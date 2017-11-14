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
    let subscription = CKSubscription(recordType: CKBadge.recordType,predicate: predicate, options: .firesOnRecordCreation)
    let notificationInfo = CKNotificationInfo()
    
    notificationInfo.alertBody = "A Badge was added"
    notificationInfo.shouldBadge = true
    
    subscription.notificationInfo = notificationInfo
    
    self.publicDB.save(subscription,
      completionHandler: ({ returnRecord, error in
        if let err = error {
          print("subscription failed %@",err.localizedDescription)
        } else {
          print("Subscription set up successfully")
        }
      }))
  }
  
  func addDeletionSubscriptionForBadges()
  {
    let predicate = NSPredicate(format: "TRUEPREDICATE")
    let subscription = CKSubscription(recordType: CKBadge.recordType,predicate: predicate, options: .firesOnRecordDeletion)
    let notificationInfo = CKNotificationInfo()
    
    notificationInfo.alertBody = "A Badge was deleted"
    notificationInfo.shouldBadge = true
    
    subscription.notificationInfo = notificationInfo
    
    self.publicDB.save(subscription,
      completionHandler: ({ returnRecord, error in
        if let err = error {
          print("subscription failed %@",err.localizedDescription)
        } else {
          print("Subscription set up successfully")
        }
      }))
  }
  
  func fetchBadges()
  {
    userInfo.userID { (userRecordID, error) -> () in
      if let userRecordID = userRecordID
      { print("fetchBadges(): usvard:\(userRecordID)");
        
        var newItems = [CKBadge]()
        let queryOperation = self.createQueryOperation(userRecordID,recordType: CKBadge.recordType,resultLimit: 100)
        
        queryOperation.queryCompletionBlock =
          { (queryCursor:CKQueryCursor?, error:Error?) -> Void in
            
            print("Query completed.")
            
            if let error = error {
              self.delegate?.errorUpdating(error)
            }
            else {
              self.badges = newItems
              self.delegate?.modelUpdatesDone()
            }
        }
        
        queryOperation.recordFetchedBlock =
          { (record:CKRecord)->Void in
            
            let badge = CKBadge(record: record, database: self.usedDB)
            
            newItems.append(badge)
        }
        
        self.delegate?.modelUpdatesWillBegin()
        
        self.usedDB.add(queryOperation)
      }
    }
  }
  
  func addBadge(_ badge:CKBadge)
  { print("addBadge(\(badge))");
    
    userInfo.userID { (userRecordID, error) -> () in
      if let userRecordID = userRecordID
      { print("addBadge(): userId:\(userRecordID)");
        
        let modifyRecordsOperation = CKModifyRecordsOperation()
    
        modifyRecordsOperation.recordsToSave = [badge.record]
        
        modifyRecordsOperation.modifyRecordsCompletionBlock = {
          (records: [CKRecord]?, deletedRecordIDs: [CKRecordID]?, error: Error?) -> Void in
          
          if let error = error {
            self.delegate?.errorUpdating(error)
          }
          else {
            self.badges.insert(badge, at: 0)
            
            self.delegate?.modelUpdatesDone()
          }
        }
        
        self.delegate?.modelUpdatesWillBegin()
        self.usedDB.add(modifyRecordsOperation)
      }
    }
  }
}
