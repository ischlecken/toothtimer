
#define _APPCONFIG [AppConfig sharedInstance]


@interface AppConfig : NSObject
@property(          assign, nonatomic) NSInteger                  timerInSeconds;
@property(          assign, nonatomic) NSInteger                  noOfSlices;
@property(          strong, nonatomic) NSString*                  colorSchemeName;
@property(          assign, nonatomic) NSInteger                  usageCount;

+(instancetype) sharedInstance;
@end
