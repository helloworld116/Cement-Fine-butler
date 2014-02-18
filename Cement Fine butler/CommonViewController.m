//
//  CommonViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-4.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

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
	// Do any additional setup after loading the view
    self.messageView = [[PromptMessageView alloc] initWithFrame:CGRectZero];
    self.messageView.hidden = YES;
    [self.view addSubview:self.messageView];
    //默认查询条件
    self.condition = [[SearchCondition alloc] initWithInventoryType:0 timeType:2 lineID:0 productID:0 unitCostType:0];
    self.timeType = 0;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //需要增加左右界面的需再viewWillAppear中添加
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.sidePanelController setRightPanel:self.rightVC];
    [self.sidePanelController setLeftPanel:self.leftVC];
    [self.sidePanelController setLeftFixedWidth:140.f];
    //观察查询条件修改
    if (self.rightVC) {
        [self.rightVC addObserver:self forKeyPath:@"searchCondition" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        TimeTableView *timeTableView = self.rightVC.timeTableView;
        if (timeTableView) {
            int timeSelectIndex = [timeTableView indexPathForSelectedRow].row;
            if (timeSelectIndex==4) {
                timeTableView.currentSelectCellIndex=4;
                [timeTableView reloadData];
            }
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移除观察条件
    if (self.rightVC) {
        [self.rightVC removeObserver:self forKeyPath:@"searchCondition"];
        TimeTableView *timeTableView = self.rightVC.timeTableView;
        if (timeTableView) {
            int timeSelectIndex = [timeTableView indexPathForSelectedRow].row;
            if (timeSelectIndex!=4) {
                [self.sidePanelController setRightPanel:nil];
            }
        }else{
            [self.sidePanelController setRightPanel:nil];
        }
    }
    [self.sidePanelController setLeftPanel:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 发送网络请求
-(void) sendRequest{
    //清除数据及处理界面
    self.responseData = nil;
    self.data = nil;
    self.messageView.hidden = YES;
    //自定义清除
    [self clear];
    //加载过程提示
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.labelText = @"正在加载中...";
    self.progressHUD.labelFont = [UIFont systemFontOfSize:12];
    //    self.progressHUD.dimBackground = YES;
    self.progressHUD.opacity=1.0;
    self.progressHUD.delegate = self;
    [self.view addSubview:self.progressHUD];
    [self.progressHUD show:YES];
    
    DDLogCInfo(@"******  Request URL is:%@  ******",self.URL);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:self.URL]];
    self.request.timeOutSeconds = kASIHttpRequestTimeoutSeconds;
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithInt:kSharedApp.finalFactoryId] forKey:@"factoryId"];
    [self setRequestParams];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(requestFailed:)];
    [self.request setDidFinishSelector:@selector(requestSuccess:)];
    [self.request startAsynchronous];
}

#pragma mark 网络请求
-(void) requestFailed:(ASIHTTPRequest *)request{
    [self.progressHUD hide:YES];
    NSString *message = nil;
    if ([@"The request timed out" isEqualToString:[[request error] localizedDescription]]) {
        message = @"网络请求超时啦。。。";
    }else{
        message = @"网络出错啦。。。";
    }
    self.messageView.frame = self.view.frame;
    self.messageView.labelMsg.text = message;
    self.messageView.hidden = NO;
}

-(void)requestSuccess:(ASIHTTPRequest *)request{
    [self.progressHUD hide:YES];
    self.responseData = [Tool stringToDictionary:request.responseString];
    int errorCode = [[self.responseData objectForKey:@"error"] intValue];
    if (errorCode==kErrorCode0) {
        self.data = [self.responseData objectForKey:@"data"];
        if ([Tool isNullOrNil:self.data]) {
            self.messageView.frame = self.view.frame;
            self.messageView.labelMsg.text = @"没有满足条件的数据！！！";
            self.messageView.hidden = NO;
            [self responseCode0WithNOData];
        }else{
            [self responseCode0WithData];
        }
    }else if(errorCode==kErrorCodeExpired){
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
            kSharedApp.window.rootViewController = loginViewController;
        });
    }else{
        [self responseWithOtherCode];
    }
}

#pragma mark observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"searchCondition"]) {
        self.condition = [change objectForKey:@"new"];
        if (4==self.condition.timeType) {
        }
        [self sendRequest];
    }
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[self.progressHUD removeFromSuperview];
	self.progressHUD = nil;
}

#pragma mark 自定义VC必须实现的方法
-(void)responseCode0WithData{

}

-(void)responseWithOtherCode{
    self.messageView.frame = self.view.frame;
    self.messageView.labelMsg.text = @"系统异常！！！";
    self.messageView.hidden = NO;
}

#pragma mark 自定义VC可选实现的方法
-(void)clear{}

-(void)setRequestParams{}

-(void)setPanels{}

-(void)responseCode0WithNOData{}
@end
