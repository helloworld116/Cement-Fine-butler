//
//  UpdatePasswordViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "UpdatePasswordViewController.h"

@interface UpdatePasswordViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentUsername;
@property (strong, nonatomic) IBOutlet UITextField *textCurrentPassword;
@property (strong, nonatomic) IBOutlet UITextField *textNewPassword;
@property (strong, nonatomic) IBOutlet UITextField *textNewPassword2;

- (IBAction)update:(id)sender;

@property (nonatomic,retain) NSString *currentPassword;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,retain) NSString *password2;

@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
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
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_2.png"]];
    
    self.navigationItem.title = @"修改密码";
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 30)];
    [backBtn setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return_click_icon"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

    self.textCurrentPassword.delegate = self;
    self.textNewPassword.delegate = self;
    self.textNewPassword2.delegate = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.lblCurrentUsername.text = [defaults objectForKey:@"username"];
    
//    self.textCurrentPassword.text = @"123456";
//    self.textNewPassword.text = @"123456";
//    self.textNewPassword2.text = @"123456";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)update:(id)sender {
    if ([self validate]) {
        [self sendRequest:kUpdatePasswordURL];
    }
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)validate{
    BOOL validateResult = YES;
    [self.textCurrentPassword resignFirstResponder];
    [self.textNewPassword resignFirstResponder];
    [self.textNewPassword2 resignFirstResponder];
    self.currentPassword = [self.textCurrentPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.password = [self.textNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.password2 = [self.textNewPassword2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *errorMsg;
    if (self.currentPassword == nil || [@"" isEqualToString:self.currentPassword]) {
        errorMsg = @"当前密码不能为空！";
        validateResult = NO;
    }else{
        if (self.password == nil || [@"" isEqualToString:self.password]) {
            errorMsg = @"新密码不能为空！";
            validateResult = NO;
        }else{
            if (![self.password2 isEqualToString:self.password2]) {
                errorMsg = @"两次输入的密码不一致！";
                validateResult = NO;
            }
        }
    }
    [self showErrorMessage:errorMsg];
    return validateResult;
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

#pragma mark 发送网络请求
-(void) sendRequest:(NSString *)url{
    //加载过程提示
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.tableView];
    self.progressHUD.labelText = @"正在提交...";
    self.progressHUD.labelFont = [UIFont systemFontOfSize:12];
//    self.progressHUD.dimBackground = YES;
    self.progressHUD.opacity=1.0;
    self.progressHUD.delegate = self;
    [self.tableView addSubview:self.progressHUD];
    [self.progressHUD show:YES];
    
    DDLogCInfo(@"******  Request URL is:%@  ******",url);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithInt:kSharedApp.finalFactoryId] forKey:@"factoryId"];
    [self.request setPostValue:[kSharedApp.user objectForKey:@"id"] forKey:@"id"];
    [self.request setPostValue:self.currentPassword forKey:@"oldPass"];
    [self.request setPostValue:self.password forKey:@"password"];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(requestFailed:)];
    [self.request setDidFinishSelector:@selector(requestSuccess:)];
    [self.request startAsynchronous];
}

#pragma mark 网络请求
-(void) requestFailed:(ASIHTTPRequest *)request{
    [self.progressHUD hide:YES];
}

-(void)requestSuccess:(ASIHTTPRequest *)request{
    [self.progressHUD hide:YES];
    self.textCurrentPassword.text = @"";
    self.textNewPassword.text = @"";
    self.textNewPassword2.text = @"";
    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
    int errorCode = [[dict objectForKey:@"error"] intValue];
    if (errorCode==kErrorCode0) {
//        [self.navigationController popViewControllerAnimated:YES];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.password forKey:@"password"];
        [self showErrorMessage:[dict objectForKey:@"message"]];
    }else if(errorCode==kErrorCodeExpired){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }else if(errorCode==101){
        [self showErrorMessage:[dict objectForKey:@"message"]];
    }
}

-(void)showErrorMessage:(NSString *)message{
    if (message) {
        self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        self.progressHUD.mode = MBProgressHUDModeText;
        self.progressHUD.labelText = message;
        self.progressHUD.labelFont = [UIFont systemFontOfSize:13.f];
        self.progressHUD.margin = 5.f;
//        self.progressHUD.yOffset = 20;
        self.progressHUD.delegate = self;
        [self.view addSubview:self.progressHUD];
        [self.progressHUD show:YES];
        [self.progressHUD hide:YES afterDelay:1];
    }
}
@end
