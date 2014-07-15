//
//  NiftyPushNotification.m
//  Copyright 2014 NIFTY Corporation All Rights Reserved.
//

#import "NiftyPushNotification.h"
#import <NCMB/NCMB.h>

@implementation NiftyPushNotification{
    
    CDVInvokedUrlCommand* resultCommand;
    CDVPluginResult* result;
}

- (void) setDeviceToken: (CDVInvokedUrlCommand*)command
{
  NSArray *inArray = command.arguments;
  CDVPluginResult* pluginResult = [[CDVPluginResult alloc]init];
  NSString* errorMessage = @"";

  if (inArray && [inArray count] >= 2)
  {
    NSString* applicationKey = nil;
    NSString* clientKey = nil;

    if ([inArray objectAtIndex:0] && [[inArray objectAtIndex:0] isKindOfClass:[NSString class]]) {
      applicationKey = [inArray objectAtIndex:0];
    }else{
      errorMessage = [errorMessage stringByAppendingString:@"First parameter is invalid.\n"];
    }

    if ([inArray objectAtIndex:1] && [[inArray objectAtIndex:1] isKindOfClass:[NSString class]]) {
      clientKey = [inArray objectAtIndex:1];
    }else{
      errorMessage = [errorMessage stringByAppendingString:@"Second parameter is invalid.\n"];
    }

    if (applicationKey && clientKey)
    {
      [NCMB setApplicationKey:applicationKey clientKey:clientKey];

      if ([NCMB getApplicationKey] && [NCMB getClientKey]){
        NSData* token = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];

        if (token) {
          NCMBInstallation *currentInstallation = [NCMBInstallation currentInstallation];
          [currentInstallation setDeviceTokenFromData:token];

          NSError *error = nil;
          [currentInstallation save:&error];

          if (error != nil) {
            errorMessage = [errorMessage stringByAppendingString:@"installation save error.\n"];
            if (error.code == 409) {
              NCMBQuery *installationQuery = [NCMBInstallation query];
              NSError *fetchError = nil;
              [installationQuery whereKey:@"deviceToken" equalTo:currentInstallation.deviceToken];
              NCMBInstallation *prevInstallation = (NCMBInstallation *)[installationQuery getFirstObject:&fetchError];

              if (fetchError != nil || prevInstallation == nil) {
                errorMessage = [errorMessage stringByAppendingString:@"installation recovery error.\n"];
              } else {
                NSError *recoveryError = nil;
                [[NCMBInstallation currentInstallation] setObjectId:prevInstallation.objectId];
                [[NCMBInstallation currentInstallation] save:&recoveryError];

                if (recoveryError != nil) {
                  errorMessage = [errorMessage stringByAppendingString:@"installation recovery error.\n"];
                }
              }
            }
          }
        }

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success"];


      }else{
        errorMessage = [errorMessage stringByAppendingString:@"Failed to register parameters.\n"];
      }
    }

  }else{
    errorMessage = [errorMessage stringByAppendingString:@"Parameters are invalid."];
  }

  if (![errorMessage isEqualToString:@""]) {
    [self performSelectorOnMainThread:@selector(returnError:) withObject:errorMessage waitUntilDone:0.0];

  }else{

    [self performSelectorOnMainThread:@selector(returnSuccess) withObject:nil waitUntilDone:0.0];
  }

}

-(void)returnSuccess
{
  NSString *js = [NSString stringWithFormat:@"window.NCMB.success(%@)",@"success"];
  [self.commandDelegate evalJs:js];
}


-(void)returnError:(NSString*)errorMessage
{
  NSString *js = [NSString stringWithFormat:@"window.NCMB.fail(%@)",errorMessage];
  [self.commandDelegate evalJs:js];
}

@end
