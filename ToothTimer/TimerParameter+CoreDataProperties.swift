//
//  TimerParameter+CoreDataProperties.swift
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

extension TimerParameter {

    @NSManaged var noofslices: Int16
    @NSManaged var durationinseconds: Int32
    @NSManaged var name: String?

}
