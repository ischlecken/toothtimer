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
  var configUserDefaultsStore : UserDefaults
  
  init(withDefaults udd:[DefaultSetting])
  { for u in udd {
      self.userDefaultDescription[u.keyName] = u
    }
    
    self.configUserDefaultsStore = UserDefaults(suiteName: Constant.kAppGroup)!
    
    var defaultValues = [String:AnyObject]();
    
    for (keyName,keyValue) in self.userDefaultDescription {
      defaultValues[keyName] = keyValue.defaultValue
    }
    
    self.configUserDefaultsStore.register(defaults: defaultValues)
    self.configUserDefaultsStore.synchronize()
    
  // NSNotificationCenter.defaultCenter().addObserver(self, selector: "defaultsChanged", name: NSUserDefaultsDidChangeNotification, object: nil)
    
  }
  
  func resetUserDefaults()
  { UserDefaults.resetStandardUserDefaults()
    
    let appDomain = Bundle.main.bundleIdentifier
    
    self.configUserDefaultsStore.removePersistentDomain(forName: appDomain!)
  }
  
  func configValueExists(_ key:String) -> Bool
  { return self.userDefaultDescription[key] != nil
  }
  
  func getConfigValue(_ key:String) -> AnyObject?
  { let result = self.configUserDefaultsStore.object(forKey: key)
    
    return result as AnyObject
  }
  
  func setConfigValue(_ value:AnyObject?, forKey key:String)
  {
    let udd = self.userDefaultDescription[key];
    
    if let _ = udd {
      self.willChangeValue(forKey: key)
      
      self.configUserDefaultsStore.set(value, forKey: key)
      self.configUserDefaultsStore.synchronize()
      
      self.didChangeValue(forKey: key)
    }
  }
  
  func defaultsChanged(_ notification:Notification)
  {
    print("defaultsChanged()")
    
  }
}
