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
        lblMsg.text = @"没有满足条件的数据";
        lblMsg.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblMsg];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
