//
//  ProductColumnViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-3.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "ProductColumnViewController.h"

@interface ProductColumnViewController ()<MBProgressHUDDelegate>
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain, nonatomic) NSDictionary *data;

@property (retain, nonatomic) PromptMessageView *messageView;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (retain, nonatomic) NSString *reportTitlePre;//报表标题前缀，指明时间段
@end

@implementation ProductColumnViewController

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
    //设置navigationBar相关
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.topItem.title = @"产量报表";
    
    [(UIScrollView *)[[self.bottomWebiew subviews] objectAtIndex:0] setBounces:NO];//禁用上下拖拽
    self.bottomWebiew.delegate = self;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Column2D" ofType:@"html"];
    [self.bottomWebiew loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    UIScrollView *sc = (UIScrollView *)[[self.bottomWebiew subviews] objectAtIndex:0];
    sc.contentSize = CGSizeMake(self.bottomWebiew.frame.size.width, self.bottomWebiew.frame.size.height);
    sc.showsHorizontalScrollIndicator = NO;
    //设置没有数据或发生错误时的view
    self.messageView = [[PromptMessageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight)];
    [self.view addSubview:self.messageView];
    self.messageView.hidden = YES;
    //异步请求数据
    NSDictionary *condition = @{@"lineId": [NSNumber numberWithLong:0],@"productId": [NSNumber numberWithLong:0],@"timeType":[NSNumber numberWithInt:2]};
    [self sendRequest:condition];//默认查询原材料库存
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (kSharedApp.startFactoryId!=kSharedApp.finalFactoryId) {
        RightViewController *rightViewController = (RightViewController *)self.sidePanelController.rightPanel;
        for (NSDictionary *factory in kSharedApp.factorys) {
            if ([[factory objectForKey:@"id"] intValue]==[[kSharedApp.user objectForKey:@"factoryid"] intValue]) {
                //选中的是集团
                [rightViewController resetConditions:@[@{@"时间段":kCondition_Time_Array}]];
            }else{
                //选中的是集团下的子工厂
                if (kSharedApp.finalFactoryId==[[factory objectForKey:@"id"] intValue]) {
                    NSArray *lines = [factory objectForKey:@"lines"];
                    NSMutableArray *lineArray = [NSMutableArray arrayWithObject:@{@"name":@"全部",@"_id":[NSNumber numberWithInt:0]}];
                    for (NSDictionary *line in lines) {
                        NSString *name = [line objectForKey:@"name"];
                        NSNumber *_id = [NSNumber numberWithLong:[[line objectForKey:@"id"] longValue]];
                        NSDictionary *dict = @{@"_id":_id,@"name":name};
                        [lineArray addObject:dict];
                    }
                    NSArray *products = [factory objectForKey:@"products"];
                    NSMutableArray *productArray = [NSMutableArray arrayWithObject:@{@"name":@"全部",@"_id":[NSNumber numberWithInt:0]}];
                    for (NSDictionary *product in products) {
                        NSString *name = [product objectForKey:@"name"];
                        NSNumber *_id = [NSNumber numberWithLong:[[product objectForKey:@"id"] longValue]];
                        NSDictionary *dict = @{@"_id":_id,@"name":name};
                        [productArray addObject:dict];
                    }
                    NSArray *newCondition = @[@{@"时间段":kCondition_Time_Array},@{@"产线":lineArray},@{@"产品":productArray}];
                    [rightViewController resetConditions:newCondition];
                    break;
                }
            }
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //观察查询条件修改
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
    //移除观察条件
    [self.sidePanelController.rightPanel removeObserver:self forKeyPath:@"searchCondition"];
//    [self.sidePanelController showCenterPanelAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTopContainerView:nil];
    [self setBottomWebiew:nil];
    [self setScrollView:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
}

#pragma mark begin webviewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (self.data&&(NSNull *)self.data!=[NSNull null]) {
        NSArray *productArray = [self.data objectForKey:@"products"];
        NSMutableArray *productsForSort = [NSMutableArray array];
        NSMutableArray *products = [NSMutableArray array];
        for (int i=0;i<productArray.count;i++) {
            NSDictionary *product = [productArray objectAtIndex:i];
            double value = [[product objectForKey:@"output"] doubleValue];
            NSString *name = [product objectForKey:@"name"];
            NSString *color = [kColorList objectAtIndex:i];
            NSDictionary *reportDict = @{@"name":name,@"value":[NSNumber numberWithDouble:value],@"color":color};
            [products addObject:reportDict];
            [productsForSort addObject:[NSNumber numberWithDouble:value]];
        }
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
        NSArray *sortedNumbers = [productsForSort sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        double max = [[sortedNumbers objectAtIndex:0] doubleValue];
        max = [Tool max:max];
        NSString *title = [self.reportTitlePre stringByAppendingString:@"产量报表"];
        NSDictionary *configDict = @{@"title":title,@"tagName":@"产量(吨)",@"height":[NSNumber numberWithFloat:self.bottomWebiew.frame.size.height],@"width":[NSNumber numberWithFloat:self.bottomWebiew.frame.size.width],@"start_scale":[NSNumber numberWithFloat:0],@"end_scale":[NSNumber numberWithFloat:max],@"scale_space":[NSNumber numberWithFloat:max/5]};
        NSString *js = [NSString stringWithFormat:@"drawColumn('%@','%@')",[Tool objectToString:products],[Tool objectToString:configDict]];
        DDLogCVerbose(@"js is %@",js);
        [webView stringByEvaluatingJavaScriptFromString:js];
        self.bottomWebiew.hidden = NO;
    }else if([Tool isNullOrNil:self.data]){
        //没有满足条件的数据
        self.messageView.hidden = NO;
        self.messageView.labelMsg.text=@"没有满足条件的数据";
    }
}
   
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate

#pragma mark 发送网络请求
-(void) sendRequest:(NSDictionary *)condition{
    //清除原数据
    self.data = nil;
    self.bottomWebiew.hidden=YES;
    self.messageView.hidden=YES;
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
    DDLogCInfo(@"******  Request URL is:%@  ******",kOutputReportURL);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kOutputReportURL]];
    self.request.timeOutSeconds = kASIHttpRequestTimeoutSeconds;
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithInt:kSharedApp.finalFactoryId] forKey:@"factoryId"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"startTime"] longLongValue]] forKey:@"startTime"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"endTime"] longLongValue]] forKey:@"endTime"];
    [self.request setPostValue:[NSNumber numberWithLong:[[condition objectForKey:@"lineId"] longValue]] forKey:@"lineId"];
    [self.request setPostValue:[NSNumber numberWithLong:[[condition objectForKey:@"productId"] longValue]] forKey:@"productId"];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(requestFailed:)];
    [self.request setDidFinishSelector:@selector(requestSuccess:)];
    [self.request startAsynchronous];
}

#pragma mark 网络请求
-(void) requestFailed:(ASIHTTPRequest *)request{
    [self.progressHUD hide:YES];
    self.messageView.hidden = NO;
    self.messageView.labelMsg.text=@"请求出错了。。。";
}

-(void)requestSuccess:(ASIHTTPRequest *)request{    
    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
    int responseCode = [[dict objectForKey:@"error"] intValue];
    if (responseCode==0) {
        self.data = [dict objectForKey:@"data"];
        [self.bottomWebiew reload];
    }else if(responseCode==kErrorCodeExpired){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }else{
        self.messageView.hidden = NO;
        self.messageView.labelMsg.text=@"未知错误。。。";
    }
    [self.progressHUD hide:YES];
}

#pragma mark 观察条件变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"searchCondition"]) {
        SearchCondition *searchCondition = [change objectForKey:@"new"];
        NSDictionary *condition = @{@"productId":[NSNumber numberWithLong:searchCondition.productID],@"lineId":[NSNumber numberWithLong:searchCondition.lineID],@"timeType":[NSNumber numberWithInt:searchCondition.timeType]};
        [self sendRequest:condition];
    }
}

- (IBAction)showNav:(id)sender {
    [self.sidePanelController showLeftPanelAnimated:YES];
}

- (IBAction)showSearchCondition:(id)sender {
    [self.sidePanelController showRightPanelAnimated:YES];
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[self.progressHUD removeFromSuperview];
	self.progressHUD = nil;
}
@end
