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
  
  func loggedInToICloud(completion : (accountStatus : CKAccountStatus, error : NSError?) -> Void) {
    
    container.accountStatusWithCompletionHandler() { (accountStatus:CKAccountStatus, error:NSError?) -> Void in
      completion(accountStatus: accountStatus, error: error);
    }
    
  }
  
  func userID(completion: (userRecordID: CKRecordID!, error: NSError!)->()) {
    if userRecordID != nil {
      completion(userRecordID: userRecordID, error: nil)
    } else {
      self.container.fetchUserRecordIDWithCompletionHandler() {
        recordID, error in
        if recordID != nil {
          self.userRecordID = recordID
        }
        completion(userRecordID: recordID, error: error)
      }
    }
  }
  
  func userInfo(completion: (userInfo: CKDiscoveredUserInfo!, error: NSError!)->()) {
    requestDiscoverability() { discoverable in
      self.userID() { recordID, error in
        if error != nil {
          completion(userInfo: nil, error: error)
        } else {
          self.userInfo(recordID, completion: completion)
        }
      }
    }
  }
  
  func userInfo(recordID: CKRecordID!,
    completion:(userInfo: CKDiscoveredUserInfo!, error: NSError!)->()) {
      
      container.discoverUserInfoWithUserRecordID(recordID) { (userInfo:CKDiscoveredUserInfo?, error:NSError?) -> Void in
        completion(userInfo: userInfo, error: error)
      }
  }
  
  func requestDiscoverability(completion: (discoverable: Bool) -> ()) {
    container.statusForApplicationPermission(
      .UserDiscoverability) {
        status, error in
        if error != nil || status == CKApplicationPermissionStatus.Denied {
          completion(discoverable: false)
        } else {
          self.container.requestApplicationPermission(.UserDiscoverability) { status, error in
            completion(discoverable: status == .Granted)
          }
        }
    }
  }
  
  func findContacts(completion: (userInfos:[AnyObject]!, error: NSError!)->()) {
    completion(userInfos: [CKRecordID](), error: nil)
  }
}
