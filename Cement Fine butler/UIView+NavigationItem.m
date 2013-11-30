//
//  UIView+NavigationItem.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-30.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "UIView+NavigationItem.h"

@implementation UIView (NavigationItem)
+(UIView *)titleViewWithTitle:(NSString *)title andTimeInfo:(NSString *)timeInfo{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleView.backgroundColor = [UIColor colorWithRed:52/255.f green:54/255.f blue:68/255.f alpha:1.0];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 30)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textAlignment = UITextAlignmentCenter;
    lblTitle.font = [UIFont boldSystemFontOfSize:17];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.text = title;
    UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 200, 12)];
    lblTime.backgroundColor = [UIColor clearColor];
    lblTime.textColor = [UIColor lightTextColor];
    lblTime.textAlignment = UITextAlignmentCenter;
    lblTime.font = [UIFont systemFontOfSize:10];
    lblTime.text = timeInfo;
    [titleView addSubview:lblTitle];
    [titleView addSubview:lblTime];
    return titleView;
}
@end
