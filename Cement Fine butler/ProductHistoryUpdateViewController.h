//
//  ProductHistoryUpdateViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductHistoryUpdateViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *lblLine;
@property (strong, nonatomic) IBOutlet UILabel *lblProduct;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)dateChange:(id)sender;
@end
