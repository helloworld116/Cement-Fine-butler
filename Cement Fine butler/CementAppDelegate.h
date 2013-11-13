//
//  CementAppDelegate.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-8-27.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalNotifactionServices.h"

@interface CementAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BMKMapManager* mapManager; 
@property (strong, nonatomic) LocalNotifactionServices *notifactionServices;
@property (strong, nonatomic) UIStoryboard *storyboard;
@property (nonatomic,retain) ASIDownloadCache *myCache;

@property (copy, nonatomic) NSString *accessToken;
@property int expiresIn;//过期时间（秒）
@property (retain, nonatomic) NSDictionary *factory;//当前工厂信息
@property (retain, nonatomic) NSArray *factorys;//账户下所有工厂信息
@property (retain, nonatomic) NSDictionary *user;//用户信息
@property (assign, nonatomic) BOOL multiGroup;//是否是多集团用户
@property (assign, nonatomic) int startFactoryId,finalFactoryId;//开始选择的工厂id和最后选择的工厂id

@property (nonatomic,retain) NSTimer *loginTimer,*messageTimer;//定时登录，定时获取消息的定时器

-(UITabBarController *) showViewControllers;
@end
