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
  
  var durationinseconds: Int64
    {
    get {
      let result = record.objectForKey("durationinseconds")
      
      return (result! as! NSNumber).longLongValue
    }
    set(durationinseconds) {
      record.setObject(NSNumber(longLong: durationinseconds), forKey: "durationinseconds")
    }
  }

  var noofslices: Int64
    {
    get {
      let result = record.objectForKey("noofslices")
      
      return (result! as! NSNumber).longLongValue
    }
    set(noofslices) {
      record.setObject(NSNumber(longLong: noofslices), forKey: "noofslices")
    }
  }

  var status: String
    {
    get {
      let result = record.objectForKey("status")
      
      return result! as! String
    }
    set(status) {
      record.setObject(status, forKey: "status")
    }
  }

  var user: CKReference
    {
    get {
      let result = record.objectForKey("user")
      
      return result! as! CKReference
    }
    set(status) {
      record.setObject(status, forKey: "user")
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
    self.init( record: CKRecord(recordType: CKLog.recordType), database: CKDataModel.sharedInstance.privateDB )
  }
 

}