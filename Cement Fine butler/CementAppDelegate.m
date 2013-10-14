//
//  CementAppDelegate.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-8-27.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "CementAppDelegate.h"
#import "ProductColumnViewController.h"
#import "RawMaterialsCostManagerViewController.h"
#import "InventoryColumnViewController.h"
#import "LossOverViewViewController.h"
#import "RawMaterialsCalViewController.h"
#import "LoginAction.h"

#define kViewTag 12000

@interface UINavigationBar (CustomImage)
@end
@implementation UINavigationBar (CustomImage)
- (void) drawRect:(CGRect)rect {
	UIImage *barImage = [UIImage imageNamed:@"navigationBar"];
	[barImage drawInRect:rect];
}
@end

@interface CementAppDelegate()
@property (nonatomic,retain) LoginAction *loginAction;
//@property (nonatomic,retain) UIStoryboard *storyboard;
@end

@implementation CementAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //设置日志记录器
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    //设置初始化百度地图
    self.mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [self.mapManager start:@"D021080d90470be3572b734a2b974a60" generalDelegate:nil];
    if (!ret) {
        DDLogError(@"baidu map manager start failed!");
    }
    //从用户默认数据中获取用户登录信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    NSString *password = [defaults objectForKey:@"password"];
    //设置navigtionbar
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
    UIImage *barButton = [[UIImage imageNamed:@"NavBarButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
	[[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	UIImage *barButtonHighlighted = [[UIImage imageNamed:@"NavBarButtonPressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonHighlighted forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                          [UIFont fontWithName:@"Avenir-Heavy" size:0], UITextAttributeFont,
                                                          [UIColor colorWithWhite:0.0f alpha:0.2f], UITextAttributeTextShadowColor,
                                                          [NSValue valueWithUIOffset:UIOffsetMake(0.0f, -1.0f)], UITextAttributeTextShadowOffset,
                                                          [UIColor whiteColor], UITextAttributeTextColor,
                                                          nil]];
    //设置启动界面
    self.storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if([Tool isNullOrNil:username]||[Tool isNullOrNil:password]){
        self.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    }else{
        LoginAction *loginAction = [[LoginAction alloc] init];
        [loginAction backstageLoginWithSync:YES];
        self.window.rootViewController = [self showViewControllers];
    }
    [self.window makeKeyAndVisible];
    return YES;
}

-(NSDate *)stringToDate:(NSString *)formatter dateString:(NSString *)dateString{
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:dateString];
}

-(UITabBarController *) showViewControllers{
    NSArray *lines = [kSharedApp.factory objectForKey:@"lines"];
    NSMutableArray *lineArray = [NSMutableArray arrayWithObject:@{@"name":@"全部",@"_id":[NSNumber numberWithInt:0]}];
    for (NSDictionary *line in lines) {
        NSString *name = [line objectForKey:@"name"];
        NSNumber *_id = [NSNumber numberWithLong:[[line objectForKey:@"id"] longValue]];
        NSDictionary *dict = @{@"_id":_id,@"name":name};
        [lineArray addObject:dict];
    }
    NSArray *products = [kSharedApp.factory objectForKey:@"products"];
    NSMutableArray *productArray = [NSMutableArray arrayWithObject:@{@"name":@"全部",@"_id":[NSNumber numberWithInt:0]}];
    for (NSDictionary *product in products) {
        NSString *name = [product objectForKey:@"name"];
        NSNumber *_id = [NSNumber numberWithLong:[[product objectForKey:@"id"] longValue]];
        NSDictionary *dict = @{@"_id":_id,@"name":name};
        [productArray addObject:dict];
    }
    NSArray *timeArray = kCondition_Time_Array;
    //根据权限选择需要展现的视图
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabBar"]];
    //原材料成本管理模块
    JASidePanelController *costManagerController = [[JASidePanelController alloc] init];
    costManagerController.tabBarItem = [costManagerController.tabBarItem initWithTitle:@"成本" image:[UIImage imageNamed:@"productOverview"] tag:kViewTag+1];
//    RawMaterialsCostManagerViewController *rawMaterialsCostManagerViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"rawMaterialsCostManagerViewController"];
//    UINavigationController *rawMaterialsCostManagerNavController = [[UINavigationController alloc] initWithRootViewController:rawMaterialsCostManagerViewController];
    UINavigationController *rawMaterialsCostManagerNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"rawMaterialsCostManagerNavController"];
    [costManagerController setCenterPanel:rawMaterialsCostManagerNavController];
    RightViewController* costManagerRightController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
    costManagerRightController.conditions = @[@{@"时间段":timeArray},@{@"产线":lineArray},@{@"产品":productArray}];
    [costManagerController setRightPanel:costManagerRightController];
    //损耗定位
    JASidePanelController *lossController = [[JASidePanelController alloc] init];
    lossController.tabBarItem = [lossController.tabBarItem initWithTitle:@"损耗" image:[UIImage imageNamed:@"equipmentList"] tag:kViewTag+2];
    LossOverViewViewController *lossOverViewController = [[LossOverViewViewController alloc] init];
    UINavigationController *lossNavController = [[UINavigationController alloc] initWithRootViewController:lossOverViewController];
    RightViewController* lossRightController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
    lossRightController.conditions = @[@{@"时间段":timeArray}];
    [lossController setCenterPanel:lossNavController];
    [lossController setRightPanel:lossRightController];
    //实时报表（默认产量报表）
    JASidePanelController *realTimeReportsController = [[JASidePanelController alloc] init];
    realTimeReportsController.tabBarItem = [realTimeReportsController.tabBarItem initWithTitle:@"实时报表" image:[UIImage imageNamed:@"equipmentList"] tag:kViewTag+3];
    ProductColumnViewController *productColumnViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"productColumnViewController"];
    LeftViewController *realTimeReportsLeftController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"];
    NSArray *reportType = @[@"产量报表",@"库存报表"];
    realTimeReportsLeftController.conditions = @[@{@"实时报表":reportType}];
    RightViewController* realTimeReportsRightController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
    //    NSArray *stockType = @[@{@"_id":[NSNumber numberWithInt:0],@"name":@"原材料库存"},@{@"_id":[NSNumber numberWithInt:1],@"name":@"成品库存"}];
    realTimeReportsRightController.conditions = @[@{@"时间段":timeArray},@{@"产线":lineArray},@{@"产品":productArray}];
    [realTimeReportsController setLeftFixedWidth:140.f];
    [realTimeReportsController setCenterPanel:productColumnViewController];
    [realTimeReportsController setLeftPanel:realTimeReportsLeftController];
    [realTimeReportsController setRightPanel:realTimeReportsRightController];
    //设备管理
    UINavigationController *equipmentController = [self.storyboard instantiateViewControllerWithIdentifier:@"equipmentNavController"];
    equipmentController.tabBarItem = [equipmentController.tabBarItem initWithTitle:@"设备" image:[UIImage imageNamed:@"priceAssaint"] tag:kViewTag+4];
    //消息
    UINavigationController *messageController = [self.storyboard instantiateViewControllerWithIdentifier:@"messageNavController"];
    messageController.tabBarItem = [messageController.tabBarItem initWithTitle:@"消息" image:[UIImage imageNamed:@"message"] tag:kViewTag+5];
    //原材料成本计算器
    RawMaterialsCalViewController *raw = [self.storyboard instantiateViewControllerWithIdentifier:@"rawMaterialsCalViewController"];
    
    tabBarController.viewControllers = @[costManagerController,lossController,realTimeReportsController,equipmentController,messageController,raw];
    return tabBarController;
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
