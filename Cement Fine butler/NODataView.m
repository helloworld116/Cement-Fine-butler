//
//  NODataView.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-18.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "NODataView.h"

@implementation NODataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *lblMsg = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.height-160)/2, (frame.size.height-20)/2, 160, 20)];
        lblMsg.backgroundColor = [UIColor clearColor];
        lblMsg.text = @"没有满足条件的数据";
        lblMsg.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblMsg];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame message:(NSString *)message{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *lblMsg = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.height-160)/2, (frame.size.height-20)/2, 160, 20)];
        lblMsg.backgroundColor = [UIColor clearColor];
        lblMsg.text = message;
        lblMsg.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblMsg];
    }
    return self;
}

@end
