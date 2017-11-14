//
//  NSURL.swift
//  ToothTimer
//
//  Created by Feldmaus on 05.07.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation

extension URL
{
  static var applicationDocumentsDirectory : URL
  { return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
  }
  
  static var databaseStoreURL : URL
  { return URL.applicationDocumentsDirectory .appendingPathComponent("tooltimer.sqlite")
  }
  
  static var databaseStoreExists : Bool
  { let url = URL.databaseStoreURL;
    
    return FileManager.default.fileExists(atPath: url.path)
  }
  
  static var colorSchemeURL : URL?
  { return URL.appGroupURLForFileName("\(Constant.kColorSchemeFileName).json") }
  
  static func documentFileURL(_ fileName:String) -> URL
  { return URL(fileURLWithPath: fileName, relativeTo: URL.applicationDocumentsDirectory)
  }
  
  static func appGroupURLForFileName(_ fileName:String) -> URL?
  { let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constant.kAppGroup)
    let result   = storeURL?.appendingPathComponent(fileName);
    
    return result
  }
}
