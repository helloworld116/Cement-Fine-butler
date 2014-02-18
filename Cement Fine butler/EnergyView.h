//
//  EnergyView.h
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-17.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnergyView : UIView
//0表示煤耗，1表示电耗
-(void)setupValue:(NSDictionary *)data withType:(int)type;
@end
