//
//  ElectrcityOperateViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-26.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "ElectrcityOperateViewController.h"

@interface ElectrcityOperateViewController ()<MBProgressHUDDelegate,UITextFieldDelegate>
@property (nonatomic,retain) UIBarButtonItem *rightBarButtonItem;
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@end

@implementation ElectrcityOperateViewController

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
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {//使变短的分割线延伸
//        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
    if (IS_IOS7) {
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 10.f)];
    }
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_2.png"]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateValue;
    if (self.electricityInfo) {
        self.title = @"修改电力价格";
        self.textElectricityPrice.text = [NSString stringWithFormat:@"%.2f",[[self.electricityInfo objectForKey:@"price"] floatValue]];
        dateValue = [Tool stringToString:[self.electricityInfo objectForKey:@"createTime_str"]];
    }else{
        self.title = @"添加电力价格";
        dateValue = [dateFormatter stringFromDate:[NSDate date]];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_icon"] highlightedImage:[UIImage imageNamed:@"return_click_icon"] target:self action:@selector(pop:)];

    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithText:@"保存" target:self action:@selector(save:)];
//    [self.textElectricityPrice becomeFirstResponder];
    self.textElectricityPrice.delegate = self;
    self.tableView.bounces = NO;
    self.datePicker.hidden = YES;
    [self.textElectricityPrice addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
    self.lblDate.text = dateValue;
    if(![@"" isEqualToString:dateValue]){
        self.datePicker.date = [dateFormatter dateFromString:dateValue];
    }
    if (IS_IPHONE_5) {
        self.tableView.sectionFooterHeight += 88;
    }
//    self.tableView.sectionFooterHeight = 100.f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)save:(id)sender{
    if (self.electricityInfo) {
        //修改
        [self sendRequest:kElectricityUpdate];
    }else{
        //添加
        [self sendRequest:kElectricityAdd];
    }
}

#pragma mark tableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        [self.textElectricityPrice becomeFirstResponder];
        self.datePicker.hidden = YES;
    }else{
        [self.lblDate becomeFirstResponder];
        self.datePicker.hidden = NO;
        [self.textElectricityPrice resignFirstResponder];
    }
}

#pragma mark 发送网络请求
-(void) sendRequest:(NSString *)url{
    [self.textElectricityPrice resignFirstResponder];
    self.datePicker.hidden = YES;
    
    //加载过程提示
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.tableView];
    self.progressHUD.labelText = @"正在提交...";
    self.progressHUD.labelFont = [UIFont systemFontOfSize:12];
    self.progressHUD.dimBackground = YES;
    self.progressHUD.opacity=1.0;
    self.progressHUD.delegate = self;
    [self.tableView addSubview:self.progressHUD];
    [self.progressHUD show:YES];
    
    DDLogCInfo(@"******  Request URL is:%@  ******",url);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    self.request.timeOutSeconds = kASIHttpRequestTimeoutSeconds;
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithInt:kSharedApp.finalFactoryId] forKey:@"factoryId"];
    NSString *price = [self.textElectricityPrice.text stringByTrimmingCharactersInSet:
     [NSCharacterSet whitespaceCharacterSet]];
    [self.request setPostValue:price forKey:@"price"];
    [self.request setPostValue:self.lblDate.text forKey:@"createTime_str"];
    if (self.electricityInfo) {
        //修改传id
        [self.request setPostValue:[self.electricityInfo objectForKey:@"id"] forKey:@"id"];
    }
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
    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
    int errorCode = [[dict objectForKey:@"error"] intValue];
    if (errorCode==kErrorCode0) {
        long databaseId;
        if (self.electricityInfo) {
            //修改操作
            databaseId = [[self.electricityInfo objectForKey:@"id"] longValue];
        }else{
            databaseId = [[dict objectForKey:@"data"] longValue];
        }
        NSDictionary *dict = @{@"id":[NSNumber numberWithLong:databaseId],@"createTime_str":self.lblDate.text,@"price":[self.textElectricityPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]};
        [self.delegate passValue:dict];
        [self.navigationController popViewControllerAnimated:YES];
    }else if(errorCode==kErrorCodeExpired){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }else{
        
    }
    [self.progressHUD hide:YES];
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[self.progressHUD removeFromSuperview];
	self.progressHUD = nil;
}

- (IBAction)dateChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *select = [self.datePicker date];
    NSString *dateString =  [dateFormatter stringFromDate:select];
    self.lblDate.text = dateString;
    [self rightButtonShowOrHidden];
}

#pragma mark UITextField监听
- (void)textFieldDidChange:(UITextField *)textField{
    [self rightButtonShowOrHidden];
}

//控制右边添加或修改按钮是否显示
-(void)rightButtonShowOrHidden{
    if (self.electricityInfo) {
        NSString *originPrice = [NSString stringWithFormat:@"%.2f",[[self.electricityInfo objectForKey:@"price"] floatValue]];
        NSString *currentPrice = self.textElectricityPrice.text;
        NSString *originDate = [self.electricityInfo objectForKey:@"createTime_str"];
        NSString *currentDate = self.lblDate.text;
        if ((![originPrice isEqualToString:currentPrice])||(![originDate isEqualToString:currentDate])) {
            self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
        }else{
            self.navigationItem.rightBarButtonItem = nil;
        }
    }else{
        if (![@"" isEqualToString:self.textElectricityPrice.text]) {
            self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
        }else{
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}

#pragma mark UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField selectAll:self];
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
