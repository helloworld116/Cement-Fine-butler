//
//  UITextField+DisableCopyPaste.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-31.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "UITextField+DisableCopyPaste.h"

@implementation UITextField (DisableCopyPaste)
//Disable the Cut/Copy/Paste Menu on UITextField
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	UIMenuController *menuController = [UIMenuController sharedMenuController];
	if (menuController) {
		[UIMenuController sharedMenuController].menuVisible = NO;
	}
	return NO;
}
@end
