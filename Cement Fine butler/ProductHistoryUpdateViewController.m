//
//  ProductHistoryUpdateViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "ProductHistoryUpdateViewController.h"
#import "ProductChoiceViewController.h"
#import "LineChoiceViewController.h"

@interface ProductHistoryUpdateViewController ()<PassValueDelegate,MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblLine;
@property (strong, nonatomic) IBOutlet UILabel *lblProduct;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic) long _id;//生产记录id
@property (nonatomic) long lineId;//产线id
@property (nonatomic) long productId;//产品id
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
- (IBAction)dateChange:(id)sender;
@end

@implementation ProductHistoryUpdateViewController

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
    NSString *title = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (self.productHistoryInfo) {
        title = @"修改";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(update:)];
        self._id = [[self.productHistoryInfo objectForKey:@"id"] longValue];
        self.lblLine.text = [Tool stringToString:[self.productHistoryInfo objectForKey:@"name"]];
        self.lineId = [[self.productHistoryInfo objectForKey:@"lineId"] longValue];
        self.lblProduct.text = [Tool stringToString:[self.productHistoryInfo objectForKey:@"productZhDes"]];
        self.productId = [[self.productHistoryInfo objectForKey:@"productId"] longValue];
        NSString *startTime = [Tool stringToString:[self.productHistoryInfo objectForKey:@"start_time_str"]];
        self.lblTime.text = startTime;
        self.datePicker.date = [dateFormatter dateFromString:startTime];
    }else{
        title = @"添加";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(add:)];
        self.lblLine.text = @"请选择";
        self.lblProduct.text = @"请选择";
        self.lblTime.text = [dateFormatter stringFromDate:[NSDate date]];
    }
    self.title = [title stringByAppendingFormat:@"%@",@"生产记录"];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            self.datePicker.hidden = YES;
            LineChoiceViewController *nextViewController = [[LineChoiceViewController alloc] init];
            nextViewController.lineId = self.lineId;
            nextViewController.delegate = self;
            [self.navigationController pushViewController:nextViewController animated:YES];
        }
            break;
        case 1:{
            self.datePicker.hidden = YES;
            ProductChoiceViewController *nextViewController = [[ProductChoiceViewController alloc] init];
            nextViewController.productId = self.productId;
            nextViewController.delegate = self;
            [self.navigationController pushViewController:nextViewController animated:YES];
        }
            break;
        case 2:
            self.datePicker.hidden = NO;
            break;
    }
}

- (IBAction)dateChange:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *select = [self.datePicker date];
    NSString *dateString =  [dateFormatter stringFromDate:select];
    self.lblTime.text = dateString;
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
    self.request.timeOutSeconds = kASIHttpRequestTimeoutSeconds;
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    int factoryId = [[kSharedApp.factory objectForKey:@"id"] intValue];
    [self.request setPostValue:[NSNumber numberWithInt:factoryId] forKey:@"factoryId"];
    [self.request setPostValue:[NSNumber numberWithLong:self.lineId] forKey:@"lineId"];
    [self.request setPostValue:[NSNumber numberWithLong:self.productId] forKey:@"productId"];
    [self.request setPostValue:self.lblTime.text forKey:@"start_time_str"];
    [self.request setPostValue:[NSNumber numberWithLong:self._id] forKey:@"id"];
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
        //修改操作
        if (self.productHistoryInfo) {
            databaseId = [[self.productHistoryInfo objectForKey:@"id"] longValue];
        }else{
            databaseId = [[dict objectForKey:@"data"] longValue];
        }
        NSDictionary *dict = @{@"id":[NSNumber numberWithLong:databaseId],@"lineId":[NSNumber numberWithLong:self.lineId],@"lineName": self.lblLine.text,@"productId": [NSNumber numberWithLong:self.productId],@"productName": self.lblProduct.text,@"time":self.lblTime.text};
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

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)add:(id)sender{
    [self sendRequest:kProductHistoryAdd];
}

-(void)update:(id)sender{
    [self sendRequest:kProductHistoryUpdate];
}

#pragma mark InventoryPassValueDelegate
-(void)passValue:(NSDictionary *)newValue{
    if ([newValue objectForKey:@"lineName"]) {
        self.lineId = [[newValue objectForKey:@"lineId"] longValue];
        self.lblLine.text = [newValue objectForKey:@"lineName"];
    }
    if ([newValue objectForKey:@"productName"]) {
        self.productId = [[newValue objectForKey:@"productId"] longValue];
        self.lblProduct.text = [newValue objectForKey:@"productName"];
    }
}
@end
