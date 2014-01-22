//
//  UINavigationItem+ButtonWithoutBorder.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-1-3.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "UIBarButtonItem+ButtonWithoutBorder.h"

@implementation UIBarButtonItem (ButtonWithoutBorder)
-(UIBarButtonItem *)initWithImage:(UIImage *) image highlightedImage:(UIImage *) highlightedImage target:(id)target action:(SEL)action{
    UIButton *imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgButton setImage:image forState:UIControlStateNormal];
    [imgButton setImage:highlightedImage forState:UIControlStateHighlighted];
    if(IS_IOS7){
        imgButton.frame = CGRectMake(0.0, 0.0, 30, 30);
    }else{
        imgButton.frame = CGRectMake(0.0, 0.0, 40, 30);
    }
    [imgButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:imgButton];
    return barItem;
}

-(UIBarButtonItem *)initWithText:(NSString *)text target:(id)target action:(SEL)action{
    UIButton *textButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    CGSize fontSize = [text sizeWithFont:[UIFont systemFontOfSize:15] forWidth:1000.f lineBreakMode:NSLineBreakByWordWrapping];
    textButton.frame = CGRectMake(0.0, 0.0, 40, 30);
    textButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [textButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [textButton setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [textButton setTitle:text forState:UIControlStateNormal];
    [textButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:textButton];
    return barItem;
}
@end
