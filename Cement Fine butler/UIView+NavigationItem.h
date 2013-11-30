//
//  UIView+NavigationItem.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-30.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NavigationItem)
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *timeInfo;
@property (nonatomic,retain) UILabel *lblTime;
+(UIView *)titleViewWithTitle:(NSString *)title andTimeInfo:(NSString *)timeInfo;
@end
