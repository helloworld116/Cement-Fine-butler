//
//  LoadingView.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-7.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "LoadingView.h"
@interface LoadingView()
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    frame.origin = CGPointMake(frame.origin.x, frame.origin.y-1);
    frame.size = CGSizeMake(frame.size.width,frame.size.height+1);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((frame.size.width-20)/2, (frame.size.height-20)/2, 20, 20)];
        self.backgroundColor = [UIColor grayColor];
        [self addSubview:self.activityIndicatorView];
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
}

-(void)successEndLoading{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [self.activityIndicatorView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0.3];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
    [UIView commitAnimations];
}

-(void)failureEndLoading{
    [self.activityIndicatorView stopAnimating];
}

@end
