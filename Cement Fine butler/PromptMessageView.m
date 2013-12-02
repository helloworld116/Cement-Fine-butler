//
//  PromptMessageView.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-11.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "PromptMessageView.h"

@implementation PromptMessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.labelMsg = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-160)/2, (frame.size.height-20)/2, 160, 20)];
        self.labelMsg.backgroundColor = [UIColor clearColor];
        self.labelMsg.text = @"没有满足条件的数据!!!!";
        self.labelMsg.textAlignment = UITextAlignmentCenter;
        self.labelMsg.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.labelMsg];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame message:(NSString *)message{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.labelMsg = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-160)/2, (frame.size.height-20)/2, 160, 20)];
        self.labelMsg.backgroundColor = [UIColor clearColor];
        self.labelMsg.text = message;
        self.labelMsg.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.labelMsg];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    self.labelMsg.frame = CGRectMake((frame.size.width-160)/2, (frame.size.height-20)/2, 160, 20);
}


@end
