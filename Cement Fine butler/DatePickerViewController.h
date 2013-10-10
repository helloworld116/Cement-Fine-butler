//
//  DatePickerViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-9.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lblStartDate;
@property (strong, nonatomic) IBOutlet UILabel *lblEndDate;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerOfStart;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerOfEnd;
- (IBAction)back:(id)sender;
- (IBAction)sureDate:(id)sender;

- (IBAction)backgroundTouch:(id)sender;
- (IBAction)choiceStartDate:(id)sender;
- (IBAction)choiceEndDate:(id)sender;
- (IBAction)updateStartDate:(id)sender;
- (IBAction)updateEndDate:(id)sender;
@end
