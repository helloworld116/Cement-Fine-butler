//
//  UpdatePasswordViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "UpdatePasswordViewController.h"

@interface UpdatePasswordViewController ()<UITextFieldDelegate>
@property (nonatomic,retain) NSString *currentPassword;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,retain) NSString *password2;
@end

@implementation UpdatePasswordViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改密码";
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.textCurrentPassword.delegate = self;
    self.textNewPassword.delegate = self;
    self.textNewPassword2.delegate = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.lblCurrentUsername.text = [defaults objectForKey:@"username"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)update:(id)sender {
    
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)validate{
//    BOOL validateResult = NO;
    [self.textCurrentPassword resignFirstResponder];
    [self.textNewPassword resignFirstResponder];
    [self.textNewPassword2 resignFirstResponder];
    self.currentPassword = [self.textCurrentPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.password = [self.textNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.password2 = [self.textNewPassword2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *errorMsg;
    if (self.currentPassword == nil || [@"" isEqualToString:self.currentPassword]) {
        errorMsg = @"当前密码不能为空！";
        return NO;
    }
    if (self.password == nil || [@"" isEqualToString:self.password]) {
        errorMsg = @"新密码不能为空！";
        return NO;
    }
    if (![self.password2 isEqualToString:self.password2]) {
        errorMsg = @"两次输入的密码不一致！";
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    self.tableView.contentOffset = CGPointMake(0, 30.f);
    if (theTextField == self.textCurrentPassword) {
        [self.textNewPassword becomeFirstResponder];
    } else if (theTextField == self.textNewPassword) {
        [self.textNewPassword2 becomeFirstResponder];
    }else if (theTextField == self.textNewPassword2){
        [theTextField resignFirstResponder];
        [self update:nil];
    }
    return YES;
}
@end
