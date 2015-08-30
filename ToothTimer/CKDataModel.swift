//
//  CKDataModel.swift
//  ToothTimer
//
//  Created by Feldmaus on 30.08.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//
import Foundation
import CloudKit

let LogType = "Log"

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
  
  var logItems = [CKLog]()
  
  init() {
    container = CKContainer.defaultContainer()
    publicDB = container.publicCloudDatabase
    privateDB = container.privateCloudDatabase
  }
  
  func fetchLogs()
  {
    let predicate = NSPredicate(format: "TRUEPREDICATE")
    let queryOperation = CKQueryOperation(query: CKQuery(recordType: LogType, predicate: predicate))
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
      
      let log = CKLog(record: record, database: self.privateDB)
      
      newItems.append(log)
    }
    
    self.delegate?.modelUpdatesWillBegin()
    
    privateDB.addOperation(queryOperation)
  }
  
  
  func addLog(log:CKLog)
  {
    
  }
}