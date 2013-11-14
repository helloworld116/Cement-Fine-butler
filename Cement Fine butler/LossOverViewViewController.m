//
//  LossOverViewViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-11.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "LossOverViewViewController.h"
#import "LossReportViewController.h"

#define kLossType @[@"原材料损耗",@"半成品损耗",@"成品损耗"]

@interface LossOverViewViewController ()<MBProgressHUDDelegate>
@property (retain,nonatomic) UIWebView *webView;
@property (retain,nonatomic) NSDictionary *responseData;

@property (retain,nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) NSString *reportTitlePre;
@property (retain, nonatomic) NODataView *noDataView;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (nonatomic) int currentSelectIndex;
@end

@implementation LossOverViewViewController

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
    self.navigationItem.title = @"损耗总览";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch:)];
    
//    NSString *testData = @"{\"error\":\"0\",\"message\":\"1\",\"data\":{\"overView\":{\"totalLoss\":2200.0,\"rawMaterialsLoss\":600.0,\"semifinishedProductLoss\":1000.0,\"endProductLoss\":600.0},\"rawMaterials\":[{\"name\":\"熟料\",\"value\":100.0},{\"name\":\"石膏\",\"value\":200.0}],\"semifinishedProduct\":[{\"name\":\"熟料粉\",\"value\":1000.0}],\"endProduct\":[{\"name\":\"P.O42.5\",\"value\":100.0},{\"name\":\"P.O52.5\",\"value\":500.0}]}}";
//    self.responseData = [Tool stringToDictionary:testData];
    //添加webview
    CGRect webViewRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight);
    self.webView = [[UIWebView alloc] initWithFrame:webViewRect];
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor clearColor];
    UIScrollView *sc = (UIScrollView *)[[self.webView subviews] objectAtIndex:0];
    sc.showsHorizontalScrollIndicator = NO;
    sc.showsVerticalScrollIndicator = NO;
    sc.bounces = NO;//禁用上下拖拽
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Donut2D" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.webView];
    self.webView.hidden = YES;
    
    //send request
    NSDictionary *condition = @{@"timeType":[NSNumber numberWithInt:2]};
    [self sendRequest:condition];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden=YES;
    if ((kSharedApp.startFactoryId!=kSharedApp.finalFactoryId)&&self.responseData) {
        self.responseData = nil;
        //send request
        NSDictionary *condition = @{@"timeType":[NSNumber numberWithInt:2]};
        [self sendRequest:condition];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *js = [@"rebound(" stringByAppendingFormat:@"%d)",self.currentSelectIndex];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
    [self.sidePanelController.rightPanel addObserver:self forKeyPath:@"searchCondition" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    RightViewController *rightController = (RightViewController *)self.sidePanelController.rightPanel;
    TimeTableView *timeTableView = rightController.timeTableView;
    NSIndexPath *indexPath = [timeTableView indexPathForSelectedRow];
    if (indexPath.row==4) {
        timeTableView.currentSelectCellIndex=4;
        [timeTableView reloadData];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.sidePanelController.rightPanel removeObserver:self forKeyPath:@"searchCondition"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"searchCondition"]) {
        SearchCondition *searchCondition = [change objectForKey:@"new"];
        NSDictionary *condition = @{@"timeType":[NSNumber numberWithInt:searchCondition.timeType]};
//        if (4==[[condition objectForKey:@"timeType"] intValue]) {
//            self.showRight = YES;
//        }
        [self sendRequest:condition];
    }
}

-(void)showSearch:(id)sender{
    [self.sidePanelController showRightPanelAnimated:YES];
}

#pragma mark begin webviewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if([[components objectAtIndex:0] isEqualToString:@"sector"]&&[[components objectAtIndex:1] isEqualToString:@"false"]){
//        debugLog(@"the dict is %@",[self.costItems objectAtIndex:[[components objectAtIndex:2] intValue]]);
        int index = [[components objectAtIndex:2] intValue];
        self.currentSelectIndex = index;
        //index的值与kLossType中损耗类型索引相同
        NSArray *lossData = nil;
        NSDictionary *data = [self.responseData objectForKey:@"data"];
        if (index==0) {
            //原材料损耗
            lossData = [data objectForKey:@"rawMaterials"];
        }else if (index==1){
            //半成品损耗
            lossData = [data objectForKey:@"semifinishedProduct"];
        }else if (index==2){
            //成品损耗
            lossData = [data objectForKey:@"endProduct"];
        }
        LossReportViewController *lossReportViewController = [[LossReportViewController alloc] init];
        lossReportViewController.titlePre = self.reportTitlePre;
        lossReportViewController.title = [kLossType objectAtIndex:index];
        lossReportViewController.dataArray = lossData;
        lossReportViewController.hidesBottomBarWhenPushed = YES;
//        [self.navigationController performSelector:@selector(pushViewController:animated:) withObject:@[@"lossReportViewController",[NSNumber numberWithBool:YES]] afterDelay:0.3f];
        [self.navigationController pushViewController:lossReportViewController animated:YES];
        return NO;
    }
    return YES;

}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSDictionary *data = [self.responseData objectForKey:@"data"];
    NSDictionary *overview = [data objectForKey:@"overview"];
    if (overview&&[[overview objectForKey:@"totalLoss"] doubleValue]>0) {
        double totalLoss = [[overview objectForKey:@"totalLoss"] doubleValue];
        //原材料损耗
        double rawMaterialsLoss = [[overview objectForKey:@"rawMaterialsLoss"] doubleValue];
        NSDictionary *rawMaterialsDict = @{@"name":[kLossType objectAtIndex:0],@"value":[NSNumber numberWithDouble:rawMaterialsLoss],@"color":[kColorList objectAtIndex:0]};
        //半成品损耗
        double semifinishedProductLoss = [[overview objectForKey:@"semifinishedProductLoss"] doubleValue];
        NSDictionary *semifinishedProductDict = @{@"name":[kLossType objectAtIndex:1],@"value":[NSNumber numberWithDouble:semifinishedProductLoss],@"color":[kColorList objectAtIndex:1]};
        //成品损耗
        double endProductLoss = [[overview objectForKey:@"endProductLoss"] doubleValue];
        NSDictionary *endProductDict = @{@"name":[kLossType objectAtIndex:2],@"value":[NSNumber numberWithDouble:endProductLoss],@"color":[kColorList objectAtIndex:2]};
        NSArray *dataArray = @[rawMaterialsDict,semifinishedProductDict,endProductDict];
        NSDictionary *configDict = @{@"totalLoss":[NSNumber numberWithDouble:totalLoss],@"unit":@"吨",@"title":[self.reportTitlePre stringByAppendingString:@"损耗总览"],@"height":[NSNumber numberWithFloat:self.webView.frame.size.height],@"width":[NSNumber numberWithFloat:self.webView.frame.size.width]};
        NSString *js = [NSString stringWithFormat:@"drawDonut2D('%@','%@')",[Tool objectToString:dataArray],[Tool objectToString:configDict]];
        DDLogVerbose(@"dates is %@",js);
        [webView stringByEvaluatingJavaScriptFromString:js];
    }
    self.webView.hidden = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate


#pragma mark 发送网络请求
-(void) sendRequest:(NSDictionary *)condition{
    //清除原数据
    self.responseData = nil;
    if (self.noDataView) {
        [self.noDataView removeFromSuperview];
        self.noDataView = nil;
    }
    self.webView.hidden=YES;
    //加载过程提示
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.labelText = @"加载中...";
    self.progressHUD.labelFont = [UIFont systemFontOfSize:12];
    self.progressHUD.dimBackground = YES;
    self.progressHUD.opacity=1.0;
    self.progressHUD.delegate=self;
    self.progressHUD.minShowTime=0.5;
    [self.view addSubview:self.progressHUD];
    [self.progressHUD show:YES];
    
    int timeType = [[condition objectForKey:@"timeType"] intValue];
    NSDictionary *timeInfo = [Tool getTimeInfo:timeType];
    self.reportTitlePre = [timeInfo objectForKey:@"timeDesc"];
    DDLogCInfo(@"******  Request URL is:%@  ******",kLoss);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kLoss]];
    self.request.timeOutSeconds = kASIHttpRequestTimeoutSeconds;
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    int factoryId = [[kSharedApp.factory objectForKey:@"id"] intValue];
    [self.request setPostValue:[NSNumber numberWithInt:factoryId] forKey:@"factoryId"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"startTime"] longLongValue]] forKey:@"startTime"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"endTime"] longLongValue]] forKey:@"endTime"];
    
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
    self.responseData = [Tool stringToDictionary:request.responseString];
    int errorCode = [[self.responseData objectForKey:@"error"] intValue];
    if (errorCode==0) {
        //服务端正常响应，但是没有数据，数据都为0
        if ([[[self.responseData objectForKey:@"data"] objectForKey:@"totalLoass"] doubleValue]==0) {
            self.noDataView = [[NODataView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight)];
            [self.view performSelector:@selector(addSubview:) withObject:self.noDataView afterDelay:0.5];
        }else{
            [self.webView reload];
        }
    }else if(errorCode==kErrorCodeExpired){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }else{
        self.responseData = nil;
        [self.webView reload];
        self.noDataView = [[NODataView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight)];
        [self.view performSelector:@selector(addSubview:) withObject:self.noDataView afterDelay:0.5];
    }
    [self.progressHUD hide:YES];
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[self.progressHUD removeFromSuperview];
	self.progressHUD = nil;
}
@end
