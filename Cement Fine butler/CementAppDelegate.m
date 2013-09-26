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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //set log framework
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    //set baidu map
    self.mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [self.mapManager start:@"D021080d90470be3572b734a2b974a60"  generalDelegate:nil];
    if (!ret) {
        DDLogError(@"baidu map manager start failed!");
    }
    //从用户默认数据中获取用户登录信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    NSString *password = [defaults objectForKey:@"password"];
    
    
    NSDate *curDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSRange daysRange =
    [currentCalendar
     rangeOfUnit:NSDayCalendarUnit
     inUnit:NSMonthCalendarUnit
     forDate:curDate];
    
    // daysRange.length will contain the number of the last day
    // of the month containing curDate
    NSLog(@"%i", daysRange.length);
    NSDate *odate = [self stringToDate:@"yyyy-MM-dd HH:mm:s" dateString:@"2013-9-25 23:59:59"];
    NSLog(@"timeinv is %f",[odate timeIntervalSince1970]);
//    1380124799
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    NSLog(@"year is %d,month is %d, day is %d",year,month,day);
    
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    [comps setDay:6];
    [comps setMonth:9];
    [comps setYear:2013];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSDayCalendarUnit fromDate:date];
    int weekday = [weekdayComponents day];
    NSLog(@"day is %d",weekday);
    return YES;
}

-(NSDate *)stringToDate:(NSString *)formatter dateString:(NSString *)dateString{
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:dateString];
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
