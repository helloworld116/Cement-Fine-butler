//
//  TitleView.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-30.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "TitleView.h"

@interface TitleView()

@end

@implementation TitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init{
   return [self initWithArrow:NO];
}

-(id)initWithArrow:(BOOL)isArrow{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 200, 44);
//        self.backgroundColor = [UIColor colorWithRed:52/255.f green:54/255.f blue:68/255.f alpha:1.0];
        self.backgroundColor = [Tool hexStringToColor:@"#5c9cec"];
        self.lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        self.lblTitle.backgroundColor = [UIColor clearColor];
        self.lblTitle.textAlignment = UITextAlignmentCenter;
        self.lblTitle.font = [UIFont boldSystemFontOfSize:17];
        self.lblTitle.textColor = [UIColor whiteColor];
        self.lblTimeInfo = [[UILabel alloc] initWithFrame:CGRectZero];
        self.lblTimeInfo.backgroundColor = [UIColor clearColor];
        self.lblTimeInfo.textColor = [UIColor lightTextColor];
        self.lblTimeInfo.textAlignment = UITextAlignmentCenter;
        self.lblTimeInfo.font = [UIFont systemFontOfSize:10];
        if (isArrow) {
            self.lblTitle.frame = CGRectMake(0, 2, 200, 30);
            self.lblTimeInfo.frame = CGRectMake(0, 30, 200, 12);
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"small-triangle_icon"]];
            imgView.frame = CGRectMake(150, 17, 10, 10);
            [self addSubview:imgView];
        }else{
            self.lblTitle.frame = CGRectMake(0, 2, 200, 30);
            self.lblTimeInfo.frame = CGRectMake(0, 30, 200, 12);
        }
        
        self.bgBtn = [[UIButton alloc] initWithFrame:self.frame];
        self.bgBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgBtn];
        [self addSubview:self.lblTitle];
        [self addSubview:self.lblTimeInfo];
    }
    return self;
}
@end
