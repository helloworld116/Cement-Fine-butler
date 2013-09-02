//
//  InsetsTextField.m
//  CustomerSystem
//
//  Created by wzg on 13-6-7.
//  Copyright (c) 2013年 denglei. All rights reserved.
//

#import "InsetsTextField.h"

@implementation InsetsTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
//控制 placeHolder 的位置，左右缩 20
- (CGRect)textRectForBounds:(CGRect)bounds {
    if (IS_Pad) {
        CGRect frame = bounds;
        frame.origin.y = 0;
        frame.origin.x = 80;
        bounds = frame;
        return CGRectInset(bounds, 0, 0);
    }
    return CGRectInset( bounds , 35 , 0 );
}

// 控制文本的位置，左右缩 20
- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (IS_Pad) {
        CGRect frame = bounds;
        frame.origin.y = 0;
        frame.origin.x = 80;
        bounds = frame;
        return CGRectInset(bounds, 0, 0);
    }
    return CGRectInset( bounds , 35 , 0 );
}
@end
