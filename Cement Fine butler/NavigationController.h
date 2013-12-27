//
//  NavigationController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-26.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationController : UINavigationController
@property (strong, readonly, nonatomic) REMenu *menu;

- (void)toggleMenu;
@end
