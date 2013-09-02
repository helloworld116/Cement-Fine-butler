//
//  UpdatePasswordViewController.h
//  CustomerSystem
//
//  Created by wzg on 13-4-23.
//  Copyright (c) 2013年 denglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePasswordViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *oldPasswordTextfield;

@property (strong, nonatomic) IBOutlet UITextField *nPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *nPassword2TextField;
@property (retain, nonatomic) ASIFormDataRequest *request;
- (IBAction)backgroundTouch:(id)sender;
- (IBAction)doUpdatePassword:(id)sender;
@end
