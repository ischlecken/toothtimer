//
//  Log.swift
//  ToothTimer
//
//  Created by Feldmaus on 27.06.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation
import CoreData

@objc(Log)
class Log: NSManagedObject
{
  class func createLog(durationInSeconds:Int32,noOfSlices:Int16,status:String) -> Log
  { let result = NSEntityDescription .insertNewObjectForEntityForName("Log", inManagedObjectContext: DataModel.sharedInstance.managedObjectContext) as! Log
    
    result.status            = status
    result.logts             = NSDate()
    result.durationinseconds = NSNumber(int:durationInSeconds)
    result.noofslices        = NSNumber(int:Int32(noOfSlices))
    
    return result
  }

  class func fetchRequest() -> NSFetchRequest
  { let entity       = NSEntityDescription .entityForName("Log", inManagedObjectContext: DataModel.sharedInstance.managedObjectContext)
    let fetchRequest = NSFetchRequest()
    
    fetchRequest.entity          = entity
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "logts",ascending: true)]
    fetchRequest.fetchBatchSize  = 20
    
    return fetchRequest;
  }
  
  class func FetchedResultsController() -> NSFetchedResultsController
  { let result = NSFetchedResultsController(fetchRequest: Log.fetchRequest(),
                                            managedObjectContext: DataModel.sharedInstance.managedObjectContext,
                                            sectionNameKeyPath: nil,
                                            cacheName: nil
                                           )
    
    return result;
  }

}
