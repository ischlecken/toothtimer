//
//  SwiftSettingsItem.swift
//  ToothTimer
//
//  Created by Feldmaus on 10.08.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation

typealias SwiftSelectActionType = (_ IndexPath:IndexPath,_ item:SwiftSettingsItem) -> Void;

class SwiftSettingsItem : NSObject
{
  var title:String?
  var cellId:String?
  var keyboardType:UIKeyboardType?
  var selectAction:SwiftSelectActionType?
  var pickerValues:[AnyObject]?
  var selectedPickerValue:Int?

  static func settingItemWithTitle(_ title:String, cellId:String) -> SwiftSettingsItem
  { let result = SwiftSettingsItem()
    
    result.title               = title;
    result.cellId              = cellId;
    result.keyboardType        = UIKeyboardType.default;
    result.selectAction        = nil;
    result.pickerValues        = nil;
    result.selectedPickerValue = 0;

    return result
  }

  static func settingItemWithTitle(_ title:String, cellId:String, selectAction:@escaping SwiftSelectActionType) -> SwiftSettingsItem
  { let result = SwiftSettingsItem()
    
    result.title               = title;
    result.cellId              = cellId;
    result.keyboardType        = UIKeyboardType.default;
    result.selectAction        = selectAction;
    result.pickerValues        = nil;
    result.selectedPickerValue = 0;
    
    return result
  }

  static func settingItemWithTitle(_ title:String, cellId:String, selectAction:@escaping SwiftSelectActionType, pickerValues:[AnyObject]) -> SwiftSettingsItem
  { let result = SwiftSettingsItem()
    
    result.title               = title;
    result.cellId              = cellId;
    result.keyboardType        = UIKeyboardType.default;
    result.selectAction        = selectAction;
    result.pickerValues        = pickerValues;
    result.selectedPickerValue = 0;
    
    return result
  }

  static func settingItemWithTitle(_ title:String, cellId:String, pickerValues:[AnyObject], selectedPickerValue:Int) -> SwiftSettingsItem
  { let result = SwiftSettingsItem()
    
    result.title               = title;
    result.cellId              = cellId;
    result.keyboardType        = UIKeyboardType.default;
    result.selectAction        = nil;
    result.pickerValues        = pickerValues;
    result.selectedPickerValue = selectedPickerValue;
    
    return result
  }

  static func settingItemWithTitle(_ title:String, cellId:String, keyboardType:UIKeyboardType) -> SwiftSettingsItem
  { let result = SwiftSettingsItem()
    
    result.title               = title;
    result.cellId              = cellId;
    result.keyboardType        = keyboardType;
    result.selectAction        = nil;
    result.pickerValues        = nil;
    result.selectedPickerValue = 0;
    
    return result
  }


}
