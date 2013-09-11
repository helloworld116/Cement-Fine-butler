//
//  CementAppDelegate.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-8-27.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "CementAppDelegate.h"

@interface UINavigationBar (CustomImage)
@end
@implementation UINavigationBar (CustomImage)
- (void) drawRect:(CGRect)rect {
	UIImage *barImage = [UIImage imageNamed:@"navigationBar"];
	[barImage drawInRect:rect];
}
@end

@implementation CementAppDelegate

#define url_queryDistrictByCname [[@"http://www.ucai.com" stringByAppendingFormat:@"/city/cityarea.html?cname=%@",@"深圳"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"url is %@",url_queryDistrictByCname);
    // Override point for customization after application launch.
    //set log framework
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    //set baidu map
    self.mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [self.mapManager start:@"D021080d90470be3572b734a2b974a60"  generalDelegate:nil];
    if (!ret) {
        DDLogError(@"baidu map manager start failed!");
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
