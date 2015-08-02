//
//  BadgeAllocator.swift
//  ToothTimer
//
//  Created by Feldmaus on 02.08.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation

class BadgeAllocator
{
  static let badgeNames : [String] = ["award","medal","police"]
  
  static func allocateBadge() -> Void
  {
    let r = Int(arc4random()) % badgeNames.count
    
    _ = Badge.createBadge(badgeNames[r])
    
    DataModel.sharedInstance.save()
    
  }
}