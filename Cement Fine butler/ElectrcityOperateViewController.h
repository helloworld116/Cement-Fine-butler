//
//  ElectrcityOperateViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-26.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"

@interface ElectrcityOperateViewController : UITableViewController
@property(nonatomic,strong) IBOutlet UITextField *textElectricityPrice;
@property(nonatomic,strong) IBOutlet UILabel *lblDate;
@property(nonatomic,strong) IBOutlet UIDatePicker *datePicker;
@property(nonatomic,retain) NSDictionary *electricityInfo;
@property(nonatomic,assign) NSObject<PassValueDelegate> *delegate;

- (IBAction)dateChanged:(id)sender;
@end
