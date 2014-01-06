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
#import "RawMaterialsCalculateViewController.h"
#import "EquipmentListViewController.h"
#import "EnergyMonitoringOverViewViewController.h"
#import "RawMaterialCostViewController.h"
#import "LoginAction.h"
#import "LossOverViewVC.h"
#import "EquipmentMapViewController.h"
#import "NavigationController.h"
#import "EnergyNavigationController.h"
#import "LossNavigationController.h"
#import "MoreNavigationController.h"

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
@property (nonatomic,retain) Reachability *hostReach;
@end

@implementation CementAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //网络状况检查
    [self netWorkChecker];
    [self addNetWorkChangeNotification];
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
    //设置自定义时间
    if (![defaults objectForKey:@"startDate"]) {
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *beginComponents = [calendar components: unitFlags fromDate: date];
        int year = [beginComponents year];
        int month = [beginComponents month];
        int day = [beginComponents day];
        NSDictionary *dateDict = @{@"year":[NSNumber numberWithInt:year],@"month":[NSNumber numberWithInt:month],@"day":[NSNumber numberWithInt:day]};
        [defaults setObject:dateDict forKey:@"startDate"];
        [defaults setObject:dateDict forKey:@"endDate"];
        [defaults setObject:[NSNumber numberWithLongLong:[date timeIntervalSince1970]*1000] forKey:@"latestMessage"];
    }
    //设置navigtionbar
//    [[UINavigationBar appearance] setBackgroundImage:[Tool createImageWithColor:[UIColor colorWithRed:52/255.f green:54/255.f blue:68/255.f alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:[Tool createImageWithColor:[Tool hexStringToColor:@"#5c9cec"]] forBarMetrics:UIBarMetricsDefault];
    UIImage *barButton = [[UIImage imageNamed:@"nav-bar-button-dark"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *highlightedBarButton = [[UIImage imageNamed:@"nav-bar-button-dark-highlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    

	[[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:highlightedBarButton forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:
        [UIFont fontWithName:@"Avenir-Heavy" size:0], UITextAttributeFont,
        [UIColor colorWithWhite:0.0f alpha:0.2f], UITextAttributeTextShadowColor,
        [NSValue valueWithUIOffset:UIOffsetMake(0.0f, -1.0f)], UITextAttributeTextShadowOffset,
        [UIColor whiteColor], UITextAttributeTextColor,
        nil]];
    //预警消息
    self.notifactionServices = [[LocalNotifactionServices alloc] init];
    //设置启动界面
    self.storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if([Tool isNullOrNil:username]||[Tool isNullOrNil:password]){
        self.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    }else{
        LoginAction *loginAction = [[LoginAction alloc] init];
        if ([loginAction backstageLoginWithSync:YES]) {
            //自动登录成功
            self.window.rootViewController = [self showViewControllers];
            //预警消息
            [self.notifactionServices performSelector:@selector(getNotifactions) withObject:nil afterDelay:10];
            self.messageTimer = [NSTimer scheduledTimerWithTimeInterval:kGetMessageSeconds target:self.notifactionServices selector:@selector(getNotifactions) userInfo:nil repeats:YES];
        }else{
            //自动登录失败
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误消息" message:@"登录失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            self.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        }
    }
//    //自定义缓存
//    ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
//    self.myCache = cache;
//    //设置缓存路径
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [paths objectAtIndex:0];
//    [self.myCache setStoragePath:[documentDirectory stringByAppendingPathComponent:@"resource"]];
//    [self.myCache setDefaultCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    application.applicationIconBadgeNumber = 0;
    [self.window makeKeyAndVisible];
    return YES;
}

-(NSDate *)stringToDate:(NSString *)formatter dateString:(NSString *)dateString{
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:dateString];
}

-(UIViewController *) showViewControllers{
    //原材料成本损失
    RawMaterialCostViewController *rawMaterialCostLossVC = [[RawMaterialCostViewController alloc] initWithNibName:@"RawMaterialCostViewController" bundle:nil];
    NavigationController *rawMaterialCostLossNC = [[NavigationController alloc] initWithRootViewController:rawMaterialCostLossVC];
    //能源监控
    EnergyMonitoringOverViewViewController *energyMonitoringOverViewVC = [[EnergyMonitoringOverViewViewController alloc] initWithNibName:@"EnergyMonitoringOverViewViewController" bundle:nil];
//    UINavigationController *energyMonitoringOverViewNC = [[UINavigationController alloc] initWithRootViewController:energyMonitoringOverViewVC];
    EnergyNavigationController *energyMonitoringOverViewNC = [[EnergyNavigationController alloc] initWithRootViewController:energyMonitoringOverViewVC];
    //损耗定位
//    LossOverViewViewController *lossOverViewVC = [[LossOverViewViewController alloc] init];
    LossOverViewVC *lossOverViewVC = [[LossOverViewVC alloc] init];
    LossNavigationController *lossOverViewNC = [[LossNavigationController alloc] initWithRootViewController:lossOverViewVC];
    //设备管理
//    UINavigationController *equipmentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"equipmentNavController"];
    EquipmentMapViewController *mapController = [self.storyboard instantiateViewControllerWithIdentifier:@"equipmentMapViewController"];
    UINavigationController *equipmentNC = [[UINavigationController alloc] initWithRootViewController:mapController];
    //更多
//    UINavigationController *moreNC = [self.storyboard instantiateViewControllerWithIdentifier:@"moreNavigationViewController"];
    MoreNavigationController *moreNC = [[MoreNavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"moreViewController"]];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
//    [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabBar"]];
//    tabBarController.tabBar
    
    rawMaterialCostLossNC.tabBarItem = [rawMaterialCostLossNC.tabBarItem initWithTitle:@"成本" image:[UIImage imageNamed:@"cost_icon"] tag:kViewTag+1];
    energyMonitoringOverViewNC.tabBarItem = [energyMonitoringOverViewNC.tabBarItem initWithTitle:@"能源" image:[UIImage imageNamed:@"energy_icon"] tag:kViewTag+2];
    lossOverViewNC.tabBarItem = [lossOverViewNC.tabBarItem initWithTitle:@"损耗" image:[UIImage imageNamed:@"loss_icon"] tag:kViewTag+3];
    equipmentNC.tabBarItem = [equipmentNC.tabBarItem initWithTitle:@"设备" image:[UIImage imageNamed:@"equipment_icon"] tag:kViewTag+4];
    moreNC.tabBarItem = [moreNC.tabBarItem initWithTitle:@"更多" image:[UIImage imageNamed:@"more_icon"] tag:kViewTag+5];
    
    tabBarController.viewControllers = @[rawMaterialCostLossNC,energyMonitoringOverViewNC,lossOverViewNC,equipmentNC,moreNC];
    
    JASidePanelController *sideController = [[JASidePanelController alloc] init];
    [sideController setCenterPanel:tabBarController];
    return sideController;
}
//-(UITabBarController *) showViewControllers{
//    NSArray *lines = [kSharedApp.factory objectForKey:@"lines"];
//    NSMutableArray *lineArray = [NSMutableArray arrayWithObject:@{@"name":@"全部",@"_id":[NSNumber numberWithInt:0]}];
//    for (NSDictionary *line in lines) {
//        NSString *name = [line objectForKey:@"name"];
//        NSNumber *_id = [NSNumber numberWithLong:[[line objectForKey:@"id"] longValue]];
//        NSDictionary *dict = @{@"_id":_id,@"name":name};
//        [lineArray addObject:dict];
//    }
//    NSArray *products = [kSharedApp.factory objectForKey:@"products"];
//    NSMutableArray *productArray = [NSMutableArray arrayWithObject:@{@"name":@"全部",@"_id":[NSNumber numberWithInt:0]}];
//    for (NSDictionary *product in products) {
//        NSString *name = [product objectForKey:@"name"];
//        NSNumber *_id = [NSNumber numberWithLong:[[product objectForKey:@"id"] longValue]];
//        NSDictionary *dict = @{@"_id":_id,@"name":name};
//        [productArray addObject:dict];
//    }
//    NSArray *timeArray = kCondition_Time_Array;
//    //根据权限选择需要展现的视图
//    UITabBarController *tabBarController = [[UITabBarController alloc] init];
//    [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabBar"]];
//    
//    //原材料成本损失
//    JASidePanelController *rawMaterialCostLossSidePanelViewController = [[JASidePanelController alloc] init];
//    RawMaterialCostViewController *rawMaterialCostLossViewController = [[RawMaterialCostViewController alloc] initWithNibName:@"RawMaterialCostViewController" bundle:nil];
//    UINavigationController *rawMaterialCostLossNav = [[UINavigationController alloc] initWithRootViewController:rawMaterialCostLossViewController];
//    RightViewController *rawMaterialCostLossRightController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
//    rawMaterialCostLossRightController.conditions = @[@{@"时间段":timeArray}];
//    rawMaterialCostLossRightController.currentSelectDict = @{kCondition_Time:[NSNumber numberWithInt:2]};
//    [rawMaterialCostLossSidePanelViewController setCenterPanel:rawMaterialCostLossNav];
//    [rawMaterialCostLossSidePanelViewController setRightPanel:rawMaterialCostLossRightController];
//    rawMaterialCostLossSidePanelViewController.tabBarItem = [rawMaterialCostLossSidePanelViewController.tabBarItem initWithTitle:@"原材料" image:[UIImage imageNamed:@"pie-chart"] tag:kViewTag+1];
//    
////    //原材料成本管理模块
////    JASidePanelController *costManagerController = [[JASidePanelController alloc] init];
////    costManagerController.tabBarItem = [costManagerController.tabBarItem initWithTitle:@"成本" image:[UIImage imageNamed:@"uptrend"] tag:kViewTag+1];
////    UINavigationController *rawMaterialsCostManagerNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"rawMaterialsCostManagerNavController"];
////    [costManagerController setCenterPanel:rawMaterialsCostManagerNavController];
////    RightViewController* costManagerRightController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
////    if (kSharedApp.multiGroup) {
////        //集团
////        costManagerRightController.conditions = @[@{@"时间段":kCondition_Time_Array}];
////    }else{
////        //集团下的工厂
////        costManagerRightController.conditions = @[@{@"时间段":timeArray},@{@"产线":lineArray},@{@"产品":productArray}];
////    }
////    costManagerRightController.currentSelectDict = @{kCondition_Time:[NSNumber numberWithInt:2]};
////    [costManagerController setRightPanel:costManagerRightController];
//    
//    //能源监控
//    JASidePanelController *energyMonitoringSidePanelViewController = [[JASidePanelController alloc] init];
//    EnergyMonitoringOverViewViewController *energyMonitoringOverViewViewController = [[EnergyMonitoringOverViewViewController alloc] initWithNibName:@"EnergyMonitoringOverViewViewController" bundle:nil];
//    UINavigationController *energyMonitoringNav = [[UINavigationController alloc] initWithRootViewController:energyMonitoringOverViewViewController];
//    RightViewController* energyMonitoringRightController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
//    energyMonitoringRightController.conditions = @[@{@"时间段":timeArray}];
//    energyMonitoringRightController.currentSelectDict = @{kCondition_Time:[NSNumber numberWithInt:2]};
//    [energyMonitoringSidePanelViewController setCenterPanel:energyMonitoringNav];
//    [energyMonitoringSidePanelViewController setRightPanel:energyMonitoringRightController];
//    energyMonitoringSidePanelViewController.tabBarItem = [energyMonitoringNav.tabBarItem initWithTitle:@"成本" image:[UIImage imageNamed:@"uptrend"] tag:kViewTag+2];
//    
////    //损耗定位
////    JASidePanelController *lossController = [[JASidePanelController alloc] init];
////    lossController.tabBarItem = [lossController.tabBarItem initWithTitle:@"损耗" image:[UIImage imageNamed:@"pie-chart"] tag:kViewTag+2];
////    LossOverViewViewController *lossOverViewController = [[LossOverViewViewController alloc] init];
////    UINavigationController *lossNavController = [[UINavigationController alloc] initWithRootViewController:lossOverViewController];
////    RightViewController* lossRightController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
////    lossRightController.conditions = @[@{@"时间段":timeArray}];
////    lossRightController.currentSelectDict = @{kCondition_Time:[NSNumber numberWithInt:2]};
////    [lossController setCenterPanel:lossNavController];
////    [lossController setRightPanel:lossRightController];
//
//    
//    //实时报表（默认产量报表）
//    JASidePanelController *realTimeReportsController = [[JASidePanelController alloc] init];
//    realTimeReportsController.tabBarItem = [realTimeReportsController.tabBarItem initWithTitle:@"实时报表" image:[UIImage imageNamed:@"bar-chart"] tag:kViewTag+3];
//    ProductColumnViewController *productColumnViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"productColumnViewController"];
//    UINavigationController *realTimeReportsNavController = [[UINavigationController alloc] initWithRootViewController:productColumnViewController];
//    LeftViewController *realTimeReportsLeftController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"];
//    NSArray *reportType = @[@"产量报表",@"库存报表"];
//    realTimeReportsLeftController.conditions = @[@{@"实时报表":reportType}];
//    RightViewController* realTimeReportsRightController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
//    //    NSArray *stockType = @[@{@"_id":[NSNumber numberWithInt:0],@"name":@"原材料库存"},@{@"_id":[NSNumber numberWithInt:1],@"name":@"成品库存"}];
//    if (kSharedApp.multiGroup) {
//        //集团
//        realTimeReportsRightController.conditions = @[@{@"时间段":kCondition_Time_Array}];
//    }else{
//        //集团下的工厂
//        realTimeReportsRightController.conditions = @[@{@"时间段":timeArray},@{@"产线":lineArray},@{@"产品":productArray}];
//    }
//    realTimeReportsRightController.currentSelectDict = @{kCondition_Time:[NSNumber numberWithInt:2]};
//    [realTimeReportsController setLeftFixedWidth:140.f];
//    [realTimeReportsController setCenterPanel:realTimeReportsNavController];
//    [realTimeReportsController setLeftPanel:realTimeReportsLeftController];
//    [realTimeReportsController setRightPanel:realTimeReportsRightController];
//    //设备管理
//    UINavigationController *equipmentController = [self.storyboard instantiateViewControllerWithIdentifier:@"equipmentNavController"];
//    equipmentController.tabBarItem = [equipmentController.tabBarItem initWithTitle:@"设备" image:[UIImage imageNamed:@"list"] tag:kViewTag+4];
//    //消息
////    UINavigationController *messageController = [self.storyboard instantiateViewControllerWithIdentifier:@"messageNavController"];
////    messageController.tabBarItem = [messageController.tabBarItem initWithTitle:@"消息" image:[UIImage imageNamed:@"message"] tag:kViewTag+5];
//    
////    //原材料成本计算器
////    UINavigationController *raw = [self.storyboard instantiateViewControllerWithIdentifier:@"calculatorNavController"];
////    raw.tabBarItem = [raw.tabBarItem initWithTitle:@"计算器" image:[UIImage imageNamed:@"calculator"] tag:kViewTag+5];
//    //更多
//    JASidePanelController *moreSidePanelVC = [[JASidePanelController alloc] init];
//    moreSidePanelVC.tabBarItem = [moreSidePanelVC.tabBarItem initWithTitle:@"更多" image:[UIImage imageNamed:@"calculator"] tag:kViewTag+5];
//    UINavigationController *moreNav = [self.storyboard instantiateViewControllerWithIdentifier:@"moreNavigationViewController"];
//    [moreSidePanelVC setCenterPanel:moreNav];
//    
//    tabBarController.viewControllers = @[rawMaterialCostLossSidePanelViewController,energyMonitoringSidePanelViewController,realTimeReportsController,equipmentController,moreSidePanelVC];
//    return tabBarController;
//}

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

#pragma mark 通知消息
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:notification.alertAction message:notification.alertBody delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    application.applicationIconBadgeNumber -=1;
}


#pragma mark network check
-(void)netWorkChecker
{
    self.hostReach = [Reachability reachabilityWithHostname:@"www.apple.com"];
    switch ([self.hostReach currentReachabilityStatus]) {
        case NotReachable:
            DDLogCInfo(@"没有网络连接");
            // 没有网络连接
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            DDLogCInfo(@"使用3G网络");
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            DDLogCInfo(@"使用WiFi网络");
            break;
    }
}


-(void)addNetWorkChangeNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    self.hostReach = [Reachability reachabilityWithHostname:kCheckNetworkWebsite];
    [self.hostReach startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    DDLogCInfo(@"网络连接状况改变，目前连接状态码为：%d ", status);
    switch (status) {
        case 0:
            
            break;
        case 1:
        case 2:
            
            break;
        default:
            break;
    }
}
@end
