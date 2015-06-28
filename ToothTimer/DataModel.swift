
import Foundation
import CoreData

class DataModel
{
  
  /**
   *
   */
  static let managedObjectModel:NSManagedObjectModel =
  { let modelURL = NSBundle.mainBundle().URLForResource("toothtimer", withExtension: "momd")
    
    return NSManagedObjectModel(contentsOfURL: modelURL!)!
  }()
  
  /**
   *
   */
  static var persistentStoreCoordinator: NSPersistentStoreCoordinator =
  { let result = NSPersistentStoreCoordinator(managedObjectModel: DataModel.managedObjectModel)
    
    return result
  }()
  
  
  /**
   *
   */
  func ubiquityContainerURL( completion:(available:Bool,url:NSURL?)->() ) -> NSURL
  { if _ubiquityContainerURL==nil
    { _ubiquityContainerURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)
      
      let iCloudAvailable = (_ubiquityContainerURL != nil)
      
      dispatch_async(dispatch_get_main_queue(),
      { () -> Void in
        
        AppConfig.sharedInstance().iCloudAvailable = iCloudAvailable
        
        completion(available: iCloudAvailable,url: self._ubiquityContainerURL)
      })
    } /* of if */
    
    return _ubiquityContainerURL!
  }
  
  
  /**
   *
   */
  init()
  { print("DataModel inited."); }
  
  /**
   *
   */
  func save()
  { let moc = DAOModel.sharedInstance().managedObjectContext
    
    do
    { try moc.save() }
    catch
    {
      NSLog("Error in MOC.save")
    }
    
    
  }
  
  static  let sharedInstance = DataModel()
  
  private var _ubiquityContainerURL:NSURL?=nil
  
          var managedObjectContext:NSManagedObjectContext?
}