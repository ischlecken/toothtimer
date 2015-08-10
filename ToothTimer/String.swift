//
//  String.swift
//  ToothTimer
//
//  Created by Feldmaus on 10.08.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation

func createDateFormatter(locale:String, format:String, timezone: NSTimeZone) -> NSDateFormatter
{ let result = NSDateFormatter()
  
  result.locale = NSLocale(localeIdentifier: locale)
  result.dateFormat = format
  result.timeZone = timezone
  
  return result
}

extension String
{
  static var ISODateForDate:NSDateFormatter = createDateFormatter("en_US_POSIX",format: "yyyy'-'MM'-'dd",timezone: NSTimeZone(forSecondsFromGMT:0))

  static var ISOTimestampForDate:NSDateFormatter = createDateFormatter("en_US_POSIX",format: "yyyy'-'MM'-'dd' 'HH':'mm':'ss",timezone: NSTimeZone(forSecondsFromGMT:0))

  static var LocalTimestamp:NSDateFormatter = createDateFormatter("en_US_POSIX",format: "yyyy'-'MM'-'dd",timezone: NSTimeZone.localTimeZone())

  static var ISOTimestamp:NSDateFormatter = createDateFormatter("en_US_POSIX",format: "yyyy'-'MM'-'dd' 'HH':'mm':'ss",timezone: NSTimeZone(forSecondsFromGMT:0))

  
  static func stringISODate() -> String
  { let result = String()
    
    return result
  }

  static func stringISOTimestamp() -> String
  { let result = String()
    
    return result
  }

  static func stringISODateForDate(date:NSDate) -> String
  { return String.ISODateForDate.stringFromDate(date)
  }

  static func stringISOTimestampForDate(date:NSDate) -> String
  { return String.ISOTimestampForDate.stringFromDate(date)
  }
  
  static func timestampValue(ts:String) -> NSDate?
  { return String.LocalTimestamp.dateFromString(ts)
  }

  static func isoTimestampValue(ts:String) -> NSDate?
  { return String.ISOTimestamp.dateFromString(ts)
  }


}