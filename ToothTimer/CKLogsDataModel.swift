//
//  CKDataModel.swift
//  ToothTimer
//
//  Created by Feldmaus on 30.08.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//
import Foundation
import CloudKit


class CKLogsDataModel : CKDataModel
{
  static let sharedInstance = CKLogsDataModel()
  
  var logItems = [CKLog]()
  
  func fetchLogs()
  {
    userInfo.userID { (userRecordID, error) -> () in
      if let userRecordID = userRecordID
      { NSLog("fetchLogs(): userId:\(userRecordID)");
        
        var newItems = [CKLog]()
        let queryOperation = self.createQueryOperationForCurrentUser(userRecordID,recordType:CKLog.recordType, resultLimit: 10)
        
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
            
            let log = CKLog(record: record, database: self.usedDB)
            
            newItems.append(log)
        }
        
        self.delegate?.modelUpdatesWillBegin()
        
        self.usedDB.addOperation(queryOperation)
      }
    }
  }
  
  func addLog(log:CKLog)
  { NSLog("addLog(\(log))");
    
    userInfo.userID { (userRecordID, error) -> () in
      if let userRecordID = userRecordID
      { NSLog("addLog(): userId:\(userRecordID)");
        
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
        self.usedDB.addOperation(modifyRecordsOperation)
      }
    }
  }

}