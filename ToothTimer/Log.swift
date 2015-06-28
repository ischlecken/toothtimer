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
  { let result = NSEntityDescription .insertNewObjectForEntityForName("Log", inManagedObjectContext: DAOModel.sharedInstance().managedObjectContext) as! Log
    
    result.durationinseconds = durationInSeconds
    result.noofslices        = noOfSlices
    result.status            = status
    result.logts             = NSDate().timeIntervalSince1970
  
    return result
  }

  class func fetchRequest() -> NSFetchRequest
  { let entity       = NSEntityDescription .entityForName("Log", inManagedObjectContext: DAOModel.sharedInstance().managedObjectContext)
    let fetchRequest = NSFetchRequest()
    
    fetchRequest.entity          = entity
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "logts",ascending: true)]
    fetchRequest.fetchBatchSize  = 20
    
    return fetchRequest;
  }
  
  class func FetchedResultsController() -> NSFetchedResultsController
  { let result = NSFetchedResultsController(fetchRequest: Log.fetchRequest(),
                                            managedObjectContext: DAOModel.sharedInstance().managedObjectContext,
                                            sectionNameKeyPath: nil,
                                            cacheName: nil
                                           )
    
    return result;
  }

}
