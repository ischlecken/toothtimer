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
  
  var logts: NSDate
    {
    get {
      let result = record.objectForKey("logts")
      
      return result! as! NSDate
    }
    set(logts) {
      record.setObject(logts, forKey: "logts")
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

  
  var record : CKRecord
  weak var database : CKDatabase?
  
  
  init(record:CKRecord,database:CKDatabase?)
  {
    self.record = record
    self.database = database
  }
 

}