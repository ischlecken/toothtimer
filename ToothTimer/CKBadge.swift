//
//  Badge+CoreDataProperties.swift
//  ToothTimer
//
//  Created by Feldmaus on 02.08.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CloudKit

class CKBadge {
  
  
  static let recordType = "Badges"
  
  var createts: Date
    {
    get {
      return record.creationDate!
    }
  }
  
  var name: String
    {
    get {
      return record.object(forKey: "name")! as! String
    }
    set(name) {
      record.setObject(name as CKRecordValue, forKey: "name")
    }
  }
  
  var badgeClass: String
    {
    get {
      return record.object(forKey: "class")! as! String
    }
    set(name) {
      record.setObject(name as CKRecordValue, forKey: "class")
    }
  }
  
  var period: Date
    {
    get {
      return record.object(forKey: "period")! as! Date
    }
    set(name) {
      record.setObject(name as CKRecordValue, forKey: "period")
    }
  }
  
  var periodClass: String
    {
    get {
      return record.object(forKey: "periodclass")! as! String
    }
    set(name) {
      record.setObject(name as CKRecordValue, forKey: "periodclass")
    }
  }
  
  var userID: CKRecordID
    {
    get {
      let result = record.creatorUserRecordID
      
      return result! 
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
    self.init( record: CKRecord(recordType: CKBadge.recordType), database: CKBadgesDataModel.sharedInstance.publicDB )
  }

}
