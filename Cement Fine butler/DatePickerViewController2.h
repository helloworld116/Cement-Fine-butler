//
//  DatePickerViewController2.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-23.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerViewController2 : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *lblStartDate;
@property (strong, nonatomic) IBOutlet UILabel *lblEndDate;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)dateChanged:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)sureDate:(id)sender;
@end
