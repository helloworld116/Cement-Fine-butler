//
//  RawMaterialsCalCell.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-14.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RawMaterialsCalCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblRate;
@property (strong, nonatomic) IBOutlet UILabel *lblFinancePrice;
@property (strong, nonatomic) IBOutlet UILabel *lblPlanPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblApportionRate;
@property (strong, nonatomic) IBOutlet UIImageView *imgLockState;
@property (nonatomic,assign) BOOL isLocked;//指示该行是否被锁定
@end
