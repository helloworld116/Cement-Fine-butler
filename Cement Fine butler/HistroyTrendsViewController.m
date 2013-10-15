//
//  HistroyTrendsViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-21.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "HistroyTrendsViewController.h"

@interface HistroyTrendsViewController ()
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain, nonatomic) NSDictionary *data;
@property (retain, nonatomic) LoadingView *loadingView;
@end

@implementation HistroyTrendsViewController

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
    self.title = @"历史趋势";
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch:)];
    
    [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];//禁用上下拖拽
    self.webView.delegate = self;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"LineBasic2D" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    UIScrollView *sc = (UIScrollView *)[[self.webView subviews] objectAtIndex:0];
    sc.contentSize = CGSizeMake(self.webView.frame.size.width, self.webView.frame.size.height);
    sc.showsHorizontalScrollIndicator = NO;
    
    NSDictionary *condition = @{@"lineId":[NSNumber numberWithInt:0],@"productId":[NSNumber numberWithInt:0],@"type":[NSNumber numberWithInt:0]};
    [self sendRequest:condition];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.sidePanelController showCenterPanelAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark begin webviewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //    NSString *requestString = [[request URL] absoluteString];
    //    NSArray *components = [requestString componentsSeparatedByString:@":"];
    //    if(([[components objectAtIndex:0] isEqualToString:@"sector"]&&[[components objectAtIndex:1] isEqualToString:@"false"])||([[components objectAtIndex:0] isEqualToString:@"legend"])){
    //        return NO;
    //    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (self.data&&(NSNull *)self.data!=[NSNull null]) {
        int periodUnit = [[self.data objectForKey:@"periodUnit"] intValue];//时间单位，0:天1:月2:年
        NSString *dateFormate;
        switch (periodUnit) {
            case 0:
                dateFormate = @"MM-dd";
                break;
            case 1:
                dateFormate = @"yyyy-MM";
                break;
            case 2:
                dateFormate = @"yyyy";
                break;
        }

        NSArray *unitCosts = [self.data objectForKey:@"unitCost"];
        NSArray *currentUnitCosts = [self.data objectForKey:@"currentUnitCost"];
        NSArray *budgetedUnitCosts = [self.data objectForKey:@"budgetedUnitCost"];
        NSMutableArray *unitCostValues = [[NSMutableArray alloc] init];
        NSMutableArray *currentUnitCostValues = [[NSMutableArray alloc] init];
        NSMutableArray *budgetedUnitCostValues = [[NSMutableArray alloc] init];
        NSMutableArray *timeLabels = [[NSMutableArray alloc] init];
        for (int i=0; i<unitCosts.count; i++) {
            NSDictionary *unitCost = [unitCosts objectAtIndex:i];
            NSDictionary *currentUnitCost = [currentUnitCosts objectAtIndex:i];
            NSDictionary *budgetedUnitCost = [budgetedUnitCosts objectAtIndex:i];
            [unitCostValues addObject:[unitCost objectForKey:@"value"]];
            [currentUnitCostValues addObject:[currentUnitCost objectForKey:@"value"]];
            [budgetedUnitCostValues addObject:[budgetedUnitCost objectForKey:@"value"]];
            long long time = [[unitCost objectForKey:@"time"] longLongValue]/1000;//毫秒
            NSString *timeLabel = [Tool setTimeInt:time setTimeFormat:dateFormate setTimeZome:nil];
            [timeLabels addObject:timeLabel];
        }
        NSMutableArray *maxValueArray = [[NSMutableArray alloc] init];
        [maxValueArray addObjectsFromArray:unitCostValues];
        [maxValueArray addObjectsFromArray:currentUnitCostValues];
        [maxValueArray addObjectsFromArray:budgetedUnitCostValues];
        double max = [Tool getMaxValueInNumberValueArray:maxValueArray];
        double min = [Tool getMinValueInNumberValueArray:maxValueArray];
        
        NSDictionary *unitCostDict = @{@"name":kUnitCostType_UnitCost,@"value":unitCostValues,@"color":[kColorList objectAtIndex:0]};
        NSDictionary *currentCostDict = @{@"name":kUnitCostType_CurrentUnitCost,@"value":currentUnitCostValues,@"color":[kColorList objectAtIndex:1]};
        NSDictionary *budgetedCostDict = @{@"name":kUnitCostType_BudgetedUnitCost,@"value":budgetedUnitCostValues,@"color":[kColorList objectAtIndex:2]};
        NSArray *lineArray = @[unitCostDict,currentCostDict,budgetedCostDict];
        NSDictionary *lineConfigDict = @{@"title":@"2013年9月原材料单位成本趋势",@"height":[NSNumber numberWithFloat:self.webView.frame.size.height],@"start_scale":[NSNumber numberWithDouble:min],@"end_scale":[NSNumber numberWithDouble:max],@"scale_space":[NSNumber numberWithDouble:(max-min)/5]};
        
        NSString *lineData = [Tool objectToString:lineArray];
        NSString *labelData = [Tool objectToString:timeLabels];
        NSString *lineConfigData = [Tool objectToString:lineConfigDict];
        
        NSString *js = [NSString stringWithFormat:@"drawLineBasic2D('%@','%@','%@')",lineData,labelData,lineConfigData];
        DDLogVerbose(@"dates is %@",js);
        [webView stringByEvaluatingJavaScriptFromString:js];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}

- (void)pop:(id)sender {
    RightViewController *rightViewController = (RightViewController *)self.sidePanelController.rightPanel;
    [rightViewController resetConditions:self.oldCondition];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showSearch:(id)sender {
    [self.sidePanelController showRightPanelAnimated:YES];
}

#pragma mark 发送网络请求
-(void) sendRequest:(NSDictionary *)condition{
    self.loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.loadingView];
    [self.loadingView startLoading];
    
    DDLogCInfo(@"******  Request URL is:%@  ******",kMaterialCostHistoryURL);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kMaterialCostHistoryURL]];
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithLongLong:1377964800000] forKey:@"startTime"];
    [self.request setPostValue:[NSNumber numberWithLongLong:1380470400000] forKey:@"endTime"];
    [self.request setPostValue:[NSNumber numberWithLong:[[condition objectForKey:@"lineId"] longValue]] forKey:@"lineId"];
    [self.request setPostValue:[NSNumber numberWithLong:[[condition objectForKey:@"productId"] longValue]] forKey:@"productId"];
    [self.request setPostValue:[NSNumber numberWithInt:0] forKey:@"type"];//0:代表查询直接材料1:代表查询原材料
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(requestFailed:)];
    [self.request setDidFinishSelector:@selector(requestSuccess:)];
    [self.request startAsynchronous];
}

#pragma mark 网络请求
-(void) requestFailed:(ASIHTTPRequest *)request{
    
}

-(void)requestSuccess:(ASIHTTPRequest *)request{
    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
    int responseCode = [[dict objectForKey:@"error"] intValue];
    if (responseCode==0) {
        self.data = [dict objectForKey:@"data"];
        [self.webView reload];
    }else if(responseCode==-1){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }
    [self.loadingView successEndLoading];
}
@end
