//
//  TitleView.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-30.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleView : UIView
@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) UILabel *lblTimeInfo;
@property (strong,nonatomic) UIButton *bgBtn;
@property (strong,nonatomic) UIImage *imgArrow;

-(id)initWithArrow:(BOOL)isArrow;
@end
