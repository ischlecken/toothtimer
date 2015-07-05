//
//  AppGlobal.swift
//  ToothTimer
//
//  Created by Feldmaus on 04.07.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation

class Constant : NSObject
{
  static let kContactEMail                 = "info@devnull.com"
  static let kAppGroup                     = "group.net.ischlecken.ToothTimer"
  static let kAppID                        = 999999999
  static let kAppName                      = "ToothTimer"
  static let kUsageCountRemainderThreshold = 10
  static let kAppStoreBaseURL0             = "itms-apps://itunes.apple.com/us/app/%1$@/id%2$ld?mt=8"
  static let kAppStoreBaseURL1             = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%1$ld&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"
  static let kAppStoreBaseURL2             = "itms-apps://itunes.apple.com/app/id%1$ld"
  static let kColorSchemeFileName          = "colorscheme"
  
  static var appName : String
  { let localizedInfo = NSBundle.mainBundle().localizedInfoDictionary
  
    return localizedInfo?["CFBundleDisplayName"] as! String;
  }
  
  static var appVersion : String
  { let localizedInfo = NSBundle.mainBundle().localizedInfoDictionary
    
    return localizedInfo?["CFBundleShortVersionString"] as! String;
  }

  static var appBuild : String
  { let localizedInfo = NSBundle.mainBundle().localizedInfoDictionary
    
    return localizedInfo?["CFBundleVersion"] as! String;
  }
  
}





