
#define _APPCONFIG [AppConfig sharedInstance]

@protocol AppConfigDelegate <NSObject>
-(void) registerUserNotifications;
@end


@interface AppConfig : NSObject
@property(          assign, nonatomic) NSInteger                  timerInSeconds;
@property(          assign, nonatomic) NSInteger                  noOfSlices;
@property(          strong, nonatomic) NSString*                  colorSchemeName;
@property(          assign, nonatomic) NSInteger                  usageCount;
@property(          assign, nonatomic) BOOL                       iCloudAvailable;
@property(          strong, nonatomic) NSURL*                     configFilePathURL;
@property(          weak  , nonatomic) id<AppConfigDelegate>      delegate;

-(id)           getConfigValue:(NSString*)key;
-(void)         setConfigValue:(id)value forKey:(NSString*)key;
-(BOOL)         configValueExists:(NSString*)key;

+(void)         initConfigFiles;

+(instancetype) sharedInstance;
@end
