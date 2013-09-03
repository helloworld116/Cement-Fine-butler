//
//  LoginViewController.m
//  CustomerSystem
//
//  Created by wzg on 13-4-22.
//  Copyright (c) 2013年 denglei. All rights reserved.
//

#import "LoginViewController.h"
#import "ProductColumnViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()
@property (nonatomic,copy) NSString *uname;
@property (nonatomic,copy) NSString *pword;
@property BOOL keyboardWasShow;
@end
//{"error":0,"message":null,"data":{"factoryId":1,"accessToken":"sertf231412312342wer","expiresIn":10000,"modules":["productionView","priceAssistant","equipmentManagement"]}}

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setBackground{
    self.backgroundImgView.image = [UIImage imageNamed:@"login_background.png"];
    self.continerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"body.png"]];
    self.titleImgView.image = [UIImage imageNamed:@"title.png"];
    self.username.background = [UIImage imageNamed:@"username.png"];
    self.password.background = [UIImage imageNamed:@"password.png"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setBackground];
    self.navigationController.navigationBarHidden = YES;
    self.username.delegate = self;
    self.password.delegate = self;
    self.username.text = @"fengbo";
    self.password.text = @"123456";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUsername:nil];
    [self setPassword:nil];
    [self setPassword:nil];
  
    self.uname = nil;
    self.pword = nil;
    [self setContinerView:nil];
    [self setTitleImgView:nil];
    [self setBtnLogin:nil];
    [self setBackgroundImgView:nil];
    [super viewDidUnload];
}

- (IBAction)doLogin:(id)sender {
    if([self validate]){
        self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kLoginURL]];
        [self.request setUseCookiePersistence:YES];
        [self.request setPostValue:self.uname forKey:@"username"];
        [self.request setPostValue:self.pword forKey:@"password"];
        [self.request setDelegate:self];
        [self.request setDidFailSelector:@selector(requestFailed:)];
        [self.request setDidFinishSelector:@selector(requestLogin:)];
        [self.request startAsynchronous];
        [SVProgressHUD showWithStatus:@"正在登录..." maskType:SVProgressHUDMaskTypeGradient];
    }
}

-(BOOL)validate{
    //键盘缩回
    self.keyboardWasShow = NO;
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    //过滤左右空格
    self.uname = [self.username.text stringByTrimmingCharactersInSet:
    [NSCharacterSet whitespaceCharacterSet]];
    self.pword = [self.password.text stringByTrimmingCharactersInSet:
    [NSCharacterSet whitespaceCharacterSet]];
    if (self.uname == nil || [@"" isEqualToString:self.uname]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"用户名不能为空";
        hud.margin = 10.f;
        hud.yOffset = 180.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        return NO;
    }
    if (self.pword ==nil || [@"" isEqualToString:self.pword]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"密码不能为空";
        hud.margin = 10.f;
        hud.yOffset = 180.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        return NO;
    }
    return YES;
}

- (IBAction)backgroundTouch:(id)sender {
    self.keyboardWasShow = NO;
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}

-(void) requestFailed:(ASIHTTPRequest *)request{
    [SVProgressHUD showErrorWithStatus:@"网络请求出错"];
    self.password.text = nil;
}

-(void)requestLogin:(ASIHTTPRequest *)request{
    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
    if ([[dict objectForKey:@"error"] intValue]==0) {
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
//        kSharedApp.accessToken = [[dict objectForKey:@"data"] objectForKey:@"accessToken"];
//        kSharedApp.factoryId = [[dict objectForKey:@"data"] objectForKey:@"factoryId"];
//        UITabBarController *tab = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"tab"];
//        [tab.tabBar setBackgroundImage:[UIImage imageNamed:@"tabBar.png"]];
//        CATransition *animation = [CATransition animation];
//        [animation setDuration:1.0];
//        [animation setType: kCATransitionFade];
//        [animation setSubtype: kCATransitionFromTop];
//        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
//        [self.navigationController setNavigationBarHidden:YES animated:NO];
//        [self.navigationController pushViewController:tab animated:NO];
//        [self.navigationController.view.layer addAnimation:animation forKey:nil];
        ProductColumnViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"productColumnViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        self.password.text = nil;
        NSString *msg = [dict objectForKey:@"description"];
        [SVProgressHUD showErrorWithStatus:msg];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.keyboardWasShow = NO;
    [textField resignFirstResponder];
    return YES;
}

    
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (!self.keyboardWasShow) {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"DownKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        CGRect rect = self.continerView.frame;
        rect.origin.y += 65;
        self.continerView.frame = rect;
        [UIView commitAnimations];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (!self.keyboardWasShow) {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"UpKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        CGRect rect = self.continerView.frame;
        rect.origin.y -= 65;
        self.continerView.frame = rect;
        [UIView commitAnimations];
        self.keyboardWasShow = YES;
    }
}
@end
