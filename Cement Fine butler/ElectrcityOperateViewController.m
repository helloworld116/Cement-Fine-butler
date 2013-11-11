//
//  ElectrcityOperateViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-26.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "ElectrcityOperateViewController.h"

@interface ElectrcityOperateViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateValue;
    if (self.electricityInfo) {
        self.title = @"修改电力价格";
        self.textElectricityPrice.text = [NSString stringWithFormat:@"%.2f",[[self.electricityInfo objectForKey:@"price"] floatValue]];
         dateValue = [self.electricityInfo objectForKey:@"createTime_str"];
    }else{
        self.title = @"添加电力价格";
        dateValue =  [dateFormatter stringFromDate:[NSDate date]];
    }
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    [self.textElectricityPrice becomeFirstResponder];
    self.tableView.bounces = NO;
    self.datePicker.hidden = YES;
    self.lblDate.text = dateValue;
    self.datePicker.date = [dateFormatter dateFromString:dateValue];
//    self.tableView.sectionFooterHeight = 100.f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)save:(id)sender{
    
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
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    int factoryId = [[kSharedApp.factory objectForKey:@"id"] intValue];
    [self.request setPostValue:[NSNumber numberWithInt:factoryId] forKey:@"factoryId"];
    [self.request setPostValue:@"" forKey:@"price"];
    [self.request setPostValue:@"" forKey:@"createTime_str"];
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
    if (errorCode==0) {
        long databaseId;
        if (self.electricityInfo) {
            //修改操作
            databaseId = [[self.electricityInfo objectForKey:@"id"] longValue];
        }else{
            databaseId = [[dict objectForKey:@"data"] longValue];
        }
//        NSDictionary *dict = @{@"id":[NSNumber numberWithLong:databaseId],@"lineId":[NSNumber numberWithLong:self.lineId],@"lineName": self.lblLine.text,@"productId": [NSNumber numberWithLong:self.productId],@"productName": self.lblProduct.text,@"time":self.lblTime.text};
//        [self.delegate passValue:dict];
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
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
