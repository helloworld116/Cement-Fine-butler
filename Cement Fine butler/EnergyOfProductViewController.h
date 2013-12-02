//
//  EnergyOfProductViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-2.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnergyOfProductViewController : UIViewController
@property (nonatomic, strong) NSDictionary *product;
@property (nonatomic) int type;//0表示煤，1表示电
@end
