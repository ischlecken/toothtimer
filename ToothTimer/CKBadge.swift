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
  
  var createts: NSDate
    {
    get {
      return record.creationDate!
    }
  }
  
  var name: String
    {
    get {
      return record.objectForKey("name")! as! String
    }
    set(name) {
      record.setObject(name, forKey: "name")
    }
  }
  
  var badgeClass: String
    {
    get {
      return record.objectForKey("class")! as! String
    }
    set(name) {
      record.setObject(name, forKey: "class")
    }
  }
  
  var period: NSDate
    {
    get {
      return record.objectForKey("period")! as! NSDate
    }
    set(name) {
      record.setObject(name, forKey: "period")
    }
  }
  
  var periodClass: String
    {
    get {
      return record.objectForKey("periodclass")! as! String
    }
    set(name) {
      record.setObject(name, forKey: "periodclass")
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
