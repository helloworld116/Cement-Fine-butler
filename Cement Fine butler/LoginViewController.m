//
//  LoginViewController.m
//  CustomerSystem
//
//  Created by wzg on 13-4-22.
//  Copyright (c) 2013年 denglei. All rights reserved.
//

#import "LoginViewController.h"
#import "ProductColumnViewController.h"
#import "RawMaterialsCostManagerViewController.h"
#import "InventoryColumnViewController.h"

#define kViewTag 12000

@interface LoginViewController ()<MBProgressHUDDelegate>
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (nonatomic,retain) MBProgressHUD *HUD;
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
    [self.btnLogin setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setBackground];
    self.username.delegate = self;
    self.password.delegate = self;
    self.username.text = @"fbadmin";
    self.password.text = @"654321";
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
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.HUD];
        self.HUD.delegate = self;
        self.HUD.minShowTime = 3;//最少显示时间为3秒
        self.HUD.dimBackground = YES;//
        self.HUD.labelText = @"正在登录...";
        [self.HUD showWhileExecuting:@selector(sendRequest) onTarget:self withObject:nil animated:YES];
//        [self.HUD show:YES];
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
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.HUD.mode = MBProgressHUDModeText;
        self.HUD.labelText = @"用户名不能为空";
        self.HUD.labelFont = [UIFont systemFontOfSize:13.f];
        self.HUD.margin = 5.f;
        self.HUD.yOffset = (kScreenHeight-kStatusBarHeight)/2-35;
        self.HUD.removeFromSuperViewOnHide = YES;
        [self.HUD hide:YES afterDelay:2];
        return NO;
    }
    if (self.pword ==nil || [@"" isEqualToString:self.pword]) {
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.HUD.mode = MBProgressHUDModeText;
        self.HUD.labelText = @"密码不能为空";
        self.HUD.labelFont = [UIFont systemFontOfSize:13.f];
        self.HUD.margin = 5.f;
        self.HUD.yOffset = (kScreenHeight-kStatusBarHeight)/2-35;
        self.HUD.removeFromSuperViewOnHide = YES;
        [self.HUD hide:YES afterDelay:2];
        return NO;
    }
    return YES;
}

- (IBAction)backgroundTouch:(id)sender {
    self.keyboardWasShow = NO;
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}

-(UITabBarController *) showViewControllers{
    NSArray *lines = [kSharedApp.factory objectForKey:@"lines"];
    NSMutableArray *lineArray = [NSMutableArray arrayWithObject:@{@"name":@"全部",@"_id":[NSNumber numberWithInt:0]}];
    for (NSDictionary *line in lines) {
        NSString *name = [line objectForKey:@"name"];
        NSNumber *_id = [NSNumber numberWithLong:[[line objectForKey:@"id"] longValue]];
        NSDictionary *dict = @{@"_id":_id,@"name":name};
        [lineArray addObject:dict];
    }
    NSArray *products = [kSharedApp.factory objectForKey:@"products"];
    NSMutableArray *productArray = [NSMutableArray arrayWithObject:@{@"name":@"全部",@"_id":[NSNumber numberWithInt:0]}];
    for (NSDictionary *product in products) {
        NSString *name = [product objectForKey:@"name"];
        NSNumber *_id = [NSNumber numberWithLong:[[product objectForKey:@"id"] longValue]];
        NSDictionary *dict = @{@"_id":_id,@"name":name};
        [productArray addObject:dict];
    }
    NSArray *timeArray = kCondition_Time_Array;
    //根据权限选择需要展现的视图
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    //原材料成本管理模块
    JASidePanelController *costManagerController = [[JASidePanelController alloc] init];
    costManagerController.tabBarItem = [costManagerController.tabBarItem initWithTitle:@"成本" image:nil tag:kViewTag+1];
    RawMaterialsCostManagerViewController *rawMaterialsCostManagerViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"rawMaterialsCostManagerViewController"];
    [costManagerController setCenterPanel:rawMaterialsCostManagerViewController];
    RightViewController* costManagerRightController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
    costManagerRightController.conditions = @[@{@"时间段":timeArray},@{@"产线":lineArray},@{@"产品":productArray}];
    [costManagerController setRightPanel:costManagerRightController];
    //实时报表（默认产量报表）
    JASidePanelController *realTimeReportsController = [[JASidePanelController alloc] init];
    realTimeReportsController.tabBarItem = [realTimeReportsController.tabBarItem initWithTitle:@"实时报表" image:nil tag:kViewTag+2];
    ProductColumnViewController *productColumnViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"productColumnViewController"];
    LeftViewController *realTimeReportsLeftController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"];
    NSArray *reportType = @[@"产量报表",@"库存报表"];
    realTimeReportsLeftController.conditions = @[@{@"实时报表":reportType}];
    RightViewController* realTimeReportsRightController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
//    NSArray *stockType = @[@{@"_id":[NSNumber numberWithInt:0],@"name":@"原材料库存"},@{@"_id":[NSNumber numberWithInt:1],@"name":@"成品库存"}];
    realTimeReportsRightController.conditions = @[@{@"时间段":timeArray},@{@"产线":lineArray},@{@"产品":productArray}];
    [realTimeReportsController setCenterPanel:productColumnViewController];
    [realTimeReportsController setLeftPanel:realTimeReportsLeftController];
    [realTimeReportsController setRightPanel:realTimeReportsRightController];
    //设备管理
    UINavigationController *equipmentController = [self.storyboard instantiateViewControllerWithIdentifier:@"equipmentNavController"];
    equipmentController.tabBarItem = [equipmentController.tabBarItem initWithTitle:@"设备" image:nil tag:kViewTag+3];
    //消息
    UINavigationController *messageController = [self.storyboard instantiateViewControllerWithIdentifier:@"messageNavController"];
    messageController.tabBarItem = [messageController.tabBarItem initWithTitle:@"消息" image:nil tag:kViewTag+4];
    tabBarController.viewControllers = @[costManagerController,realTimeReportsController,equipmentController,messageController];
    return tabBarController;
}

#pragma mark 发送网络请求
-(void) sendRequest {
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kLoginURL]];
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:self.uname forKey:@"username"];
    [self.request setPostValue:self.pword forKey:@"password"];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(requestFailed:)];
    [self.request setDidFinishSelector:@selector(requestSuccess:)];
    [self.request startAsynchronous];
}

#pragma mark 网络请求
-(void) requestFailed:(ASIHTTPRequest *)request{
//    [SVProgressHUD showErrorWithStatus:@"网络请求出错"];
    self.password.text = nil;
}

-(void)requestSuccess:(ASIHTTPRequest *)request{
    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
    if ([[dict objectForKey:@"error"] intValue]==0) {
        NSDictionary *data = [dict objectForKey:@"data"];
        kSharedApp.accessToken = [data objectForKey:@"accessToken"];
        kSharedApp.expiresIn = [[data objectForKey:@"expiresIn"] intValue];
        kSharedApp.factory = [data objectForKey:@"factory"];
        //保存用户名和密码
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.uname forKey:@"username"];
        [userDefaults setObject:self.pword forKey:@"password"];
//        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
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
        
        
//        ProductColumnViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"productColumnViewController"];
//        UITabBarController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
        UITabBarController *tabBarController = [self showViewControllers];
        tabBarController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:tabBarController animated:YES completion:nil];
    }else{
        self.password.text = nil;
        NSString *msg = [dict objectForKey:@"description"];
//        [SVProgressHUD showErrorWithStatus:msg];
    }
}

#pragma mark textfield代理
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
        rect.origin.y += 90;
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
        rect.origin.y -= 90;
        self.continerView.frame = rect;
        [UIView commitAnimations];
        self.keyboardWasShow = YES;
    }
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[self.HUD removeFromSuperview];
	self.HUD = nil;
}
@end
