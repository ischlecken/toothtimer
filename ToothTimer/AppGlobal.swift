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

enum ColorName : String
{ case gradientColors = "gradientColors"
  case optionOnColor  = "optionOnColor"
  case tintColor      = "tintColor"
  case disabledColor  = "disabledColor"
  case iconColors     = "iconColors"
  case titleColor     = "titleColor"
}

extension UIColor
{
  private static var colorScheme : [String:AnyObject]?
  { var result : [String:AnyObject]? = nil
    
    do
    { try NSFileManager.defaultManager().copyToSharedLocation(Constant.kColorSchemeFileName,fileType:"json") }
    catch let error
    { NSLog("Error while move colorscheme to appgroup directory:\(error)") }
    
    if let dataPath = NSURL.colorSchemeURL?.path, data = NSData(contentsOfFile: dataPath)
    { do
      { result = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue: 0)) as? [String : AnyObject] }
      catch let error
      { NSLog("Error while reading json:\(error)") }
    } /* of if */
    
    return result!
  }
  
  private static var colorCache      = [String:AnyObject](minimumCapacity: 1)
  
  static var colorSchemeNames        : [String]?
  { var result : [String]? = nil
    
    if let s = UIColor.colorScheme
    { var r = [String]()
      
      for n in s.keys
      { r.append(n) }
      
      result = r
    } /* of if */
    
    return result
  }

  static var selectedColorSchemeName : String? = nil
  {
    didSet
    { UIColor.colorCache = [String:AnyObject](minimumCapacity: 10)
    }
  }
  
  static func colorWithName(colorName:String) -> AnyObject?
  { var result : AnyObject? = UIColor.colorCache[colorName]
    
    if result==nil
    { if let cs = UIColor.colorScheme, currentColorScheme = cs[UIColor.selectedColorSchemeName!] as? [String:AnyObject]
      { if let colorValue = currentColorScheme[colorName] as? String
        { result = UIColor(hexString: colorValue)
        } /* of if */
        else if let colorValue = currentColorScheme[colorName] as? [String]
        { var colors = [UIColor]()
          
          for c in colorValue
          { colors.append(UIColor(hexString: c)) }
          
          result = colors
        } /* of else if */
      } /* of if */
      
      if result != nil
      { UIColor.colorCache[colorName] = result }
    } /* of if */
    
    return result
  }
}

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

extension NSFileManager
{
  func copyToSharedLocationIfNotExists(fileName:String,fileType:String) throws -> Void
  { if let sfp = NSURL.appGroupURLForFileName("\(fileName).\(fileType)")?.path,
           fp  = NSBundle.mainBundle().pathForResource(fileName, ofType: fileType)
    { if self.fileExistsAtPath(sfp)
      { try self.copyItemAtPath(fp, toPath: sfp) }
    } /* of if */
  }

  func copyToSharedLocation(fileName:String,fileType:String) throws -> Void
  { if let sfp = NSURL.appGroupURLForFileName("\(fileName).\(fileType)")?.path,
           fp  = NSBundle.mainBundle().pathForResource(fileName, ofType: fileType)
    { if self.fileExistsAtPath(sfp)
      { try self.removeItemAtPath(sfp) }
      
      try self.copyItemAtPath(fp, toPath: sfp)
    } /* of if */
  }

  func copyIfModified(sourceURL:NSURL,destination:NSURL) throws -> Bool
  { var result : Bool = false
    
    if let sourcePath      = sourceURL.path,
           destinationPath = destination.path
    { var copyFile = !self.fileExistsAtPath(destinationPath)
      
      if !copyFile
      { let sourceFileSize = try self.attributesOfItemAtPath(sourcePath)[NSFileSize]      as! NSNumber
        let destFileSize   = try self.attributesOfItemAtPath(destinationPath)[NSFileSize] as! NSNumber
        
        if !sourceFileSize.isEqualToNumber(destFileSize)
        { copyFile = true }
      } /* of else */
      
      if copyFile
      { if self.fileExistsAtPath(destinationPath)
        { try self.removeItemAtPath(destinationPath) }
        
        try self.copyItemAtPath(sourcePath, toPath: destinationPath)
        
        result = true
      } /* of if */
    } /* of if */
    
    return result
  }
}

