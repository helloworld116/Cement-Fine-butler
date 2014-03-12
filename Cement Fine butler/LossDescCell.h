//
//  LossDescCell.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-19.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LossDescCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblSide;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewPostion;
@property (strong, nonatomic) IBOutlet UILabel *lblLossAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblLossUnit;//单位
@property (strong, nonatomic) IBOutlet UILabel *lblLossType;

@property (strong, nonatomic) IBOutlet UILabel *lblArrow;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewArrow;
@property (strong, nonatomic) IBOutlet UILabel *lblLine;
@end


@interface LossDescCell2 : LossDescCell
@property (strong, nonatomic) IBOutlet UIImageView *imgViewPostion2;
@property (strong, nonatomic) IBOutlet UILabel *lblLossType2;
@end