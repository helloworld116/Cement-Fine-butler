//
//  EquipmentListCell.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-16.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquipmentListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *lblEquipmentName;
@property (strong, nonatomic) IBOutlet UILabel *lblSN;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblLineName;
@property (strong, nonatomic) IBOutlet UILabel *lblInstantFlowRate;
//@property (strong, nonatomic) IBOutlet UILabel *lblSettingFlowRate;
//@property (strong, nonatomic) IBOutlet UILabel *lblPartOutput;
@property (strong, nonatomic) IBOutlet UIImageView *imgStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalOutput;
@property (strong, nonatomic) IBOutlet UILabel *lblStatusColor;
@end
