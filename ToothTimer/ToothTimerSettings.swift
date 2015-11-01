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
}

class ToothTimerSettings : Settings
{
  static let sharedInstance = ToothTimerSettings()
  
  dynamic var colorSchemeName: String? {
    get {
      return self.getConfigValue(ToothTimerSettingKey.colorSchemeName.rawValue) as? String
    }
    set(colorSchemeName) {
      self.setConfigValue(colorSchemeName, forKey: ToothTimerSettingKey.colorSchemeName.rawValue)
    }
  }
  
  dynamic var timerInSeconds: NSNumber? {
    get {
      return self.getConfigValue(ToothTimerSettingKey.timerInSeconds.rawValue)! as? NSNumber
    }
    set(timerInSeconds) {
      self.setConfigValue(timerInSeconds, forKey: ToothTimerSettingKey.timerInSeconds.rawValue)
    }
  }
  
  dynamic var noOfSlices: NSNumber? {
    get {
      return self.getConfigValue(ToothTimerSettingKey.noOfSlices.rawValue)! as? NSNumber
    }
    set(noOfSlices) {
      self.setConfigValue(noOfSlices, forKey: ToothTimerSettingKey.noOfSlices.rawValue)
    }
  }

  dynamic var usageCount: NSNumber? {
    get {
      return self.getConfigValue(ToothTimerSettingKey.usageCount.rawValue)! as? NSNumber
    }
    set(usageCount) {
      self.setConfigValue(usageCount, forKey: ToothTimerSettingKey.usageCount.rawValue)
    }
  }
  
  dynamic var notificationEnabled: Bool {
    get {
      return self.getConfigValue(ToothTimerSettingKey.notificationEnabled.rawValue)! as! Bool
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