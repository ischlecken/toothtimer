//
//  Badge.swift
//  ToothTimer
//
//  Created by Feldmaus on 02.08.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation
import CoreData

@objc(Badge)
class Badge: NSManagedObject {

  
  class func createBadge(name:String) -> Badge
  { let result = NSEntityDescription .insertNewObjectForEntityForName("Badge", inManagedObjectContext: DataModel.sharedInstance.managedObjectContext) as! Badge
    
    result.name     = name
    result.createts = NSDate()
    
    return result
  }
  
  class func fetchRequest() -> NSFetchRequest
  { let entity       = NSEntityDescription .entityForName("Badge", inManagedObjectContext: DataModel.sharedInstance.managedObjectContext)
    let fetchRequest = NSFetchRequest()
    
    fetchRequest.entity          = entity
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createts",ascending: false)]
    fetchRequest.fetchBatchSize  = 20
    
    return fetchRequest;
  }
  
  class func FetchedResultsController() -> NSFetchedResultsController
  { let result = NSFetchedResultsController(fetchRequest: Badge.fetchRequest(),
                                    managedObjectContext: DataModel.sharedInstance.managedObjectContext,
                                      sectionNameKeyPath: nil,
                                               cacheName: nil
                                           )
    
    return result;
  }

}
