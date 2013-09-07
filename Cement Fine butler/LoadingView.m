//
//  LoadingView.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-7.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

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
-(void)startLoading{
    [self.activityIndicatorView startAnimating];
    self.lable.text = @"加载中...";
}

-(void)successEndLoading{
    [self.activityIndicatorView stopAnimating];
    self.lable.text = @"";
}

-(void)failureEndLoading{
    [self.activityIndicatorView stopAnimating];
    self.lable.text = @"";
}

@end
