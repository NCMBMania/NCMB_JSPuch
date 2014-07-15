//
//  AppDelegate+NiftyCloud.m
//  Copyright 2014 NIFTY Corporation All Rights Reserved.
//
//

#import "AppDelegate+NiftyCloud.h"
#import <NCMB/NCMB.h>
#import "MFViewManager.h"

@implementation AppDelegate (NiftyCloud)

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)registerPushFromPlugin
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge                                                                          | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}

-(void)receivePushFromPlugin:(UIApplication *)application :(NSDictionary *)launchOptions
{
    [self application:application didReceiveRemoteNotification:[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber = 0;
    
    if ([userInfo.allKeys containsObject:@"com.nifty.RichUrl"]){
        if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive){
            [NCMBPush handleRichPush:userInfo];
        }
    }
        
    if ([NSJSONSerialization isValidJSONObject:userInfo]) {
        NSError* error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:&error];
            
        if (!error) {
            [[NSUserDefaults standardUserDefaults] setObject:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] forKey:@"extraJSON"];
            [[NSUserDefaults standardUserDefaults]synchronize];
                
            [self sendPushToCurrentViewController];
        }
    }
}

-(void)sendPushToCurrentViewController
{
    if ([MFViewManager currentViewController]){
        [[MFViewManager currentViewController] sendPush];
    }else{
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(sendPushToCurrentViewController) userInfo:nil repeats:NO];
    }
}

@end
