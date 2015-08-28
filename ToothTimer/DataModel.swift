
import Foundation
import CoreData

class DataModel : NSObject
{
  static let kDatabaseName  = "toothtimer"
  static let sharedInstance = DataModel()
  
  /**
   *
   */
  lazy var managedObjectContext:NSManagedObjectContext =
  { var result = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
    
    result.performBlockAndWait(
    { result.persistentStoreCoordinator = self.persistentStoreCoordinator
      result.mergePolicy                = NSMergePolicy(mergeType: NSMergePolicyType.MergeByPropertyObjectTrumpMergePolicyType)
    })
    
    return result
  }()

  /**
   *
   */
  lazy var managedObjectModel : NSManagedObjectModel =
  { let modelURL = NSBundle.mainBundle().URLForResource(kDatabaseName, withExtension: "momd")
    
    return NSManagedObjectModel(contentsOfURL: modelURL!)!
  }()
  
  /**
   *
   */
  var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    
  func createPersistentStoreCoordinator() throws
  { let result = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    
    NSNotificationCenter.defaultCenter().addObserver(self,selector: "storesWillChange:",
      name: NSPersistentStoreCoordinatorStoresWillChangeNotification,
      object: result)
 
    NSNotificationCenter.defaultCenter().addObserver(self,selector: "storesDidChange:",
      name: NSPersistentStoreCoordinatorStoresDidChangeNotification,
      object: result)
    
    NSNotificationCenter.defaultCenter().addObserver(self,selector: "persistentStoreDidImportUbiquitousContentChanges:",
      name: NSPersistentStoreDidImportUbiquitousContentChangesNotification,
      object: result)
    
    if let ubiURL=self.ubiquityContainerURL
    { try self.addCloudSQLiteStoreWithURL(NSURL.databaseStoreURL,ubiquityURL: ubiURL,persistentStoreCoordinator: result)
    }
    else
    { try self.addSQLiteStoreWithURL(NSURL.databaseStoreURL,persistentStoreCoordinator: result)
    }
    
    self.persistentStoreCoordinator = result
  }
  
  
  /**
   *
   */
  lazy var ubiquityContainerURL: NSURL? =
  { let result = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)
      
    return result
  }()
  
  
  /**
   *
   */
  private override init()
  { super.init()
    
    print("DataModel inited.")
  
    do
    { try self.createPersistentStoreCoordinator() }
    catch
    { NSLog("error while creating persistentstorecoordinator:\(error)")
      
    }
  }
  
  /**
   *
   */
  func resetCoreDataObjects()
  { self.managedObjectContext.reset()
    
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  /**
   *
   */
  func addSQLiteStoreWithURL(storeURL:NSURL,persistentStoreCoordinator:NSPersistentStoreCoordinator) throws
  { NSLog("storeURL:%@",storeURL)
  
    var resultError:ErrorType? = nil
    
    persistentStoreCoordinator .performBlockAndWait
    { let options = [ NSMigratePersistentStoresAutomaticallyOption:true,NSInferMappingModelAutomaticallyOption:true ]
      
      do
      { try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options) }
      catch let error
      { resultError = error }
    }
  
    if (resultError != nil)
    { throw resultError! }
  }
  
  /**
   *
   */
  func addCloudSQLiteStoreWithURL(storeURL:NSURL,ubiquityURL:NSURL,persistentStoreCoordinator:NSPersistentStoreCoordinator) throws
  { NSLog("storeURL:%@",storeURL)
    
    var resultError:ErrorType? = nil
    
    persistentStoreCoordinator .performBlockAndWait
    { let coreDataCloudContent = ubiquityURL.URLByAppendingPathComponent("CoreDataLogs");
      let options              = [ NSPersistentStoreUbiquitousContentNameKey:DataModel.kDatabaseName,
                                   NSPersistentStoreUbiquitousContentURLKey:NSURL.fileURLWithPath(coreDataCloudContent.path!),
                                   NSMigratePersistentStoresAutomaticallyOption:true
                                 ]
    
      do
      { try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options) }
      catch let error
      { resultError = error }
    }
    
    if (resultError != nil)
    { throw resultError! }
  }
  
  
  /**
   *
   */
  func persistentStoreDidImportUbiquitousContentChanges(notification:NSNotification)
  { NSLog("persistentStoreDidImportUbiquitousContentChanges")
   
    self.managedObjectContext.performBlock
    { self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
    }
  }

  /**
   *
   */
  func storesWillChange(notification:NSNotification)
  { NSLog("storesWillChange")
    
    self.managedObjectContext.performBlock
    { if self.managedObjectContext.hasChanges
      {
        do
        { try self.managedObjectContext.save() }
        catch
        { }
      }
    }
  }

  /**
   *
   */
  func storesDidChange(notification:NSNotification)
  { NSLog("storesDidChange")
    
  }

  
  /**
   *
   */
  func save()
  { let moc = self.managedObjectContext
    
    do
    { try moc.save() }
    catch let error
    { NSLog("Error in save:\(error)")
    }
  }
  
}
/*==============END-OF-FILE==============================*/
