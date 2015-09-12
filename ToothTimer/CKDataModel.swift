//
//  CKDataModel.swift
//  ToothTimer
//
//  Created by Feldmaus on 30.08.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//
import Foundation
import CloudKit


protocol ModelDelegate {
  func errorUpdating(error: NSError)
  
  func modelUpdatesWillBegin()
  func modelUpdatesDone()
  func recordAdded(indexPath:NSIndexPath!)
  func recordUpdated(indexPath:NSIndexPath!)
}


class CKDataModel
{
  static let sharedInstance = CKDataModel()
  
  var delegate : ModelDelegate?
  
  let container : CKContainer
  let publicDB : CKDatabase
  let privateDB : CKDatabase
  let userInfo : CKUserInfo
  
  var logItems = [CKLog]()
  
  init() {
    container = CKContainer.defaultContainer()
    publicDB = container.publicCloudDatabase
    privateDB = container.privateCloudDatabase
    userInfo = CKUserInfo(container: container)
  }
  
  func fetchLogs()
  {
    userInfo.userID { (userRecordID, error) -> () in
      if let userRecordID = userRecordID
      { NSLog("fetchLogs(): userId:\(userRecordID)");
        
        let predicate = NSPredicate(format: "user == %@", userRecordID)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: CKLog.recordType, predicate: predicate)
        
        query.sortDescriptors = [sort]
        
        let queryOperation = CKQueryOperation(query: query)
        var newItems = [CKLog]()
        
        queryOperation.resultsLimit = 10
        
        queryOperation.queryCompletionBlock =
          { (queryCursor:CKQueryCursor?, error:NSError?) -> Void in
            
            NSLog("Query completed.")
            
            if let error = error {
              self.delegate?.errorUpdating(error)
            }
            else {
              self.logItems = newItems
              self.delegate?.modelUpdatesDone()
            }
        };
        
        queryOperation.recordFetchedBlock =
          { (record:CKRecord)->Void in
            
            let log = CKLog(record: record, database: self.publicDB)
            
            newItems.append(log)
        }
        
        self.delegate?.modelUpdatesWillBegin()
        
        self.publicDB.addOperation(queryOperation)
      }
    }
    
  }
  
  
  func addLog(log:CKLog)
  { NSLog("addLog(\(log))");
    
    userInfo.userID { (userRecordID, error) -> () in
      if let userRecordID = userRecordID
      { NSLog("addLog(): userId:\(userRecordID)");
        
        log.user = CKReference(recordID: userRecordID, action: CKReferenceAction.None)
        
        let modifyRecordsOperation = CKModifyRecordsOperation()
        
        modifyRecordsOperation.recordsToSave = [log.record]
        
        modifyRecordsOperation.modifyRecordsCompletionBlock = {
          (records: [CKRecord]?, deletedRecordIDs: [CKRecordID]?, error: NSError?) -> Void in
          
          if let error = error {
            self.delegate?.errorUpdating(error)
          }
          else {
            self.logItems.insert(log, atIndex: 0)
            
            self.delegate?.modelUpdatesDone()
          }
        };
        
        self.delegate?.modelUpdatesWillBegin()
        self.publicDB.addOperation(modifyRecordsOperation)
      }
    }
    
    
  }
}