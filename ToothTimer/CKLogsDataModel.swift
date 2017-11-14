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
      { print("fetchLogs(): userId:\(userRecordID)");
        
        var newItems = [CKLog]()
        let queryOperation = self.createQueryOperationForCurrentUser(userRecordID,recordType:CKLog.recordType, resultLimit: 40)
        
        queryOperation.queryCompletionBlock =
          { (queryCursor:CKQueryCursor?, error:Error?) -> Void in
            
            print("Query completed.")
            
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
        
        self.usedDB.add(queryOperation)
      }
    }
  }
  
  func addLog(_ log:CKLog)
  { print("addLog(\(log))");
    
    userInfo.userID { (userRecordID, error) -> () in
      if let userRecordID = userRecordID
      { print("addLog(): userId:\(userRecordID)");
        
        let modifyRecordsOperation = CKModifyRecordsOperation()
    
        modifyRecordsOperation.recordsToSave = [log.record]
        
        modifyRecordsOperation.modifyRecordsCompletionBlock = {
          (records: [CKRecord]?, deletedRecordIDs: [CKRecordID]?, error: Error?) -> Void in
          
          if let error = error {
            self.delegate?.errorUpdating(error)
          }
          else {
            self.logItems.insert(log, at: 0)
            
            self.delegate?.modelUpdatesDone()
          }
        } as? ([CKRecord]?, [CKRecordID]?, Error?) -> Void;
        
        self.delegate?.modelUpdatesWillBegin()
        self.usedDB.add(modifyRecordsOperation)
      }
    }
  }

}
