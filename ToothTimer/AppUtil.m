//  Created by Stefan Thomas on 09.04.14
//  Copyright (c) 2014 Stefan Thomas. All rights reserved.
//
#import "AppUtil.h"
#import "UIImage+ImageEffects.h"
#import "ToothTimer-swift.h"
#import "AppConfig.h"

#define _APPDELEGATE              ((AppDelegate*) [UIApplication sharedApplication].delegate)
#define _APPWINDOW                _APPDELEGATE.window


#define kBackgroundImage                  @"background.png"

@interface AppUtil ()
@end

@implementation AppUtil

/**
 *
 */
+(instancetype) sharedInstance
{ static dispatch_once_t once;
  static AppUtil*   sharedInstance;
  
  dispatch_once(&once, ^{ sharedInstance = [self new]; });
  
  return sharedInstance;
}


/**
 *
 */
+(UIImage*) tintedImage:(NSString*)imageName
{ UIImage* image = [UIImage imageNamed:imageName];
  
  image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  
  return image;
}

/**
 *
 */
+(UIImage*) blurredBackgroundImage:(BOOL)extraLight
{ UIImage* image = [AppUtil backgroundImage];
  
  image = extraLight ? [image applyExtraLightEffect] : [image applyLightEffect];
  
  return image;
}

/**
 *
 */
+(UIImage*) backgroundImage
{ UIView* view = _APPWINDOW;
  CGSize  size = view.bounds.size;
  
  UIGraphicsBeginImageContext(size);
  [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
  
  UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}


#pragma mark app info

/**
 *
 */
+(void) aboutDialogue
{ NSString*          aboutTitleTmpl   = _LSTR(@"apputil.AboutTitle");
  NSString*          aboutMessageTmpl = _LSTR(@"apputil.AboutMessage");
  NSString*          aboutTitle       = [NSString stringWithFormat:aboutTitleTmpl,[Constant appName]];
  NSString*          aboutMessage     = [NSString stringWithFormat:aboutMessageTmpl,[Constant appVersion],[Constant appBuild]];
  UIAlertController* alert            = [UIAlertController alertControllerWithTitle:aboutTitle message:aboutMessage preferredStyle:UIAlertControllerStyleAlert];
  
  [alert addAction:[UIAlertAction actionWithTitle:_LSTR(@"apputil.OKButtonTitle") style:UIAlertActionStyleDefault handler:NULL]];
  
  [_APPWINDOW.rootViewController presentViewController:alert animated:YES completion:NULL];
}



/**
 *
 */
+(void) openAppStore
{
#if 1
  NSString* appURL = [NSString stringWithFormat:[Constant kAppStoreBaseURL1],(long)[Constant kAppID]];
#else
  NSString* appURL = [NSString stringWithFormat:[Constant kAppStoreBaseURL2],(long)[Constant kAppID]];
#endif
  
  _NSLOG(@"appURL:%@",appURL);
  
  NSString* encodedAppURL = [[appURL stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
  NSURL*    url           = [NSURL URLWithString:encodedAppURL];

  _NSLOG(@"encodedAppURL:%@",encodedAppURL);

  if( url==nil )
    _NSLOG(@"not a valid url:%@",appURL);
  
  if( url && ![[UIApplication sharedApplication] openURL:url] )
    _NSLOG(@"could not open url %@",url);
}

/**
 *
 */
+(void) backgroundLocationDialogue
{ NSString*          aboutTitleTmpl   = _LSTR(@"apputil.BackgroundLocationTitle");
  NSString*          aboutMessageTmpl = _LSTR(@"apputil.BackgroundLocationMessage");
  NSString*          aboutTitle       = [NSString stringWithFormat:aboutTitleTmpl,[Constant appName]];
  NSString*          aboutMessage     = [NSString stringWithFormat:aboutMessageTmpl,[Constant appName]];
  UIAlertController* alert            = [UIAlertController alertControllerWithTitle:aboutTitle message:aboutMessage preferredStyle:UIAlertControllerStyleAlert];
  
  [alert addAction:[UIAlertAction actionWithTitle:_LSTR(@"apputil.CancelButtonTitle") style:UIAlertActionStyleCancel handler:NULL]];
  [alert addAction:[UIAlertAction actionWithTitle:_LSTR(@"apputil.OpenSettingsTitle") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
  { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]; }]];
  
  [_APPWINDOW.rootViewController presentViewController:alert animated:YES completion:NULL];
}

/**
 *
 */
+(void) locationAccessRestrictedDialogue
{ NSString*          aboutTitleTmpl   = _LSTR(@"apputil.LocationRestrictedTitle");
  NSString*          aboutMessageTmpl = _LSTR(@"apputil.LocationRestrictedMessage");
  NSString*          aboutTitle       = [NSString stringWithFormat:aboutTitleTmpl,[Constant appName]];
  NSString*          aboutMessage     = [NSString stringWithFormat:aboutMessageTmpl,[Constant appName]];
  UIAlertController* alert            = [UIAlertController alertControllerWithTitle:aboutTitle message:aboutMessage preferredStyle:UIAlertControllerStyleAlert];
  
  [alert addAction:[UIAlertAction actionWithTitle:_LSTR(@"apputil.CancelButtonTitle")            style:UIAlertActionStyleCancel handler:NULL]];
  
  [_APPWINDOW.rootViewController presentViewController:alert animated:YES completion:NULL];
}

/**
 *
 */
+(void) locationAccessDeniedDialogue
{ NSString*          aboutTitleTmpl   = _LSTR(@"apputil.LocationDeniedTitle");
  NSString*          aboutMessageTmpl = _LSTR(@"apputil.LocationDeniedMessage");
  NSString*          aboutTitle       = [NSString stringWithFormat:aboutTitleTmpl,[Constant appName]];
  NSString*          aboutMessage     = [NSString stringWithFormat:aboutMessageTmpl,[Constant appName]];
  UIAlertController* alert            = [UIAlertController alertControllerWithTitle:aboutTitle message:aboutMessage preferredStyle:UIAlertControllerStyleAlert];
  
  [alert addAction:[UIAlertAction actionWithTitle:_LSTR(@"apputil.CancelButtonTitle") style:UIAlertActionStyleCancel  handler:NULL]];
  [alert addAction:[UIAlertAction actionWithTitle:_LSTR(@"apputil.OpenSettingsTitle") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
  { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]; }]];

  [_APPWINDOW.rootViewController presentViewController:alert animated:YES completion:NULL];
}


/**
 *
 */
+(void) appStoreRatingReminderDialogue
{ NSString* alertTitle   = _LSTR(@"RatingReminder.Title");
  NSString* alertMessage = _LSTR(@"RatingReminder.Message");
  NSString* appName      = [Constant appName];
  
  UIAlertController* alert    = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:alertTitle,appName]
                                                                    message:[NSString stringWithFormat:alertMessage,appName]
                                                             preferredStyle:UIAlertControllerStyleAlert];
  
  [alert addAction:[UIAlertAction actionWithTitle:_LSTR(@"RatingReminder.RateNow.Title") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
  { _APPCONFIG.usageCount = -1000;
    [AppUtil openAppStore];
  }]];

  [alert addAction:[UIAlertAction actionWithTitle:_LSTR(@"RatingReminder.RemindLater.Title") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
  { _APPCONFIG.usageCount = 0;
  }]];

  [alert addAction:[UIAlertAction actionWithTitle:_LSTR(@"RatingReminder.NoNever.Title") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
  { _APPCONFIG.usageCount = -10000;
  }]];

  [_APPWINDOW.rootViewController presentViewController:alert animated:YES completion:NULL];
}


@end
