
#define _APPCONFIG [AppConfig sharedInstance]


@interface AppConfig : NSObject
@property(          assign, nonatomic) NSInteger                  timerInSeconds;
@property(          assign, nonatomic) NSInteger                  noOfSlices;
@property(          strong, nonatomic) NSString*                  colorSchemeName;
@property(          assign, nonatomic) NSInteger                  usageCount;

-(id)           getConfigValue:(NSString*)key;
-(void)         setConfigValue:(id)value forKey:(NSString*)key;
-(BOOL)         configValueExists:(NSString*)key;

+(instancetype) sharedInstance;
@end
