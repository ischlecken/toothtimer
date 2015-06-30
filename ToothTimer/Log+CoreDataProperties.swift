//
//  Log+CoreDataProperties.swift
//  ToothTimer
//
//  Created by Feldmaus on 27.06.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Log {

    @NSManaged var logts: NSDate
    @NSManaged var durationinseconds: NSNumber
    @NSManaged var noofslices: NSNumber
    @NSManaged var status: String?

}
