#import "AppConfig.h"
#import "macros.h"
#import "ToothTimer-Swift.h"

#pragma mark - UserDefaultDesc

@interface UserDefaultDesc : NSObject

@property NSString* keyName;
@property id        defaultValue;

+(instancetype) userDefaultDescWithKeyName:(NSString*)keyName andDefaultValue:(id)defaultValue;
@end

/**
 *
 */
@implementation UserDefaultDesc

/**
 *
 */
+(instancetype) userDefaultDescWithKeyName:(NSString *)keyName andDefaultValue :(id)defaultValue
{ UserDefaultDesc* result = [UserDefaultDesc new];
  
  result.keyName      = keyName;
  result.defaultValue = defaultValue;
  
  return result;
}

@end

#pragma mark - AppConfig
@interface AppConfig ()

@property(nonatomic,strong) NSDictionary*        userDefaultDescription;
@property(nonatomic,strong) NSUserDefaults*      configUserDefaultsStore;

-(id)           getConfigValue:(NSString*)key;
-(void)         setConfigValue:(id)value forKey:(NSString*)key;
-(BOOL)         configValueExists:(NSString*)key;
@end

@implementation AppConfig



/**
 *
 */
+(instancetype) sharedInstance
{ static dispatch_once_t   once;
  static AppConfig*   sharedInstance;
  
  dispatch_once(&once, ^{sharedInstance        = [self new]; });
  
  return sharedInstance;
}

/**
 *
 */
-(instancetype) init
{ self = [super init];
  
  if( self )
  { NSArray* udd =
    @[ [UserDefaultDesc userDefaultDescWithKeyName:@"timerInSeconds"  andDefaultValue:[NSNumber numberWithInteger:20]],
       [UserDefaultDesc userDefaultDescWithKeyName:@"noOfSlices"      andDefaultValue:[NSNumber numberWithInteger:4]],
       [UserDefaultDesc userDefaultDescWithKeyName:@"usageCount"      andDefaultValue:[NSNumber numberWithInteger:0]],
       [UserDefaultDesc userDefaultDescWithKeyName:@"colorSchemeName" andDefaultValue:@"blue"]
     ];
    
    NSMutableDictionary* udd1 = [[NSMutableDictionary alloc] initWithCapacity:udd.count];
    for( UserDefaultDesc* u in udd )
      [udd1 setObject:u forKey:u.keyName];
    
    self.userDefaultDescription = udd1;
    
    [self registerUserDefaults];
  } /* of if */
  
  return self;
}




#pragma mark Configuration parameter handling

/**
 *
 */
-(NSUserDefaults*) configUserDefaults
{ if( self.configUserDefaultsStore==nil )
    [self reloadConfigUserDefaults];
  
  return self.configUserDefaultsStore;
}

/**
 *
 */
-(void) reloadConfigUserDefaults
{ NSString* appGroup = [Constant kAppGroup];
  
  self.configUserDefaultsStore = [[NSUserDefaults alloc] initWithSuiteName:appGroup]; }


/**
 *
 */
-(id) getConfigValue:(NSString*)key
{ id               result = nil;
  UserDefaultDesc* udd    = self.userDefaultDescription[key];
  
  if( udd )
    result = [[self configUserDefaults] objectForKey:key];
  
  //_NSLOG(@"getConfigValue(%@):%@",key,result);
  
  return result;
}


/**
 *
 */
-(BOOL) configValueExists:(NSString*)key
{ UserDefaultDesc* udd = self.userDefaultDescription[key];
  
  return udd!=nil;
}

/**
 *
 */
-(void) setConfigValue:(id)value forKey:(NSString*)key
{ UserDefaultDesc* udd = self.userDefaultDescription[key];
  
  if( udd )
  { [self willChangeValueForKey:key];
    
    [[self configUserDefaults] setObject:value forKey:key];
    [[self configUserDefaults] synchronize];
    
    [self didChangeValueForKey:key];
  } /* of if */
  
  //_NSLOG(@"setConfigValue(value=%@,key=%@)",value,key);
}


/**
 *
 */
-(NSInteger) timerInSeconds
{ NSNumber* result = [self getConfigValue:@"timerInSeconds"]; return [result integerValue]; }

/**
 *
 */
-(void) setTimerInSeconds:(NSInteger)value
{ [self setConfigValue:[NSNumber numberWithInteger:value] forKey:@"timerInSeconds"]; }

/**
 *
 */
-(NSInteger) noOfSlices
{ NSNumber* result = [self getConfigValue:@"noOfSlices"]; return [result integerValue]; }

/**
 *
 */
-(void) setNoOfSlices:(NSInteger)value
{ [self setConfigValue:[NSNumber numberWithInteger:value] forKey:@"noOfSlices"]; }

/**
 *
 */
-(NSInteger) usageCount
{ NSNumber* result = [self getConfigValue:@"usageCount"]; return [result integerValue]; }

/**
 *
 */
-(void) setUsageCount:(NSInteger)value
{ [self setConfigValue:[NSNumber numberWithInteger:value] forKey:@"usageCount"]; }


/**
 *
 */
-(NSString*) colorSchemeName
{ return [self getConfigValue:@"colorSchemeName"]; }

/**
 *
 */
-(void) setColorSchemeName:(NSString*)value
{ [self setConfigValue:value forKey:@"colorSchemeName"]; }




#pragma mark User Defaults

/**
 *
 */
-(void) defaultsChanged:(NSNotification*)notification
{
}


/**
 *
 */
-(void) registerUserDefaults
{ NSMutableDictionary* defaultValues = [[NSMutableDictionary alloc] initWithCapacity:self.userDefaultDescription.count];
  
  for( NSString* keyName in self.userDefaultDescription )
  { id defaultValue = [self.userDefaultDescription[keyName] defaultValue];
  
    if( defaultValue )
      [defaultValues setObject:defaultValue forKey:keyName];
  } /* of for */
  
  [[self configUserDefaults] registerDefaults:defaultValues];
  [[self configUserDefaults] synchronize];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(defaultsChanged:)
                                               name:NSUserDefaultsDidChangeNotification
                                             object:nil];
  
}




/**
 *
 */
-(void) resetUserDefaults
{ [NSUserDefaults resetStandardUserDefaults];
  
  NSString* appDomain = [[NSBundle mainBundle] bundleIdentifier];
  [[self configUserDefaults] removePersistentDomainForName:appDomain];
}
@end
