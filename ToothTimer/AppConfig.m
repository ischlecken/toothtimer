#import "AppConfig.h"
#import "AppDefines.h"
#import "macros.h"
#import "UIColor+Hexadecimal.h"

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
@property(nonatomic,strong) NSMutableDictionary* userDefaults;
@property(nonatomic,strong) NSUserDefaults*      configUserDefaultsStore;
@property(nonatomic,strong) NSDictionary*        colorScheme;
@property(nonatomic,strong) NSMutableDictionary* colorCache;
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
    @[ [UserDefaultDesc userDefaultDescWithKeyName:@"timerInSeconds"  andDefaultValue:[NSNumber numberWithInteger:240]],
       [UserDefaultDesc userDefaultDescWithKeyName:@"noOfSlices"      andDefaultValue:[NSNumber numberWithInteger:4]],
       [UserDefaultDesc userDefaultDescWithKeyName:@"usageCount"      andDefaultValue:[NSNumber numberWithInteger:0]],
       [UserDefaultDesc userDefaultDescWithKeyName:@"colorSchemeName" andDefaultValue:@"default"]
     ];
    
    NSMutableDictionary* udd1 = [[NSMutableDictionary alloc] initWithCapacity:udd.count];
    for( UserDefaultDesc* u in udd )
      [udd1 setObject:u forKey:u.keyName];
    
    self.userDefaultDescription = udd1;
    
    self.userDefaults = [[NSMutableDictionary alloc] initWithCapacity:udd.count];
    
    [self registerUserDefaults];
    [self loadColorScheme];
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
{ self.configUserDefaultsStore = [[NSUserDefaults alloc] initWithSuiteName:kAppGroup]; }


/**
 *
 */
-(id) getConfigValue:(NSString*)key
{ id               result = nil;
  UserDefaultDesc* udd    = self.userDefaultDescription[key];
  
  if( udd )
  {
    result = [[self configUserDefaults] objectForKey:key];
    
    if( result!=nil )
      [self.userDefaults setObject:result forKey:key];
  } /* of if */
  
  //_NSLOG(@"getConfigValue(%@):%@",key,result);
  
  return result;
}

/**
 *
 */
-(BOOL) hasConfigValueChanged:(NSString*)key
{ BOOL             result = NO;
  UserDefaultDesc* udd    = self.userDefaultDescription[key];
  
  if( udd )
  { NSObject* value0 = self.userDefaults[key];
    NSObject* value1 = [[self configUserDefaults] objectForKey:key];
    
    //_NSLOG(@"[%@]:value0:%@ value1:%@",key,value0,value1);
    
    result = (value0==nil && value1!=nil) || (value1!=nil && value0==nil) || ![value0 isEqual:value1];
  } /* of if */
  
  //_NSLOG(@"hasConfigValueChanged(%@):%d",key,result);
  
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
    
    [self.userDefaults setObject:value forKey:key];
    
    [[self configUserDefaults] setObject:value forKey:key];
    [[self configUserDefaults] synchronize];
    
    [self didChangeValueForKey:key];

    if( [key isEqualToString:@"colorSchemeName"] )
    { self.colorCache = nil;
    } /* of else if */
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


#pragma mark Paths

/**
 *
 */
+(NSURL*) applicationDocumentsDirectory
{ return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]; }


/**
 *
 */
+(NSURL*) documentFileURL:(NSString*)fileName
{ return [NSURL URLWithString:fileName relativeToURL:[AppConfig applicationDocumentsDirectory]]; }


/**
 *
 */
+(NSURL*) colorSchemeURL
{ return [AppConfig appGroupURLForFileName:[NSString stringWithFormat:@"%@.json",kColorSchemeFileName]]; }

/**
 *
 */
+(NSURL*) appGroupURLForFileName:(NSString*)fileName
{ NSURL* storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kAppGroup];
  NSURL* result   = [storeURL URLByAppendingPathComponent:fileName];
  
  //_NSLOG(@"result:%@",result);
  
  return result;
}

/**
 *
 */
+(void) copyToSharedLocationIfNotExists:(NSString*)fileName andType:(NSString*)fileType
{ NSString* sharedFilePath = [[AppConfig appGroupURLForFileName:[NSString stringWithFormat:@"%@.%@",fileName,fileType]] path];
  
  if( ![[NSFileManager defaultManager] fileExistsAtPath:sharedFilePath] )
  { NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    NSError*  error    = nil;
    
    if( ![[NSFileManager defaultManager] copyItemAtPath:filePath toPath:sharedFilePath error:&error] )
      _NSLOG(@"could not copy %@ to %@:%@",filePath,sharedFilePath,error);
  } /* of if */
}

/**
 *
 */
+(void) copyToSharedLocation:(NSString*)fileName andType:(NSString*)fileType
{ NSString* sharedFilePath = [[AppConfig appGroupURLForFileName:[NSString stringWithFormat:@"%@.%@",fileName,fileType]] path];
  
  NSError* error = nil;
  
  if( [[NSFileManager defaultManager] fileExistsAtPath:sharedFilePath] )
  { if( ![[NSFileManager defaultManager] removeItemAtPath:sharedFilePath error:&error] )
      _NSLOG(@"could not remove %@:%@",sharedFilePath,error);
  } /* of if */
  
  NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
  if( ![[NSFileManager defaultManager] copyItemAtPath:filePath toPath:sharedFilePath error:&error] )
    _NSLOG(@"could not copy %@ to %@:%@",filePath,sharedFilePath,error);
}

/**
 *
 */
+(BOOL) copyIfModified:(NSURL*)sourceURL destination:(NSURL*)destinationURL
{ BOOL           result      = NO;
  BOOL           copyFile    = NO;
  NSFileManager* fileManager = [NSFileManager defaultManager];
  
  if( sourceURL && destinationURL )
  { if( ![fileManager fileExistsAtPath:[destinationURL path]] )
      copyFile = YES;
    else
    { NSDictionary* sourceFileAttributes = [fileManager attributesOfItemAtPath:[sourceURL path] error:NULL];
      NSDictionary* destFileAttributes   = [fileManager attributesOfItemAtPath:[destinationURL path] error:NULL];
      
      if( sourceFileAttributes && destFileAttributes )
      { NSNumber* sourceFileSize = sourceFileAttributes[NSFileSize];
        NSNumber* destFileSize   = destFileAttributes[NSFileSize];
      
        _NSLOG(@"sourceFileSize:%@ destFileSize:%@",sourceFileSize,destFileSize);
        
        if( ![sourceFileSize isEqualToNumber:destFileSize] )
          copyFile = YES;
      } /* of if */
    } /* of else */
    
    if( copyFile )
    { NSError* error = nil;
      
      if( [fileManager fileExistsAtPath:[destinationURL path]] &&
          ![fileManager removeItemAtPath:[destinationURL path] error:&error]
         )
        _NSLOG(@"remove of %@ failed:%@",destinationURL,error);
      
      if( [fileManager copyItemAtURL:sourceURL toURL:destinationURL error:&error] )
      { _NSLOG(@"copied %@ to %@",sourceURL,destinationURL);
        
        result = YES;
      } /* of if */
      else
        _NSLOG(@"copy of %@ to %@ failed:%@",sourceURL,destinationURL,error);
    } /* of if */
  } /* of if */
  
  return result;
}

#pragma mark Colorscheme

/**
 *
 */
-(void) loadColorScheme
{ NSError*      error    = nil;
  NSString*     dataPath = [[AppConfig colorSchemeURL] path];
  
  if( dataPath )
    self.colorScheme = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                       options:kNilOptions
                                                         error:&error];
  
}


/**
 *
 */
-(NSArray*) colorSchemeNames
{ NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:3];
  
  for( NSString* colorSchemeName in self.colorScheme )
    [result addObject:colorSchemeName];
  
  return result;
}

/**
 *
 */
-(id) colorWithName:(NSString*)colorName
{ id result = nil;
  
  if( self.colorCache==nil )
    self.colorCache = [[NSMutableDictionary alloc] initWithCapacity:10];
  
  result = [self.colorCache objectForKey:colorName];
  
  if( result==nil && self.colorScheme )
  { NSDictionary* currentColorScheme = [self.colorScheme objectForKey:self.colorSchemeName];
    
    if( currentColorScheme )
    { id colorValue = [currentColorScheme objectForKey:colorName];
      
      if( [colorValue isKindOfClass:[NSString class]] )
        result = [UIColor colorWithHexString:colorValue];
      else if( [colorValue isKindOfClass:[NSArray class]] )
      { NSMutableArray* colors = [[NSMutableArray alloc] initWithCapacity:5];
        
        for( NSString* c in colorValue )
          [colors addObject:[UIColor colorWithHexString:c]];
        
        result = colors;
      } /* of else if */
      
      if( result )
        [self.colorCache setObject:result forKey:colorName];
    } /* of if */
  } /* of if */
  
  _NSLOG(@"%@:%@",colorName,result);
  
  return result;
}

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
 
  //_NSLOG(@"resetUserDefaults:%@",appDomain);
  
  //[self configUserDefaults];
  
  self.userDefaults = [[NSMutableDictionary alloc] initWithCapacity:self.userDefaultDescription.count];
}

/**
 *
 */
+(void) initConfigFiles
{ [AppConfig copyToSharedLocation:kColorSchemeFileName andType:@"json"];
}

#pragma mark app info

/**
 *
 */
+(NSString*) appName
{ NSDictionary* localizedInfo    = [[NSBundle mainBundle] localizedInfoDictionary];
  
  return localizedInfo[@"CFBundleDisplayName"];
}

/**
 *
 */
+(NSString*) appVersion
{ NSDictionary* info             = [[NSBundle mainBundle] infoDictionary];
  
  return info[@"CFBundleShortVersionString"];
}

/**
 *
 */
+(NSString*) appBuild
{ NSDictionary* info             = [[NSBundle mainBundle] infoDictionary];
  
  return info[@"CFBundleVersion"];
}
@end
