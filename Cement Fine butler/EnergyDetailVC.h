//
//  EnergyDetailVC.h
//  Cement Fine butler
//
//  Created by 文正光 on 14-3-10.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnergyDetailVC : UITableViewController
@property (nonatomic,strong) NSArray *data;
@end

@interface EnergyDetailCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UILabel *lblName;
@property (nonatomic,strong) IBOutlet UILabel *lblDetail;
@end
