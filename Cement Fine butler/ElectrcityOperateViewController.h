//
//  ElectrcityOperateViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-26.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElectrcityOperateViewController : UITableViewController
@property(nonatomic,strong) IBOutlet UITextField *textElectricityPrice;
@property(nonatomic,retain) NSDictionary *electricityInfo;
@end
