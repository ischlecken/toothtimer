//
//  ToothTimerSettings.swift
//  ToothTimer
//
//  Created by Feldmaus on 13.09.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation

enum ToothTimerSettingKey : String {
  case colorSchemeName = "colorSchemeName"
  case timerInSeconds = "timerInSeconds"
  case usageCount = "usageCount"
  case notificationEnabled = "notificationEnabled"
  case noOfSlices = "noOfSlices"
}

class ToothTimerSettings : Settings
{
  static let sharedInstance = ToothTimerSettings()
  
  var colorSchemeName: String
    {
    get {
      let result = self.getConfigValue(ToothTimerSettingKey.colorSchemeName.rawValue)
      
      return result! as! String
    }
    set(colorSchemeName) {
      self.setConfigValue(colorSchemeName, forKey: ToothTimerSettingKey.colorSchemeName.rawValue)
    }
  }
  
  var timerInSeconds: Int
    {
    get {
      let result = self.getConfigValue(ToothTimerSettingKey.timerInSeconds.rawValue)
      
      return result! as! Int
    }
    set(timerInSeconds) {
      self.setConfigValue(timerInSeconds, forKey: ToothTimerSettingKey.timerInSeconds.rawValue)
    }
  }
  
  var noOfSlices: Int
    {
    get {
      let result = self.getConfigValue(ToothTimerSettingKey.noOfSlices.rawValue)
      
      return result! as! Int
    }
    set(noOfSlices) {
      self.setConfigValue(timerInSeconds, forKey: ToothTimerSettingKey.noOfSlices.rawValue)
    }
  }

  var usageCount: Int
    {
    get {
      let result = self.getConfigValue(ToothTimerSettingKey.usageCount.rawValue)
      
      return result! as! Int
    }
    set(usageCount) {
      self.setConfigValue(usageCount, forKey: ToothTimerSettingKey.usageCount.rawValue)
    }
  }
  
  var notificationEnabled: Bool
    {
    get {
      let result = self.getConfigValue(ToothTimerSettingKey.notificationEnabled.rawValue)
      
      return result! as! Bool
    }
    set(notificationEnabled) {
      self.setConfigValue(notificationEnabled, forKey: ToothTimerSettingKey.notificationEnabled.rawValue)
    }
  }
  

  let udd =
  [ DefaultSetting(withKeyName: ToothTimerSettingKey.timerInSeconds.rawValue,andDefaultValue: 240),
    DefaultSetting(withKeyName: ToothTimerSettingKey.noOfSlices.rawValue,andDefaultValue: 4),
    DefaultSetting(withKeyName: ToothTimerSettingKey.usageCount.rawValue,andDefaultValue: 0),
    DefaultSetting(withKeyName: ToothTimerSettingKey.notificationEnabled.rawValue,andDefaultValue: false),
    DefaultSetting(withKeyName: ToothTimerSettingKey.colorSchemeName.rawValue,andDefaultValue: "bonbon")
  ]
  
  init() {
    super.init(withDefaults: udd)
  }
}