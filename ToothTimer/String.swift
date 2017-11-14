//
//  String.swift
//  ToothTimer
//
//  Created by Feldmaus on 10.08.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation

func createDateFormatter(_ locale:String, format:String, timezone: TimeZone) -> DateFormatter
{ let result = DateFormatter()
  
  result.locale = Locale(identifier: locale)
  result.dateFormat = format
  result.timeZone = timezone
  
  return result
}

extension String
{
  static var ISODateForDate:DateFormatter = createDateFormatter("en_US_POSIX",format: "yyyy'-'MM'-'dd",timezone: TimeZone(secondsFromGMT:0)!)

  static var ISOTimestampForDate:DateFormatter = createDateFormatter("en_US_POSIX",format: "yyyy'-'MM'-'dd' 'HH':'mm':'ss",timezone: TimeZone(secondsFromGMT:0)!)

  static var LocalTimestamp:DateFormatter = createDateFormatter("en_US_POSIX",format: "yyyy'-'MM'-'dd",timezone: TimeZone.autoupdatingCurrent)

  static var ISOTimestamp:DateFormatter = createDateFormatter("en_US_POSIX",format: "yyyy'-'MM'-'dd' 'HH':'mm':'ss",timezone: TimeZone(secondsFromGMT:0)!)

  
  static func stringISODate() -> String
  { let result = String()
    
    return result
  }

  static func stringISOTimestamp() -> String
  { let result = String()
    
    return result
  }

  static func stringISODateForDate(_ date:Date) -> String
  { return String.ISODateForDate.string(from: date)
  }

  static func stringISOTimestampForDate(_ date:Date) -> String
  { return String.ISOTimestampForDate.string(from: date)
  }
  
  static func timestampValue(_ ts:String) -> Date?
  { return String.LocalTimestamp.date(from: ts)
  }

  static func isoTimestampValue(_ ts:String) -> Date?
  { return String.ISOTimestamp.date(from: ts)
  }


}
