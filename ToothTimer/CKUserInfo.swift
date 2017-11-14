//
//  CKUserInfo.swift
//  ToothTimer
//
//  Created by Feldmaus on 30.08.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation
import CloudKit

class CKUserInfo {
  
  let container : CKContainer
  var userRecordID : CKRecordID!
  var contacts = [AnyObject]()
  
  init (container : CKContainer) {
    self.container = container;
  }
  
  func loggedInToICloud(_ completion : @escaping (_ accountStatus : CKAccountStatus, _ error : Error?) -> Void) {
    
    container.accountStatus { (accountStatus, error) in
      
    }
  }
  
  func userID(_ completion: @escaping (_ userRecordID: CKRecordID?, _ error: Error?)->()) {
    if userRecordID != nil {
      completion(userRecordID, nil)
    } else {
      self.container.fetchUserRecordID() {
        recordID, error in
        if recordID != nil {
          self.userRecordID = recordID
        }
        completion(recordID, error! as Error)
      }
    }
  }
  
  func userInfo(_ completion: @escaping (_ userInfo: CKUserIdentity?, _ error: Error?)->()) {
    requestDiscoverability() { discoverable in
      self.userID() { recordID, error in
        if error != nil {
          completion(nil, error)
        } else {
          self.userInfo(recordID, completion: completion)
        }
      }
    }
  }
  
  func userInfo(_ recordID: CKRecordID!, completion:@escaping (_ userInfo: CKUserIdentity?, _ error: Error?)->()) {
      
    container.discoverUserIdentity(withUserRecordID: recordID, completionHandler: { (userIdentity, error) in
      
    })
  }
  
  func requestDiscoverability(_ completion: @escaping (_ discoverable: Bool) -> ()) {
    container.status(
      forApplicationPermission: .userDiscoverability) {
        status, error in
        if error != nil || status == CKApplicationPermissionStatus.denied {
          completion(false)
        } else {
          self.container.requestApplicationPermission(.userDiscoverability) { status, error in
            completion(status == .granted)
          }
        }
    }
  }
  
  func findContacts(_ completion: (_ userInfos:[AnyObject]?, _ error: Error?)->()) {
    completion([CKRecordID](), nil)
  }
}
