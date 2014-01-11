//
//  VersionService.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-1-11.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "VersionService.h"

@implementation VersionService

+ (id)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)checkVersion{
    // Set the App ID for your app
    [[Harpy sharedInstance] setAppID:@"730834744"];
    
    // (Optional) Set the App Name for your app
    [[Harpy sharedInstance] setAppName:@"动态计量云"];
    
    /* (Optional) Set the Alert Type for your app
     By default, the Singleton is initialized to HarpyAlertTypeOption */
    [[Harpy sharedInstance] setAlertType:HarpyAlertTypeSkip];
    
    /* (Optional) If your application is not availabe in the U.S. App Store, you must specify the two-letter
     country code for the region in which your applicaiton is available. */
    //    [[Harpy sharedInstance] setCountryCode:@"HarpyLanguageChineseSimplified"];
    
    /* (Optional) Overides system language to predefined language.
     Please use the HarpyLanguage constants defined inHarpy.h. */
    [[Harpy sharedInstance] setForceLanguageLocalization:HarpyLanguageChineseSimplified];
    
    // Perform check for new version of your app
    [[Harpy sharedInstance] checkVersion];
}

-(void)checkVersionDaily{
    /*
     Perform daily check for new version of your app
     Useful if user returns to you app from background after extended period of time
     Place in applicationDidBecomeActive:
     
     Also, performs version check on first launch.
     */
    [[Harpy sharedInstance] checkVersionDaily];
}

-(void)checkVersionWeekly{
    /*
     Perform weekly check for new version of your app
     Useful if you user returns to your app from background after extended period of time
     Place in applicationDidBecomeActive:
     
     Also, performs version check on first launch.
     */
    [[Harpy sharedInstance] checkVersionWeekly];
}

@end