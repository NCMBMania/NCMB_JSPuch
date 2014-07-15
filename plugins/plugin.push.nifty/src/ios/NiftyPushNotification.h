//
//  NiftyPushNotification.h
//  Copyright 2014 NIFTY Corporation All Rights Reserved.
//

#import <Cordova/CDVPlugin.h>

@interface NiftyPushNotification : CDVPlugin

- (void) setDeviceToken: (CDVInvokedUrlCommand*)command;

@end
