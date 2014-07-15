//
//  AppDelegate+NiftyCloud.h
//  Copyright 2014 NIFTY Corporation All Rights Reserved.
//


#import "AppDelegate.h"

@interface AppDelegate (NiftyCloud)

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)registerPushFromPlugin;
- (void)receivePushFromPlugin:(UIApplication *)application :(NSDictionary *)launchOptions;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

@end