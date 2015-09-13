//
//  Settings.swift
//  ToothTimer
//
//  Created by Feldmaus on 13.09.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation

struct DefaultSetting
{
  var keyName : String
  var defaultValue : AnyObject
  
  init(withKeyName keyName:String, andDefaultValue defaultValue:AnyObject)
  {
    self.keyName = keyName
    self.defaultValue = defaultValue
  }
}

class Settings : NSObject
{
  var userDefaultDescription = [String:DefaultSetting]()
  var configUserDefaultsStore : NSUserDefaults
  
  init(withDefaults udd:[DefaultSetting])
  { for u in udd {
      self.userDefaultDescription[u.keyName] = u
    }
    
    self.configUserDefaultsStore = NSUserDefaults(suiteName: Constant.kAppGroup)!
  }
  
  func registerUserDefaults()
  { var defaultValues = [String:AnyObject]();
  
    for (keyName,keyValue) in self.userDefaultDescription {
      defaultValues[keyName] = keyValue.defaultValue
    }
    
    self.configUserDefaultsStore.registerDefaults(defaultValues)
    self.configUserDefaultsStore.synchronize()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "defaultsChanged", name: NSUserDefaultsDidChangeNotification, object: nil)
  
  }
  
  func resetUserDefaults()
  { NSUserDefaults.resetStandardUserDefaults()
    
    let appDomain = NSBundle.mainBundle().bundleIdentifier
    
    self.configUserDefaultsStore.removePersistentDomainForName(appDomain!)
  }
  
  func configValueExists(key:String) -> Bool
  {
    return self.userDefaultDescription[key] != nil
  }
  
  func getConfigValue(key:String) -> AnyObject?
  { var result:AnyObject? = nil
   
    if self.configValueExists(key) {
      result = self.configUserDefaultsStore.objectForKey(key)
    }
    
    return result
  }
  
  func setConfigValue(value:AnyObject, forKey key:String)
  {
    let udd = self.userDefaultDescription[key];
    
    if let _ = udd {
      self.willChangeValueForKey(key)
      
      self.configUserDefaultsStore.setObject(value, forKey: key)
      self.configUserDefaultsStore.synchronize()
      
      self.didChangeValueForKey(key)
    }
  }
  
  func defaultsChanged(notification:NSNotification)
  {
    NSLog("defaultsChanged()")
    
  }
}