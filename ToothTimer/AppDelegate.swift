//
//  AppDelegate.swift
//  ToothTimer
//
//  Created by Feldmaus on 27.06.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
  { let newUsageCount = ToothTimerSettings.sharedInstance.usageCount!.intValue+1
    
    //ToothTimerSettings.sharedInstance.usageCount = NSNumber(newUsageCount)
    
    if ToothTimerSettings.sharedInstance.usageCount!.intValue > Int(Constant.kUsageCountRemainderThreshold)
    { print("show rating dialogue")
    } /* of if */
    
    UIColor.selectedColorSchemeName = ToothTimerSettings.sharedInstance.colorSchemeName
    
    if let tintColor = UIColor.colorWithName(ColorName.tintColor.rawValue) as? UIColor
    { window?.tintColor = tintColor }
    
    window?.backgroundColor = UIColor.white
    
    let settings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
    
    application.registerUserNotificationSettings(settings)
    application.registerForRemoteNotifications()
    
    CKBadgesDataModel.sharedInstance.addCreationSubscriptionForBadges()
    CKBadgesDataModel.sharedInstance.addDeletionSubscriptionForBadges()
    
    return true
  }
  
  //func application(application: UIApplication, didReceiveRemoteNotification userInfo: [String : NSObject])
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    let notification: CKNotification = CKNotification(fromRemoteNotificationDictionary: userInfo as! [String:NSObject])
    
    if (notification.notificationType == CKNotificationType.query) {
        
      let queryNotification = notification as! CKQueryNotification
        
      let recordID = queryNotification.recordID
        
      print("remoteNotification() recordID:\(String(describing: recordID?.recordName)) reason:\(queryNotification.queryNotificationReason.rawValue)");
      
      CKBadgesDataModel.sharedInstance.fetchBadges()
    }
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

