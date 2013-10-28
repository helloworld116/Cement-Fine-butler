//
//  UpdatePasswordViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePasswordViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentUsername;
@property (strong, nonatomic) IBOutlet UITextField *textCurrentPassword;
@property (strong, nonatomic) IBOutlet UITextField *textNewPassword;
@property (strong, nonatomic) IBOutlet UITextField *textNewPassword2;

- (IBAction)update:(id)sender;
@end
