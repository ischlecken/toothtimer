//  Created by Stefan Thomas on 09.04.14
//  Copyright (c) 2014 Stefan Thomas. All rights reserved.
//

@interface AppUtil : NSObject
+(instancetype) sharedInstance;

+(UIImage*)     tintedImage:(NSString*)imageName;
+(UIImage*)     blurredBackgroundImage:(BOOL)extraLight;
+(UIImage*)     backgroundImage;
+(void)         aboutDialogue;
+(void)         fullVersionDialogue;
+(void)         openAppStore;
+(void)         appStoreRatingReminderDialogue;

+(void)         backgroundLocationDialogue;
+(void)         locationAccessDeniedDialogue;
+(void)         locationAccessRestrictedDialogue;

@end
