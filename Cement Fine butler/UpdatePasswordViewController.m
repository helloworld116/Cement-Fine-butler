//
//  UpdatePasswordViewController.m
//  CustomerSystem
//
//  Created by wzg on 13-4-23.
//  Copyright (c) 2013年 denglei. All rights reserved.
//

#import "UpdatePasswordViewController.h"

@interface UpdatePasswordViewController ()
@property (nonatomic,copy) NSString *oldPassword;
@property (nonatomic,copy) NSString *nPassword;
@property (nonatomic,copy) NSString *nPassword2;
@end

@implementation UpdatePasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.title = @"修改密码";
//    self.navigationController.title=@"xxx";
//    [UIColor redColor];
//    [UIImage imageNamed:@""]
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
//    self.navigationController.navigationItem
    self.navigationController.navigationItem.backBarButtonItem = nil;
    self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc
                                               ] initWithBarButtonSystemItem:UIBarButtonItemStyleBordered target:self action:@selector(doUpdatePassword:)];
    //    self.navigationItem.backBarButtonItem = nil;
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc
    //                                               ] initWithBarButtonSystemItem:UIBarButtonItemStyleBordered target:self action:@selector(doUpdatePassword:)];
    self.oldPasswordTextfield.delegate = self;
    self.nPasswordTextField.delegate = self;
    self.nPassword2TextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setOldPasswordTextfield:nil];
    [self setNPasswordTextField:nil];
    [self setNPassword2TextField:nil];
    [super viewDidUnload];
}
- (IBAction)backgroundTouch:(id)sender {
}

- (IBAction)doUpdatePassword:(id)sender {
    //验证输入
    if ([self validate]) {
        self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kLoginURL]];
        [self.request setUseCookiePersistence:YES];
        [self.request setPostValue:self.oldPassword forKey:@"email"];
        [self.request setPostValue:self.nPassword2 forKey:@"password"];
        [self.request setDelegate:self];
        [self.request setDidFailSelector:@selector(requestFailed:)];
        [self.request setDidFinishSelector:@selector(requestLogin:)];
        [self.request startAsynchronous];
        
        [SVProgressHUD showWithStatus:@"...."];
    }
}

-(BOOL)validate{
    //键盘缩回
    [self.oldPasswordTextfield resignFirstResponder];
    [self.nPasswordTextField resignFirstResponder];
    [self.nPassword2TextField resignFirstResponder];
    //赋值
    self.oldPassword = [self.oldPasswordTextfield.text stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceCharacterSet]];
    self.nPassword = [self.nPasswordTextField.text stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]];
    self.nPassword2 = [self.nPassword2TextField.text stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceCharacterSet]];
    if (self.oldPassword == nil || [@"" isEqualToString:self.oldPassword]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"旧密码不能为空";
        hud.margin = 10.f;
        hud.yOffset = 180.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        return NO;
    }
    if (self.nPassword == nil || [@"" isEqualToString:self.nPassword]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"新密码不能为空";
        hud.margin = 10.f;
        hud.yOffset = 180.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        return NO;
    }
    if (self.nPassword2 == nil || [@"" isEqualToString:self.nPassword2]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"确认密码不能为空";
        hud.margin = 10.f;
        hud.yOffset = 180.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        return NO;
    }
    if ([self.nPassword isEqualToString:self.nPassword2]) {
        return YES;
    }else{
        self.nPasswordTextField.text = nil;
        self.nPassword2TextField.text = nil;
        [self.nPasswordTextField becomeFirstResponder];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"新密码与确认密码不一致";
        hud.margin = 10.f;
//        hud.yOffset = 180.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        return NO;
    }
}

#pragma mark UITextfieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ASIHTTPRequestDelegate
-(void) requestFailed:(ASIHTTPRequest *)request{
    [SVProgressHUD showErrorWithStatus:@"网络请求出错"];
}

-(void)requestLogin:(ASIHTTPRequest *)request{
    NSLog(@"the string is %@",request.responseString);
    
    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
    if ([[dict objectForKey:@"status"] intValue]==1) {
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
       
    }else{
      
    }
}
@end
