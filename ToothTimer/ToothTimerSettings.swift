//
//  ToothTimerSettings.swift
//  ToothTimer
//
//  Created by Feldmaus on 13.09.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation

enum ToothTimerSettingKey : String {
  case colorSchemeName                 = "colorSchemeName"
  case usageCount                      = "usageCount"
  
  case timerInSeconds                  = "timerInSeconds"
  case noOfSlices                      = "noOfSlices"
  
  case notificationEnabled             = "notificationEnabled"
  
  case mouthRinseEnabled               = "mouthRinseEnabled"
  case mouthRinseIntervalInDays        = "mouthRinseIntervalInDays"
  case mouthRinsePreferredDayOfWeek    = "mouthRinsePreferredDayOfWeek"
  case mouthRinseTimerInSeconds        = "mouthRinseTimerInSeconds"
  
  case fluoridationEnabled             = "fluoridationEnabled"
  case fluoridationIntervalInDays      = "fluoridationIntervalInDays"
  case fluoridationPreferredDayOfWeek  = "fluoridationPreferredDayOfWeek"
  case fluoridationTimerInSeconds      = "fluoridationTimerInSeconds"
  
  case fullVersion                     = "fullVersion"
}

class ToothTimerSettings : Settings
{
  static let sharedInstance = ToothTimerSettings()
  
  var colorSchemeName: String? {
    get {
      return self.getConfigValue(ToothTimerSettingKey.colorSchemeName.rawValue) as? String
    }
    set(colorSchemeName) {
      self.setConfigValue(colorSchemeName, forKey: ToothTimerSettingKey.colorSchemeName.rawValue)
    }
  }
  
  var timerInSeconds: Int? {
    get {
      return self.getConfigValue(ToothTimerSettingKey.timerInSeconds.rawValue)! as? Int
    }
    set(timerInSeconds) {
      self.setConfigValue(timerInSeconds, forKey: ToothTimerSettingKey.timerInSeconds.rawValue)
    }
  }
  
  var noOfSlices: Int? {
    get {
      return self.getConfigValue(ToothTimerSettingKey.noOfSlices.rawValue)! as? Int
    }
    set(noOfSlices) {
      self.setConfigValue(noOfSlices, forKey: ToothTimerSettingKey.noOfSlices.rawValue)
    }
  }

  var usageCount: Int? {
    get {
      return self.getConfigValue(ToothTimerSettingKey.usageCount.rawValue)! as? Int
    }
    set(usageCount) {
      self.setConfigValue(usageCount, forKey: ToothTimerSettingKey.usageCount.rawValue)
    }
  }
  
  var notificationEnabled: Bool {
    get {
      return self.getConfigValue(ToothTimerSettingKey.notificationEnabled.rawValue)! as! Bool
    }
    set(notificationEnabled) {
      self.setConfigValue(notificationEnabled, forKey: ToothTimerSettingKey.notificationEnabled.rawValue)
    }
  }
  
  var fullVersion: Bool {
    get {
      return self.getConfigValue(ToothTimerSettingKey.fullVersion.rawValue)! as! Bool
    }
    set(fullVersion) {
      self.setConfigValue(fullVersion, forKey: ToothTimerSettingKey.fullVersion.rawValue)
    }
  }
  

  let udd =
  [ DefaultSetting(withKeyName: ToothTimerSettingKey.timerInSeconds.rawValue,andDefaultValue: 240),
    DefaultSetting(withKeyName: ToothTimerSettingKey.noOfSlices.rawValue,andDefaultValue: 4),
    DefaultSetting(withKeyName: ToothTimerSettingKey.usageCount.rawValue,andDefaultValue: 0),
    DefaultSetting(withKeyName: ToothTimerSettingKey.notificationEnabled.rawValue,andDefaultValue: false),
    DefaultSetting(withKeyName: ToothTimerSettingKey.fullVersion.rawValue,andDefaultValue: false),
    DefaultSetting(withKeyName: ToothTimerSettingKey.colorSchemeName.rawValue,andDefaultValue: "bonbon")
  ]
  
  let iapUtil = IAPUtil(withProducts: [IAPProduct(productIdentifier: "bla.fasel"),IAPProduct(productIdentifier: "hugo")])
  
  init() {
    super.init(withDefaults: udd)
    
    iapUtil.requestProducts { (success:Bool, products:[IAPProduct]) -> Void in
      NSLog("requestProducts success:\(success)")
    }
  }
}