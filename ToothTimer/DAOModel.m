//  Created by Stefan Thomas on 09.04.14
//  Copyright (c) 2014 Stefan Thomas. All rights reserved.
//
#import "DAOModel.h"
#import "AppConfig.h"
#import "Error.h"
#import "ToothTimer-Swift.h"

@interface DAOModel ()
{ NSFetchedResultsController* _favorites;
  NSURL*                      _ubiquityContainerURL;
}
@end

@implementation DAOModel

@synthesize managedObjectContext       = _managedObjectContext;
@synthesize managedObjectModel         = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


/**
 *
 */
+(instancetype) sharedInstance
{ static dispatch_once_t once;
  static DAOModel*        sharedInstance;
  
  dispatch_once(&once, ^{ sharedInstance = [self new]; });
  
  return sharedInstance;
}

/**
 *
 */
-(instancetype) init
{ self = [super init];
 
  if (self)
  { [self initModels];
  } /* of if */
  
  return self;
}

/**
 *
 */
-(void) initModels
{
}

/**
 *
 */
-(Log*) logRecord
{ NSEntityDescription* entityDesc = [NSEntityDescription entityForName:@"Log" inManagedObjectContext:self.managedObjectContext];
  Log*                 result     = (Log*)[[NSManagedObject alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:self.managedObjectContext];
  
  return result;
}

#pragma mark Core Data

/**
 *
 */
-(void) resetCoreDataObjects
{ [_managedObjectContext reset];
  _managedObjectContext       = nil;
  
  _managedObjectModel         = nil;
  
  if( _persistentStoreCoordinator )
  { [[NSNotificationCenter defaultCenter] removeObserver:self name:NSPersistentStoreCoordinatorStoresWillChangeNotification       object:_persistentStoreCoordinator];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSPersistentStoreCoordinatorStoresDidChangeNotification        object:_persistentStoreCoordinator];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:_persistentStoreCoordinator];
  } /* of if */
  
  _persistentStoreCoordinator = nil;
}


/**
 *
 */
-(NSManagedObjectModel*) managedObjectModel
{ if( _managedObjectModel==nil )
  { NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"toothtimer" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSArray* entities = [_managedObjectModel entities];
    
    for( NSEntityDescription* e in entities )
    {
      _NSLOG(@"e:%@",e);
    }
  } /* of if */
    
  return _managedObjectModel;
}

/**
 *
 */
-(NSURL*) ubiquityContainerURL:(void (^)(BOOL available,NSURL* url))completion
{ if( _ubiquityContainerURL==nil )
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    { _ubiquityContainerURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
     
      _NSLOG(@"ubiquityContainerURL:%@",_ubiquityContainerURL);
     
      BOOL iCloudAvailable = _ubiquityContainerURL!=nil ;
     
      dispatch_async(dispatch_get_main_queue(), ^
      { _APPCONFIG.iCloudAvailable = iCloudAvailable;
        
        completion(iCloudAvailable,_ubiquityContainerURL);
      });
    });
  
  return _ubiquityContainerURL;
}

/**
 *
 */
-(NSPersistentStoreCoordinator*) persistentStoreCoordinator
{ if( _persistentStoreCoordinator==nil )
  { _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  
    NSPersistentStoreCoordinator* psc = _persistentStoreCoordinator;
      
    { [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(storesWillChange:)
                                                   name:NSPersistentStoreCoordinatorStoresWillChangeNotification
                                                 object:psc];
      
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(storesDidChange:)
                                                   name:NSPersistentStoreCoordinatorStoresDidChangeNotification
                                                 object:psc];
      
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(persistentStoreDidImportUbiquitousContentChanges:)
                                                   name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                                 object:psc];

      [self ubiquityContainerURL:^(BOOL available, NSURL *url)
       { _NSLOG(@"ubiquityURL:%@ add icloud store",url);
         
         if( available && url!=nil )
           [self addCloudSQLiteStoreWithURL:[AppConfig databaseStoreURL] forUbiquityURL:url toPersistentStoreCoordinator:psc];
         else
           [self addSQLiteStoreWithURL:[AppConfig databaseStoreURL] forConfiguration:nil toPersistentStoreCoordinator:_persistentStoreCoordinator];
      }];
    } /* of if */
  } /* of if */
  
  return _persistentStoreCoordinator;
}


/**
 *
 */
-(BOOL) addSQLiteStoreWithURL:(NSURL*)storeURL forConfiguration:(NSString*)configuration toPersistentStoreCoordinator:(NSPersistentStoreCoordinator*)psc
{ _NSLOG(@"storeURL:%@",storeURL);
  
  BOOL __block result = NO;
  
  [psc performBlockAndWait:^{
    NSError*       error    = nil;
    NSDictionary*  options  = @{ NSMigratePersistentStoresAutomaticallyOption : [NSNumber numberWithBool:YES],
                                 NSInferMappingModelAutomaticallyOption       : [NSNumber numberWithBool:YES]
                                 };
    
    result = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                                configuration:configuration
                                                          URL:storeURL
                                                      options:options
                                                        error:&error]!=nil;
    
    if( !result )
      addToErrorList(@"addSQLiteStoreWithName failed", error);
  }];
  
  return result;
}



/**
 *
 */
-(BOOL) addCloudSQLiteStoreWithURL:(NSURL*)storeURL forUbiquityURL:(NSURL*)ubiquityURL toPersistentStoreCoordinator:(NSPersistentStoreCoordinator*)psc
{ _NSLOG(@"storeURL:%@",storeURL);
  
  BOOL __block result = NO;
  
  [psc performBlockAndWait:^{
    NSError*       error                = nil;
    NSString*      coreDataCloudContent = [[ubiquityURL path] stringByAppendingPathComponent:@"CoreDataLogs"];
    NSDictionary*  options              = @{ NSPersistentStoreUbiquitousContentNameKey    : @"toothtimer",
                                             NSPersistentStoreUbiquitousContentURLKey     : [NSURL fileURLWithPath:coreDataCloudContent],
                                             NSMigratePersistentStoresAutomaticallyOption : [NSNumber numberWithBool:YES]
                                             };
    
    result = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]!=nil;
    
    if( !result )
      addToErrorList(@"addCloudSQLiteStoreWithName failed", error);
  }];
  
  return result;
}


/**
 *
 */
-(NSManagedObjectContext*) managedObjectContext
{ if( _managedObjectContext==nil )
  { NSPersistentStoreCoordinator* coordinator = [self persistentStoreCoordinator];
        
    if( coordinator )
    { NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
      
      [moc performBlockAndWait:
      ^{
         [moc setPersistentStoreCoordinator: coordinator];
         [moc setMergePolicy:[[NSMergePolicy alloc] initWithMergeType:NSMergeByPropertyObjectTrumpMergePolicyType] ];
       }];
      
      _managedObjectContext = moc;
    } /* of if */
  } /* of if */
  
  return _managedObjectContext;
}

/**
 * Subscribe to NSPersistentStoreDidImportUbiquitousContentChangesNotification
 */
-(void) persistentStoreDidImportUbiquitousContentChanges:(NSNotification*)notification
{ _NSLOG(@"%@", notification);
  
  NSManagedObjectContext* moc = [self managedObjectContext];
  
  [moc performBlock:^{ [self mergeiCloudChanges:notification forContext:moc]; }];
}

/**
 * Subscribe to NSPersistentStoreCoordinatorStoresWillChangeNotification
 * most likely to be called if the user enables / disables iCloud
 * (either globally, or just for your app) or if the user changes
 * iCloud accounts.
 */
-(void) storesWillChange:(NSNotification*)notification
{ _NSLOG(@"%@", notification);
  
  NSManagedObjectContext* moc = [self managedObjectContext];
  
  [moc performBlock:^{
    NSError *error;
		
    if( [moc hasChanges] )
    { BOOL success = [moc save:&error];
      
      if( !success && error )
        addToErrorList(@"Saving data reported an error in 'store will change' context",error);
    } /* of if */
  }];
}

/**
 * Subscribe to NSPersistentStoreCoordinatorStoresDidChangeNotification
 */
-(void) storesDidChange:(NSNotification*)notification
{ //_NSLOG(@"%@", notification);
}


/**
 *
 */
-(void) mergeiCloudChanges:(NSNotification*)notification forContext:(NSManagedObjectContext*)moc
{ //_NSLOG(@"mergeiCloudChanges:notification=%@",notification);
  
  [moc mergeChangesFromContextDidSaveNotification:notification];
}

@end
