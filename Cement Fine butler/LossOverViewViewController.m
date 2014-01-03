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

@interface LossOverViewViewController ()<UIWebViewDelegate>
@property (retain,nonatomic) UIWebView *webView;
@property (strong, nonatomic) TitleView *titleView;
@property (retain,nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) NSString *timeDesc;
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
    //iOS7设置view
    if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    self.titleView = [[TitleView alloc] init];
    self.titleView.lblTitle.text = @"损耗总览";
    self.navigationItem.titleView = self.titleView;
//    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
//    self.navigationItem.leftBarButtonItem = backBarButtonItem;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch:)];
    UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
    [bt setFrame:CGRectMake(0, 0, 40, 30)];
    [bt setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [bt setImage:[UIImage imageNamed:@"search_click"] forState:UIControlStateHighlighted];
    [bt addTarget:self action:@selector(showSearch:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bt];
    
    //添加webview
    CGRect webViewRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight);
    self.webView = [[UIWebView alloc] initWithFrame:webViewRect];
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor clearColor];
//    self.webView.opaque = NO;
//    self.webView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Chatroom-Bg.png"]];
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
    self.rightVC = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
    self.rightVC.conditions = @[@{kCondition_Time:kCondition_Time_Array}];
    self.rightVC.currentSelectDict = @{kCondition_Time:@2};
    self.URL = kLoss;
    [self sendRequest];
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//////    self.navigationController.navigationBarHidden=YES;
////    if ((kSharedApp.startFactoryId!=kSharedApp.finalFactoryId)&&self.responseData) {
////        self.responseData = nil;
////        //send request
////        NSDictionary *condition = @{@"timeType":[NSNumber numberWithInt:2]};
////        [self sendRequest:condition];
////    }
//    [self.sidePanelController.rightPanel addObserver:self forKeyPath:@"searchCondition" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
//}
//
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *js = [@"rebound(" stringByAppendingFormat:@"%d)",self.currentSelectIndex];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}
//
//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.sidePanelController.rightPanel removeObserver:self forKeyPath:@"searchCondition"];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"searchCondition"]) {
        self.condition = [change objectForKey:@"new"];
        [self sendRequest];
    }
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
        lossReportViewController.dateDesc = self.timeDesc;
        lossReportViewController.title = [kLossType objectAtIndex:index];
        lossReportViewController.data = data;
//        lossReportViewController.hidesBottomBarWhenPushed = YES;
//        [self.navigationController performSelector:@selector(pushViewController:animated:) withObject:@[@"lossReportViewController",[NSNumber numberWithBool:YES]] afterDelay:0.3f];
        lossReportViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lossReportViewController animated:YES];
        return NO;
    }
    return YES;

}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSDictionary *overview = [self.data objectForKey:@"overview"];
    if (overview&&[[overview objectForKey:@"totalLoss"] doubleValue]!=0) {
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
        NSDictionary *configDict = @{@"totalLoss":[NSNumber numberWithDouble:totalLoss],@"unit":@"吨",@"height":[NSNumber numberWithFloat:self.webView.frame.size.height],@"width":[NSNumber numberWithFloat:self.webView.frame.size.width]};
        NSString *js = [NSString stringWithFormat:@"drawDonut2D('%@','%@')",[Tool objectToString:dataArray],[Tool objectToString:configDict]];
        DDLogVerbose(@"dates is %@",js);
        [webView stringByEvaluatingJavaScriptFromString:js];
    }
    self.webView.hidden = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate


#pragma mark NavigationItem按钮事件
-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showSearch:(id)sender{
    [self.sidePanelController showRightPanelAnimated:YES];
}

#pragma mark 自定义公共VC
-(void)responseCode0WithData{
    [self.webView reload];
}

-(void)responseWithOtherCode{
    [super responseWithOtherCode];
}

-(void)setRequestParams{
    NSDictionary *timeInfo = [Tool getTimeInfo:self.condition.timeType];
    self.timeDesc = [timeInfo objectForKey:@"timeDesc"];
    self.titleView.lblTimeInfo.text = [timeInfo objectForKey:@"timeDesc"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"startTime"] longLongValue]] forKey:@"startTime"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"endTime"] longLongValue]] forKey:@"endTime"];
}

-(void)clear{
//    self.scrollView.hidden = YES;
}
@end
