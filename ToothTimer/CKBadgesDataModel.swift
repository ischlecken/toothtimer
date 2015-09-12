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
  
  
  func fetchBadges()
  {
    userInfo.userID { (userRecordID, error) -> () in
      if let userRecordID = userRecordID
      { NSLog("fetchBadges(): usvard:\(userRecordID)");
        
        var newItems = [CKBadge]()
        let queryOperation = self.createQueryOperation(userRecordID,recordType: CKBadge.recordType,resultLimit: 10)
        
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
        
        badge.user = CKReference(recordID: userRecordID, action: CKReferenceAction.None)
        
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