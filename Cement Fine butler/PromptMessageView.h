//
//  PromptMessageView.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-11.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromptMessageView : UIView
@property (retain,nonatomic) UILabel *labelMsg;
-(id)initWithFrame:(CGRect)frame message:(NSString *)message;
@end
