
#define _APPCONFIG [AppConfig sharedInstance]

@protocol AppConfigDelegate <NSObject>
-(void) registerUserNotifications;
@end


@interface AppConfig : NSObject
@property(          assign, nonatomic) NSInteger                  timerInSeconds;
@property(          assign, nonatomic) NSInteger                  noOfSlices;
@property(          strong, nonatomic) NSString*                  colorSchemeName;
@property(readonly, strong, nonatomic) NSArray*                   colorSchemeNames;
@property(          assign, nonatomic) NSInteger                  usageCount;
@property(          strong, nonatomic) NSURL*                     configFilePathURL;
@property(          weak  , nonatomic) id<AppConfigDelegate>      delegate;

-(id)          getConfigValue:(NSString*)key;
-(void)        setConfigValue:(id)value forKey:(NSString*)key;
-(BOOL)        configValueExists:(NSString*)key;

-(id)          colorWithName:(NSString*)colorName;

+(NSURL*)      colorSchemeURL;
+(NSURL*)      applicationDocumentsDirectory;
+(NSURL*)      documentFileURL:(NSString*)fileName;
+(void)        copyToSharedLocationIfNotExists:(NSString*)fileName andType:(NSString*)fileType;
+(void)        copyToSharedLocation:(NSString*)fileName andType:(NSString*)fileType;
+(BOOL)        copyIfModified:(NSURL*)sourceURL destination:(NSURL*)destinationURL;

+(NSURL*)      appGroupURLForFileName:(NSString*)fileName;
+(void)        initConfigFiles;

+(NSString*)   appName;
+(NSString*)   appVersion;
+(NSString*)   appBuild;

+(instancetype) sharedInstance;
@end
