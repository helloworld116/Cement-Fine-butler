//
//  HistroyTrendsViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-21.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "HistroyTrendsViewController.h"

#define kTitle1 @"直接材料单位成本历史趋势"
#define kTitle2 @"原材料单位成本历史趋势"

@interface HistroyTrendsViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) TitleView *titleView;
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
    if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
    self.titleView = [[TitleView alloc] init];
    self.titleView.lblTitle.font = [UIFont boldSystemFontOfSize:15];
    self.titleView.lblTitle.text = kTitle1;
    self.navigationItem.titleView = self.titleView;
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 30)];
    [backBtn setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return_click_icon"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch:)];
    
    [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];//禁用上下拖拽
    self.webView.delegate = self;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"LineBasic2D" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    UIScrollView *sc = (UIScrollView *)[[self.webView subviews] objectAtIndex:0];
    sc.contentSize = CGSizeMake(self.webView.frame.size.width, self.webView.frame.size.height);
    sc.showsHorizontalScrollIndicator = NO;
    
    NSArray *unitCostTypeArray = @[@{@"_id":[NSNumber numberWithInt:0],@"name":@"直接材料单位成本"},@{@"_id":[NSNumber numberWithInt:1],@"name":@"原材料单位成本"}];
    self.rightVC = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
    if (kSharedApp.multiGroup) {
        //集团
        self.rightVC.conditions = @[@{kCondition_UnitCostType:unitCostTypeArray},@{kCondition_Time:kCondition_Time_Array}];
    }else{
        //集团下的工厂
        NSArray *lineArray = [Factory allLines];
        NSArray *productArray = [Factory allProducts];
        self.rightVC.conditions = @[@{kCondition_UnitCostType:unitCostTypeArray},@{kCondition_Time:kCondition_Time_Array},@{kCondition_Lines:lineArray},@{kCondition_Products:productArray}];
    }
    self.rightVC.currentSelectDict = @{kCondition_Time:[NSNumber numberWithInt:2]};
    
    self.URL = kMaterialCostHistoryURL;
    [self sendRequest];
}

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    //观察查询条件修改
//    [self.sidePanelController.rightPanel addObserver:self forKeyPath:@"searchCondition" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
//}
//
//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    //移除观察条件
//    [self.sidePanelController.rightPanel removeObserver:self forKeyPath:@"searchCondition"];
////    [self.sidePanelController showCenterPanelAnimated:NO];
//}

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
    int labelCount = 6;
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
        if(self.condition.unitCostType==0){
            //直接材料单位成本
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
            NSMutableArray *newTimeLabels = [NSMutableArray array];
            if (timeLabels.count>labelCount) {
                if ((timeLabels.count-1)%labelCount==0) {
                    int diff = (timeLabels.count-1)/labelCount;
                    for (int i=0; i<labelCount; i++) {
                        [newTimeLabels addObject:[timeLabels objectAtIndex:i*diff]];
                    }
                }else{
                    int diff = (int)round(timeLabels.count*1.0/labelCount);
                    for (int i=1; i<=labelCount-2; i++) {
                        [newTimeLabels addObject:[timeLabels objectAtIndex:i*diff]];
                    }
                    [newTimeLabels insertObject:[timeLabels objectAtIndex:0] atIndex:0];
                    [newTimeLabels addObject:[timeLabels objectAtIndex:timeLabels.count-1]];
                }
            }else{
                [newTimeLabels addObjectsFromArray:timeLabels];
            }
            NSMutableArray *maxValueArray = [[NSMutableArray alloc] init];
            [maxValueArray addObjectsFromArray:unitCostValues];
            [maxValueArray addObjectsFromArray:currentUnitCostValues];
            [maxValueArray addObjectsFromArray:budgetedUnitCostValues];
            int max = [Tool getMaxValueInNumberValueArray:maxValueArray];
            int min = [Tool getMinValueInNumberValueArray:maxValueArray];
            
            NSDictionary *unitCostDict = @{@"name":kUnitCostType_UnitCost,@"value":unitCostValues,@"color":[kColorList objectAtIndex:0]};
            NSDictionary *currentCostDict = @{@"name":kUnitCostType_CurrentUnitCost,@"value":currentUnitCostValues,@"color":[kColorList objectAtIndex:1]};
            NSDictionary *budgetedCostDict = @{@"name":kUnitCostType_BudgetedUnitCost,@"value":budgetedUnitCostValues,@"color":[kColorList objectAtIndex:2]};
            NSArray *lineArray = @[unitCostDict,currentCostDict,budgetedCostDict];
            NSDictionary *lineConfigDict = @{@"height":[NSNumber numberWithFloat:self.webView.frame.size.height],@"start_scale":[NSNumber numberWithInt:min],@"end_scale":[NSNumber numberWithInt:max],@"scale_space":[NSNumber numberWithInt:(max-min)/5]};
            
            NSString *lineData = [Tool objectToString:lineArray];
            NSString *labelData = [Tool objectToString:newTimeLabels];
            NSString *lineConfigData = [Tool objectToString:lineConfigDict];
            
            NSString *js = [NSString stringWithFormat:@"drawLineBasic2D('%@','%@','%@')",lineData,labelData,lineConfigData];
            DDLogVerbose(@"dates is %@",js);
            [webView stringByEvaluatingJavaScriptFromString:js];
        }else{
            //原材料单位成本
            NSArray *materials = [self.data objectForKey:@"materials"];
            NSMutableArray *maxValueArray = [[NSMutableArray alloc] init];
            NSMutableArray *timeLabels = [[NSMutableArray alloc] init];
            NSMutableArray *lineArray = [[NSMutableArray alloc] init];
            
            NSMutableArray *timeCountArray = [[NSMutableArray alloc] init];
            for (int i=0; i<materials.count; i++) {
                NSDictionary *material = [materials objectAtIndex:i];
                NSString *name = [material objectForKey:@"name"];
                NSString *color = [kColorList objectAtIndex:i];
                NSMutableArray *valueArray = [[NSMutableArray alloc] init];
                NSArray *dataArray = [material objectForKey:@"history"];
                [timeCountArray addObject:[NSNumber numberWithInt:dataArray.count]];
                for (int j=0; j<dataArray.count; j++) {
                    NSDictionary *history = [dataArray objectAtIndex:j];
                    [valueArray addObject:[history objectForKey:@"value"]];
                }
                [maxValueArray addObjectsFromArray:valueArray];
                NSDictionary *result = @{@"name":name,@"color":color,@"value":valueArray};
                [lineArray addObject:result];
            }
            ///////这里是处理返回数据中每条记录个数不一致的情况
            NSMutableArray *timeCountArrayForSort = [NSMutableArray arrayWithArray:timeCountArray];
            NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
            NSArray *sortedNumbers = [timeCountArrayForSort sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            int maxCount = [[sortedNumbers objectAtIndex:0] intValue];
            int maxCountIndex = [timeCountArray indexOfObject:[NSNumber numberWithInt:maxCount]];
            NSArray *historys = [[materials objectAtIndex:maxCountIndex] objectForKey:@"history"];
            for (NSDictionary *history in historys) {
                long long time = [[history objectForKey:@"time"] longLongValue]/1000;//毫秒
                NSString *timeLabel = [Tool setTimeInt:time setTimeFormat:dateFormate setTimeZome:nil];
                [timeLabels addObject:timeLabel];
            }
            ////////
            NSMutableArray *newTimeLabels = [NSMutableArray array];
            if (timeLabels.count>labelCount) {
                if ((timeLabels.count-1)%labelCount==0) {
                    int diff = (timeLabels.count-1)/labelCount;
                    for (int i=0; i<labelCount; i++) {
                        [newTimeLabels addObject:[timeLabels objectAtIndex:i*diff]];
                    }
                }else{
                    int diff = (int)round(timeLabels.count*1.0/labelCount);
                    for (int i=1; i<=labelCount-2; i++) {
                        [newTimeLabels addObject:[timeLabels objectAtIndex:i*diff]];
                    }
                    [newTimeLabels insertObject:[timeLabels objectAtIndex:0] atIndex:0];
                    [newTimeLabels addObject:[timeLabels objectAtIndex:timeLabels.count-1]];
                }
            }else{
                [newTimeLabels addObjectsFromArray:timeLabels];
            }
            int max = [Tool getMaxValueInNumberValueArray:maxValueArray];
            int min = [Tool getMinValueInNumberValueArray:maxValueArray];
            NSDictionary *lineConfigDict = @{@"height":[NSNumber numberWithFloat:self.webView.frame.size.height],@"start_scale":[NSNumber numberWithInt:min],@"end_scale":[NSNumber numberWithInt:max],@"scale_space":[NSNumber numberWithInt:(max-min)/5]};
            NSString *lineData = [Tool objectToString:lineArray];
            NSString *labelData = [Tool objectToString:newTimeLabels];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showSearch:(id)sender {
    [self.sidePanelController showRightPanelAnimated:YES];
}

//#pragma mark 发送网络请求
//-(void) sendRequest:(NSDictionary *)condition{
//    //清除原数据
//    self.data = nil;
//    if (self.messageView) {
//        [self.messageView removeFromSuperview];
//        self.messageView = nil;
//    }
//    self.webView.hidden=YES;
//    //加载过程提示
//    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
//    self.progressHUD.labelText = @"加载中...";
//    self.progressHUD.labelFont = [UIFont systemFontOfSize:12];
//    self.progressHUD.dimBackground = YES;
//    self.progressHUD.opacity=1.0;
//    self.progressHUD.delegate = self;
//    [self.view addSubview:self.progressHUD];
//    [self.progressHUD show:YES];
//
//    DDLogCInfo(@"******  Request URL is:%@  ******",kMaterialCostHistoryURL);
//    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kMaterialCostHistoryURL]];
//    [self.request setUseCookiePersistence:YES]; 
//    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
//    [self.request setPostValue:[NSNumber numberWithInt:kSharedApp.finalFactoryId] forKey:@"factoryId"];
//    int timeType = [[condition objectForKey:@"timeType"] intValue];
//    NSDictionary *timeInfo = [Tool getTimeInfo:timeType];
//    self.titleView.lblTimeInfo.text = [timeInfo objectForKey:@"timeDesc"];
//    int unitCostType = [[condition objectForKey:@"unitCostType"] intValue];
//    if (unitCostType==0) {
//        self.titlePre = @"直接材料单位成本历史趋势";
//    }else{
//        self.titlePre = @"原材料单位成本历史趋势";
//    }
//    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"startTime"] longLongValue]] forKey:@"startTime"];
//    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"endTime"] longLongValue]] forKey:@"endTime"];
//    [self.request setPostValue:[NSNumber numberWithLong:[[condition objectForKey:@"lineId"] longValue]] forKey:@"lineId"];
//    [self.request setPostValue:[NSNumber numberWithLong:[[condition objectForKey:@"productId"] longValue]] forKey:@"productId"];
//    [self.request setPostValue:[NSNumber numberWithInt:unitCostType] forKey:@"type"];//0:代表查询直接材料1:代表查询原材料
//    [self.request setDelegate:self];
//    [self.request setDidFailSelector:@selector(requestFailed:)];
//    [self.request setDidFinishSelector:@selector(requestSuccess:)];
//    [self.request startAsynchronous];
//}
//
//#pragma mark 网络请求
//-(void) requestFailed:(ASIHTTPRequest *)request{
//    NSString *message = nil;
//    if ([@"The request timed out" isEqualToString:[[request error] localizedDescription]]) {
//        message = @"网络请求超时啦。。。";
//    }else{
//        message = @"网络出错啦。。。";
//    }
//    [self.progressHUD hide:YES];
//    self.messageView = [[PromptMessageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight) message:message];
//    [self.view performSelector:@selector(addSubview:) withObject:self.messageView afterDelay:0.5];
//}
//
//-(void)requestSuccess:(ASIHTTPRequest *)request{
//    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
//    int responseCode = [[dict objectForKey:@"error"] intValue];
//    if (responseCode==kErrorCode0) {
//        self.data = [dict objectForKey:@"data"];
//        [self.webView reload];
//    }else if(responseCode==kErrorCodeExpired){
//        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
//        kSharedApp.window.rootViewController = loginViewController;
//    }else{
//        self.messageView = [[PromptMessageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight)];
//        [self.view performSelector:@selector(addSubview:) withObject:self.messageView afterDelay:0.5];
//    }
//    [self.progressHUD hide:YES];
//}
//
//#pragma mark MBProgressHUDDelegate methods
//- (void)hudWasHidden:(MBProgressHUD *)hud {
//	[self.progressHUD removeFromSuperview];
//	self.progressHUD = nil;
//}

#pragma mark observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"searchCondition"]) {
        self.condition = [change objectForKey:@"new"];
        [self sendRequest];
    }
}

#pragma mark 自定义公共VC
-(void)responseCode0WithData{
    [self.webView reload];
//    double delayInSeconds = 0.5;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        self.scrollView.hidden = NO;
//    });
}

-(void)responseWithOtherCode{
    [super responseWithOtherCode];
}

-(void)setRequestParams{
    NSDictionary *timeInfo = [Tool getTimeInfo:self.condition.timeType];
    self.titleView.lblTimeInfo.text = [timeInfo objectForKey:@"timeDesc"];
    if (self.condition.unitCostType==0) {
        self.titleView.lblTitle.text = kTitle1;
    }else{
        self.titleView.lblTitle.text = kTitle2;
    }
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"startTime"] longLongValue]] forKey:@"startTime"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"endTime"] longLongValue]] forKey:@"endTime"];;
    [self.request setPostValue:[NSNumber numberWithLong:self.condition.lineID] forKey:@"lineId"];
    [self.request setPostValue:[NSNumber numberWithLong:self.condition.productID] forKey:@"productId"];
    [self.request setPostValue:[NSNumber numberWithInt:self.condition.unitCostType] forKey:@"type"];//0:代表查询直接材料1:代表查询原材料
    
}
-(void)clear{
    self.webView.hidden = YES;
}
@end
