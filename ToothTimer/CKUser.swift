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

class CKUser {
  
  var nickname: String
    {
    get {
      return record.object(forKey: "nickname")! as! String
    }
    set(name) {
      record.setObject(name as CKRecordValue, forKey: "nickname")
    }
  }
  
  var description: String
    {
    get {
      return record.object(forKey: "description")! as! String
    }
    set(name) {
      record.setObject(name as CKRecordValue, forKey: "description")
    }
  }
  
  
  var record : CKRecord
  
  init(record:CKRecord)
  { self.record = record
  }
  

}
