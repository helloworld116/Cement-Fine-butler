//
//  CementAppDelegate.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-8-27.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CementAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BMKMapManager* mapManager; 

@property (strong, nonatomic) UIStoryboard *storyboard;

@property (copy, nonatomic) NSString *accessToken;
@property int expiresIn;//过期时间（秒）
@property (retain, nonatomic) NSDictionary *factory;//工厂信息
@end
