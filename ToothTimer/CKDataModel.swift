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
  var delegate : ModelDelegate?
  
  let container : CKContainer
  let publicDB : CKDatabase
  let privateDB : CKDatabase
  var usedDB : CKDatabase
  let userInfo : CKUserInfo
  
  init() {
    container = CKContainer.defaultContainer()
    publicDB = container.publicCloudDatabase
    privateDB = container.privateCloudDatabase
    usedDB = privateDB
    userInfo = CKUserInfo(container: container)
  }
  
  func createQueryOperation(userRecordID:CKRecordID, recordType:String, resultLimit:Int) -> CKQueryOperation
  {
    return createQueryOperationWithPredicate(NSPredicate(format: "TRUEPREDICATE"),forUserId:userRecordID,andRecordType:recordType, andResultLimit:resultLimit)
  }

  func createQueryOperationForCurrentUser(userRecordID:CKRecordID, recordType:String, resultLimit:Int) -> CKQueryOperation
  {
    return createQueryOperationWithPredicate(NSPredicate(format: "creatorUserRecordID == %@", userRecordID),forUserId:userRecordID,andRecordType:recordType, andResultLimit:resultLimit)
  }

  func createQueryOperationWithPredicate(predicate: NSPredicate,
                                         forUserId userRecordID:CKRecordID,
                                         andRecordType recordType:String,
                                         andResultLimit resultLimit:Int) -> CKQueryOperation
  {
    let sort = NSSortDescriptor(key: "creationDate", ascending: false)
    let query = CKQuery(recordType: recordType, predicate: predicate)
    
    query.sortDescriptors = [sort]
    
    let queryOperation = CKQueryOperation(query: query)
    
    queryOperation.resultsLimit = resultLimit
    
    return queryOperation
  }
  
}