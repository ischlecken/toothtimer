//
//  CKLog.swift
//  ToothTimer
//
//  Created by Feldmaus on 30.08.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation
import CloudKit

class CKLog
{
  static let recordType = "Logs"
  
  var logts: NSDate
    {
    get {
      return record.creationDate!
    }
  }
  
  var userID: CKRecordID
    {
    get {
      return record.creatorUserRecordID!
    }
  }
  
  var durationinseconds: Int64
    {
    get {
      return (record.objectForKey("durationinseconds")! as! NSNumber).longLongValue
    }
    set(durationinseconds) {
      record.setObject(NSNumber(longLong: durationinseconds), forKey: "durationinseconds")
    }
  }

  var what: String
    {
    get {
      return record.objectForKey("what")! as! String
    }
    set(status) {
      record.setObject(status, forKey: "what")
    }
  }

  
  
  var record : CKRecord
  weak var database : CKDatabase?
  
  
  init(record:CKRecord, database:CKDatabase?)
  { self.record = record
    self.database = database
  }
  
  convenience init()
  {
    self.init( record: CKRecord(recordType: CKLog.recordType), database: CKLogsDataModel.sharedInstance.privateDB )
  }
 

}