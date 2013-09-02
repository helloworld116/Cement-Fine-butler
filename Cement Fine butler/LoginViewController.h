//
//  LoginViewController.h
//  CustomerSystem
//
//  Created by wzg on 13-4-22.
//  Copyright (c) 2013年 denglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImgView;
@property (strong, nonatomic) IBOutlet UIView *continerView;
@property (strong, nonatomic) IBOutlet UIImageView *titleImgView;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet InsetsTextField *username;
@property (strong, nonatomic) IBOutlet InsetsTextField *password;
@property (retain, nonatomic) ASIFormDataRequest *request;
- (IBAction)doLogin:(id)sender;
- (IBAction)backgroundTouch:(id)sender;

@end
