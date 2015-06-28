//  Created by Stefan Thomas on 09.04.14
//  Copyright (c) 2014 Stefan Thomas. All rights reserved.
//
#define _DAOMODEL [DAOModel sharedInstance]
#define _MOC       _DAOModel.managedObjectContext

@class Log;

@interface DAOModel : NSObject

@property(readonly, strong, nonatomic) NSManagedObjectContext*       managedObjectContext;
@property(readonly, strong, nonatomic) NSManagedObjectModel*         managedObjectModel;
@property(readonly, strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;

+(instancetype) sharedInstance;

-(Log*) logRecord;

-(BOOL) addSQLiteStoreWithURL:(NSURL*)storeURL forConfiguration:(NSString*)configuration toPersistentStoreCoordinator:(NSPersistentStoreCoordinator*)psc;

-(void) resetCoreDataObjects;
@end
