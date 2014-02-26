//
//  LossHeaderView.h
//  Cement Fine butler
//
//  Created by 文正光 on 14-1-11.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LossHeaderView : UIView
@property (strong, nonatomic) IBOutlet UICountingLabel *lblTotalLoss;
@property (strong, nonatomic) IBOutlet UILabel *lblUnit;//单位
@property (strong, nonatomic) IBOutlet UIImageView *imgViewPullDown;
@property (strong, nonatomic) IBOutlet UIButton *btnChangeDate;

@end
