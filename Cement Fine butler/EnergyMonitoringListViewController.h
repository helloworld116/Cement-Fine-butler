//
//  EnergyMonitoringListViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-26.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECViewController.h"

@interface EnergyMonitoringListViewController :UIViewController
@property (nonatomic) int type;//0表示煤，1表示电
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, copy) NSString *timeInfo;
@end
