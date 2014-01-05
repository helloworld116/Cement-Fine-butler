//
//  UINavigationItem+ButtonWithoutBorder.h
//  Cement Fine butler
//
//  Created by 文正光 on 14-1-3.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ButtonWithoutBorder)
-(UIBarButtonItem *)initWithImage:(UIImage *) image highlightedImage:(UIImage *) highlightedImage target:(id)target action:(SEL)action;

-(UIBarButtonItem *)initWithText:(NSString *)text target:(id)target action:(SEL)action;
@end
