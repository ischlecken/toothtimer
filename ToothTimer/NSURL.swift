//
//  NSURL.swift
//  ToothTimer
//
//  Created by Feldmaus on 05.07.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation

extension NSURL
{
  static var applicationDocumentsDirectory : NSURL
  { return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last!
  }
  
  static var databaseStoreURL : NSURL
  { return NSURL.applicationDocumentsDirectory .URLByAppendingPathComponent("tooltimer.sqlite")
  }
  
  static var databaseStoreExists : Bool
  { let url = NSURL.databaseStoreURL;
    
    return NSFileManager.defaultManager().fileExistsAtPath(url.path!)
  }
  
  static var colorSchemeURL : NSURL?
  { return NSURL.appGroupURLForFileName("\(Constant.kColorSchemeFileName).json") }
  
  static func documentFileURL(fileName:String) -> NSURL
  { return NSURL(fileURLWithPath: fileName, relativeToURL: NSURL.applicationDocumentsDirectory)
  }
  
  static func appGroupURLForFileName(fileName:String) -> NSURL?
  { let storeURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(Constant.kAppGroup)
    let result   = storeURL?.URLByAppendingPathComponent(fileName);
    
    return result
  }
}
