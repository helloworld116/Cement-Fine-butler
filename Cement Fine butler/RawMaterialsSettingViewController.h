//
//  RawMaterialsSettingViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-16.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RawMaterialsSettingViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UITextField *textRate;
@property (strong, nonatomic) IBOutlet UITextField *textFinancePrice;
@property (strong, nonatomic) IBOutlet UITextField *textPlanPrice;
@property (strong, nonatomic) IBOutlet UITextField *textApportionRate;
@property (strong, nonatomic) IBOutlet UISwitch *switchLocked;

@property (nonatomic,retain) NSArray *data;
@property (nonatomic) NSUInteger index;

- (IBAction)textRateTouch:(id)sender;
- (IBAction)changeLocked:(id)sender;
@end
