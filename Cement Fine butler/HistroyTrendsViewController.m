//
//  HistroyTrendsViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-21.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "HistroyTrendsViewController.h"

@interface HistroyTrendsViewController ()<MBProgressHUDDelegate>
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain, nonatomic) NSDictionary *data;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (retain, nonatomic) NODataView *noDataView;
@property (retain,nonatomic) NSString *titlePre;
@property (retain,nonatomic) NSDictionary *lastCondition;
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
    self.navigationItem.title = @".......";
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
    
    //unitCostType:0表示直接材料单位成本，1表示原材料单位成本
    NSDictionary *condition = @{@"lineId":[NSNumber numberWithInt:0],@"productId":[NSNumber numberWithInt:0],@"unitCostType":[NSNumber numberWithInt:1],@"timeType":[NSNumber numberWithInt:2]};
    self.lastCondition = condition;
    [self sendRequest:condition];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //观察查询条件修改
    [self.sidePanelController.rightPanel addObserver:self forKeyPath:@"searchCondition" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //移除观察条件
    [self.sidePanelController.rightPanel removeObserver:self forKeyPath:@"searchCondition"];
//    [self.sidePanelController showCenterPanelAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark begin webviewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
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
        if([[self.lastCondition objectForKey:@"unitCostType"] intValue]==0){
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
            NSDictionary *lineConfigDict = @{@"title":self.titlePre,@"height":[NSNumber numberWithFloat:self.webView.frame.size.height],@"start_scale":[NSNumber numberWithDouble:min],@"end_scale":[NSNumber numberWithDouble:max],@"scale_space":[NSNumber numberWithDouble:(max-min)/5]};
            
            NSString *lineData = [Tool objectToString:lineArray];
            NSString *labelData = [Tool objectToString:timeLabels];
            NSString *lineConfigData = [Tool objectToString:lineConfigDict];
            
            NSString *js = [NSString stringWithFormat:@"drawLineBasic2D('%@','%@','%@')",lineData,labelData,lineConfigData];
            DDLogVerbose(@"dates is %@",js);
            [webView stringByEvaluatingJavaScriptFromString:js];
        }else{
            NSArray *materials = [self.data objectForKey:@"materials"];
            NSMutableArray *maxValueArray = [[NSMutableArray alloc] init];
            NSMutableArray *timeLabels = [[NSMutableArray alloc] init];
            NSMutableArray *lineArray = [[NSMutableArray alloc] init];
            for (int i=0; i<materials.count; i++) {
                NSDictionary *material = [materials objectAtIndex:i];
                NSString *name = [material objectForKey:@"name"];
                NSString *color = [kColorList objectAtIndex:i];
                NSMutableArray *valueArray = [[NSMutableArray alloc] init];
                NSArray *dataArray = [material objectForKey:@"history"];
                for (int j=0; j<dataArray.count; j++) {
                    NSDictionary *history = [dataArray objectAtIndex:j];
                    long long time = [[history objectForKey:@"time"] longLongValue]/1000;//毫秒
                    NSString *timeLabel = [Tool setTimeInt:time setTimeFormat:dateFormate setTimeZome:nil];
                    [timeLabels addObject:timeLabel];
                    [valueArray addObject:[history objectForKey:@"value"]];
                }
                [maxValueArray addObjectsFromArray:valueArray];
                NSDictionary *result = @{@"name":name,@"color":color,@"value":valueArray};
                [lineArray addObject:result];
            }
            double max = [Tool getMaxValueInNumberValueArray:maxValueArray];
            double min = [Tool getMinValueInNumberValueArray:maxValueArray];
            NSDictionary *lineConfigDict = @{@"title":self.titlePre,@"height":[NSNumber numberWithFloat:self.webView.frame.size.height],@"start_scale":[NSNumber numberWithDouble:min],@"end_scale":[NSNumber numberWithDouble:max],@"scale_space":[NSNumber numberWithDouble:(max-min)/5]};
            NSString *lineData = [Tool objectToString:lineArray];
            NSString *labelData = [Tool objectToString:timeLabels];
            NSString *lineConfigData = [Tool objectToString:lineConfigDict];
            
            NSString *js = [NSString stringWithFormat:@"drawLineBasic2D('%@','%@','%@')",lineData,labelData,lineConfigData];
            DDLogVerbose(@"dates is %@",js);
            [webView stringByEvaluatingJavaScriptFromString:js];
        }
    }
    self.webView.hidden = NO;
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
    rightViewController.currentSelectDict = self.preSelectedDict;
    [rightViewController resetConditions:self.preViewControllerCondition];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showSearch:(id)sender {
    [self.sidePanelController showRightPanelAnimated:YES];
}

#pragma mark 发送网络请求
-(void) sendRequest:(NSDictionary *)condition{
    //清除原数据
    self.data = nil;
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
    self.progressHUD.delegate = self;
    [self.view addSubview:self.progressHUD];
    [self.progressHUD show:YES];

    DDLogCInfo(@"******  Request URL is:%@  ******",kMaterialCostHistoryURL);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kMaterialCostHistoryURL]];
    [self.request setUseCookiePersistence:YES]; 
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    int factoryId = [[kSharedApp.factory objectForKey:@"id"] intValue];
    [self.request setPostValue:[NSNumber numberWithInt:factoryId] forKey:@"factoryId"];
    int timeType = [[condition objectForKey:@"timeType"] intValue];
    NSDictionary *timeInfo = [Tool getTimeInfo:timeType];
    self.titlePre = [timeInfo objectForKey:@"timeDesc"];
    int unitCostType = [[condition objectForKey:@"unitCostType"] intValue];
    if (unitCostType==0) {
        self.titlePre = [NSString stringWithFormat:@"%@%@",self.titlePre,@"直接材料单位成本历史趋势"];
    }else{
        self.titlePre = [NSString stringWithFormat:@"%@%@",self.titlePre,@"原材料单位成本历史趋势"];
    }
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"startTime"] longLongValue]] forKey:@"startTime"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"endTime"] longLongValue]] forKey:@"endTime"];
    [self.request setPostValue:[NSNumber numberWithLong:[[condition objectForKey:@"lineId"] longValue]] forKey:@"lineId"];
    [self.request setPostValue:[NSNumber numberWithLong:[[condition objectForKey:@"productId"] longValue]] forKey:@"productId"];
    [self.request setPostValue:[NSNumber numberWithInt:unitCostType] forKey:@"type"];//0:代表查询直接材料1:代表查询原材料
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
    int responseCode = [[dict objectForKey:@"error"] intValue];
    if (responseCode==0) {
        self.data = [dict objectForKey:@"data"];
        [self.webView reload];
    }else if(responseCode==-1){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }
    [self.progressHUD hide:YES];
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[self.progressHUD removeFromSuperview];
	self.progressHUD = nil;
}

#pragma mark observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"searchCondition"]) {
        SearchCondition *searchCondition = [change objectForKey:@"new"];
        NSDictionary *condition = @{@"productId":[NSNumber numberWithLong:searchCondition.productID],@"lineId":[NSNumber numberWithLong:searchCondition.lineID],@"timeType":[NSNumber numberWithInt:searchCondition.timeType],@"unitCostType":[NSNumber numberWithInt:searchCondition.unitCostType]};
        [self sendRequest:condition];
        self.lastCondition = condition;
    }
}
@end
