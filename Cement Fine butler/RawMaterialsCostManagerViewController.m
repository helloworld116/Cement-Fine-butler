//
//  RawMaterialsCostManagerViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-17.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "RawMaterialsCostManagerViewController.h"
#import "HistroyTrendsViewController.h"

#define kLabelHeight 30//底部字段描述label高度
#define kLabelOrignX 10//label距离父容器左边距离

@interface RawMaterialsCostManagerViewController ()
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain, nonatomic) NSDictionary *data;
@property (retain, nonatomic) LoadingView *loadingView;

@property (retain, nonatomic) NSString *reportTitlePre;//报表标题前缀，指明时间段
@end

@implementation RawMaterialsCostManagerViewController

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
    //最开始异步请求数据
    NSDictionary *condition = @{@"lineId": [NSNumber numberWithLong:0],@"productId": [NSNumber numberWithLong:0],@"timeType":[NSNumber numberWithInt:2]};
    [self sendRequest:condition];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"原材料成本管理";
    self.webView.delegate = self;
    self.webView.scalesPageToFit = IS_RETINA;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Pie2D" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    UIScrollView *sc = (UIScrollView *)[[self.webView subviews] objectAtIndex:0];
    sc.showsHorizontalScrollIndicator = NO;
    sc.showsVerticalScrollIndicator = NO;
    sc.bounces = NO;//禁用上下拖拽
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self setBottomViewOfSubView];
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
    [self.sidePanelController showCenterPanelAnimated:NO];
    [KxMenu dismissMenu];
}

- (void) setBottomViewOfSubView {
    for (UIView *subView in [self.bottomView subviews]) {
        [subView removeFromSuperview];
    }
    NSDictionary *overView = [self.data objectForKey:@"overView"];
    NSString *totalCost,*unitCost,*currentUnitCost,*budgetedUnitCost,*costHuanbiRate,*costTongbiRate;
    if (overView&&(NSNull *)overView!=[NSNull null]) {
        //成本环比增长率
        if (![Tool isNullOrNil:[overView objectForKey:@"costHuanbiRate"]]) {
            costHuanbiRate = [NSString stringWithFormat:@"%.2f%@",[[overView objectForKey:@"costHuanbiRate"] doubleValue]*100,@"%"];
        }else{
            costHuanbiRate = @"---";
        }
        //成本同比增长率
        if (![Tool isNullOrNil:[overView objectForKey:@"costTongbiRate"]]) {
            costTongbiRate = [NSString stringWithFormat:@"%.2f%@",[[overView objectForKey:@"costTongbiRate"] doubleValue]*100,@"%"];
        }else{
            costTongbiRate = @"---";
        }
        //当前单位成本
        if (![Tool isNullOrNil:[overView objectForKey:@"currentUnitCost"]]) {
            currentUnitCost = [NSString stringWithFormat:@"%.2f",[[overView objectForKey:@"currentUnitCost"] doubleValue]];
        }
        //计划单位成本
        if (![Tool isNullOrNil:[overView objectForKey:@"budgetedUnitCost"]]) {
            budgetedUnitCost = [NSString stringWithFormat:@"%.2f",[[overView objectForKey:@"budgetedUnitCost"] doubleValue]];
        }
        //财务单位成本
        if (![Tool isNullOrNil:[overView objectForKey:@"unitCost"]]) {
            unitCost = [NSString stringWithFormat:@"%.2f",[[overView objectForKey:@"unitCost"] doubleValue]];
        }
        //总成本
        if (![Tool isNullOrNil:[overView objectForKey:@"totalCost"]]) {
            totalCost = [NSString stringWithFormat:@"%.2f",[[overView objectForKey:@"totalCost"] doubleValue]];
        }
        NSString *preStr = @"<font size=20 color='red'>";
        NSString *sufStr = @"</font>";
        
        RTLabel *lblTotalCost = [[RTLabel alloc] initWithFrame:CGRectMake(kLabelOrignX, 0, kScreenWidth-2*kLabelOrignX, kLabelHeight)];
        NSString *strTotalCost = [@"总成本：" stringByAppendingFormat:@"%@%@%@%@",preStr,totalCost,sufStr,@"元"];
        [lblTotalCost setText:strTotalCost];
        [self.bottomView addSubview:lblTotalCost];
        
        RTLabel *lblFinanceUitCost = [[RTLabel alloc] initWithFrame:CGRectMake(kLabelOrignX, kLabelHeight, kScreenWidth-2*kLabelOrignX, kLabelHeight)];
        NSString *strFinanceUnitCost = [@"财务单位成本：" stringByAppendingFormat:@"%@%@%@%@",preStr,unitCost,sufStr,@"元/吨"];
        [lblFinanceUitCost setText:strFinanceUnitCost];
        [self.bottomView addSubview:lblFinanceUitCost];
        
        RTLabel *lblCurrentUitCost = [[RTLabel alloc] initWithFrame:CGRectMake(kLabelOrignX, kLabelHeight*2, kScreenWidth-2*kLabelOrignX, kLabelHeight)];
        NSString *strCurrentUnitCost = [@"当期单位成本：" stringByAppendingFormat:@"%@%@%@%@",preStr,currentUnitCost,sufStr,@"元/吨"];
        [lblCurrentUitCost setText:strCurrentUnitCost];
        [self.bottomView addSubview:lblCurrentUitCost];
        
        RTLabel *lblPlanUitCost = [[RTLabel alloc] initWithFrame:CGRectMake(kLabelOrignX, kLabelHeight*3, kScreenWidth-2*kLabelOrignX, kLabelHeight)];
        NSString *strPlanUnitCost = [@"计划单位成本：" stringByAppendingFormat:@"%@%@%@%@",preStr,budgetedUnitCost,sufStr,@"元/吨"];
        [lblPlanUitCost setText:strPlanUnitCost];
        [self.bottomView addSubview:lblPlanUitCost];
        
        RTLabel *lblTongbi = [[RTLabel alloc] initWithFrame:CGRectMake(kLabelOrignX, kLabelHeight*4, kScreenWidth-2*kLabelOrignX, kLabelHeight)];
        NSString *strTongbi = [@"同比增长：" stringByAppendingFormat:@"%@%@%@",preStr,costTongbiRate,sufStr];
        [lblTongbi setText:strTongbi];
        [self.bottomView addSubview:lblTongbi];
        
        RTLabel *lblHuanbi = [[RTLabel alloc] initWithFrame:CGRectMake(kLabelOrignX, kLabelHeight*5, kScreenWidth-2*kLabelOrignX, kLabelHeight)];
        NSString *strHuanbi = [@"环比增长：" stringByAppendingFormat:@"%@%@%@",preStr,costHuanbiRate,sufStr];
        [lblHuanbi setText:strHuanbi];
        [self.bottomView addSubview:lblHuanbi];
        
        CGFloat bottomViewHeight = self.bottomView.frame.size.height;
        //底部view需要的高度，距离上下都是10
        CGFloat bottomViewNeedHeight = kLabelHeight*self.bottomView.subviews.count;
        //减去10是为了减少在两者差距很小的情况下，避免可拖动
        if (bottomViewHeight<bottomViewNeedHeight) {
            self.scrollView.contentSize = CGSizeMake(kScreenWidth,bottomViewNeedHeight+self.bottomView.frame.origin.y);
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [self setScrollView:nil];
    [self setWebView:nil];
    [self setBottomView:nil];
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
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        double unitCost = [[[self.data objectForKey:@"overView"] objectForKey:@"unitCost"] doubleValue];
        if (self.data&&(NSNull *)self.data!=[NSNull null]) {
            NSArray *materials = [self.data objectForKey:@"materials"];
            for (int i=0; i<materials.count; i++) {
                NSDictionary *material = [materials objectAtIndex:i];
                NSString *color = [kColorList objectAtIndex:i];
                NSString *name = [NSString stringWithFormat:@"%@ %@元/吨",[material objectForKey:@"name"],[material objectForKey:@"unitCost"]];
                NSString *value = [NSString stringWithFormat:@"%.2f",[[material objectForKey:@"unitCost"] doubleValue]/unitCost*100];
                NSDictionary *data = @{@"name":name,@"value":value,@"color":color};
                [dataArray addObject:data];
            }
            NSString *pieData = [Tool objectToString:dataArray];
            NSString *title = [self.reportTitlePre stringByAppendingString:@"直接材料成本"];
            NSDictionary *configDict = @{@"title":title,@"height":[NSNumber numberWithFloat:self.webView.frame.size.height],@"width":[NSNumber numberWithFloat:self.webView.frame.size.width]};
            NSString *js = [NSString stringWithFormat:@"drawPie2D('%@','%@')",pieData,[Tool objectToString:configDict]];
            DDLogVerbose(@"dates is %@",js);
            [webView stringByEvaluatingJavaScriptFromString:js];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate

- (IBAction)showSearch:(id)sender {
    [self.sidePanelController showRightPanelAnimated:YES];
}

- (IBAction)moreAction:(id)sender {
    KxMenuItem *menuItem1 = [KxMenuItem menuItem:@"成本还原" image:nil target:self action:@selector(costReduction:)];
    KxMenuItem *menuItem2 = [KxMenuItem menuItem:@"取消还原" image:nil target:self action:@selector(cancelReduction:)];
    KxMenuItem *menuItem3 = [KxMenuItem menuItem:@"上期" image:nil target:self action:@selector(yearCompareYear:)];
    KxMenuItem *menuItem4 = [KxMenuItem menuItem:@"同期" image:nil target:self action:@selector(monthCompareMonth:)];
    KxMenuItem *menuItem5 = [KxMenuItem menuItem:@"历史趋势" image:nil target:self action:@selector(historyTrends:)];
    NSArray *menuItems = @[menuItem1,menuItem2,menuItem3,menuItem4,menuItem5];
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(10, 0, 30, 0)
                 menuItems:menuItems];
}

#pragma mark observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"searchCondition"]) {
        SearchCondition *searchCondition = [change objectForKey:@"new"];
        NSDictionary *condition = @{@"productId":[NSNumber numberWithLong:searchCondition.productID],@"lineId":[NSNumber numberWithLong:searchCondition.lineID],@"timeType":[NSNumber numberWithInt:searchCondition.timeType]};
        [self sendRequest:condition];
    }
}

#pragma mark 成本还原
-(void)costReduction:(id)sender{

}

#pragma mark 取消还原
-(void)cancelReduction:(id)sender{

}

#pragma mark 同比
-(void)yearCompareYear:(id)sender{

}

#pragma mark 环比
-(void)monthCompareMonth:(id)sender{

}

#pragma mark 历史趋势
-(void)historyTrends:(id)sender{
    NSArray *unitCostArray = @[@{@"_id":[NSNumber numberWithInt:0],@"name":@"直接材料单位成本"},@{@"_id":[NSNumber numberWithInt:1],@"name":@"原材料单位成本"}];
    NSArray *timeArray = kCondition_Time_Array;
    NSArray *lines = [kSharedApp.factory objectForKey:@"lines"];
    NSMutableArray *lineArray = [NSMutableArray arrayWithObject:@{@"name":@"全部",@"_id":[NSNumber numberWithInt:0]}];
    for (NSDictionary *line in lines) {
        NSString *name = [line objectForKey:@"name"];
        NSNumber *_id = [NSNumber numberWithLong:[[line objectForKey:@"id"] longValue]];
        NSDictionary *dict = @{@"_id":_id,@"name":name};
        [lineArray addObject:dict];
    }
    NSArray *products = [kSharedApp.factory objectForKey:@"products"];
    NSMutableArray *productArray = [NSMutableArray arrayWithObject:@{@"name":@"全部",@"_id":[NSNumber numberWithInt:0]}];
    for (NSDictionary *product in products) {
        NSString *name = [product objectForKey:@"name"];
        NSNumber *_id = [NSNumber numberWithLong:[[product objectForKey:@"id"] longValue]];
        NSDictionary *dict = @{@"_id":_id,@"name":name};
        [productArray addObject:dict];
    }
    HistroyTrendsViewController *historyTrendsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"historyTrendsViewController"];
    RightViewController *rightController = (RightViewController *)self.sidePanelController.rightPanel;
    historyTrendsViewController.oldCondition = rightController.conditions;
    NSArray *newConditions = @[@{kCondition_UnitCostType:unitCostArray},@{kCondition_Time:timeArray},@{kCondition_Lines:lineArray},@{kCondition_Products:productArray}];
    [rightController resetConditions:newConditions];
    historyTrendsViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:historyTrendsViewController animated:YES];
}

#pragma mark 发送网络请求
-(void) sendRequest:(NSDictionary *)condition{
    self.loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight)];
    [self.scrollView addSubview:self.loadingView];
    [self.loadingView startLoading];
    
    int timeType = [[condition objectForKey:@"timeType"] intValue];
    NSDictionary *timeInfo = [Tool getTimeInfo:timeType];
    self.reportTitlePre = [timeInfo objectForKey:@"timeDesc"];
    DDLogCInfo(@"******  Request URL is:%@  ******",kMaterialCostURL);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kMaterialCostURL]];
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"startTime"] longLongValue]] forKey:@"startTime"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"endTime"] longLongValue]] forKey:@"endTime"];
    [self.request setPostValue:[NSNumber numberWithLong:[[condition objectForKey:@"lineId"] longValue]] forKey:@"lineId"];
    [self.request setPostValue:[NSNumber numberWithLong:[[condition objectForKey:@"productId"] longValue]] forKey:@"productId"];
    [self.request setPostValue:[NSNumber numberWithInt:0] forKey:@"period"];//0:当期   1:上期   2:同期
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
        [self setBottomViewOfSubView];
    }else if(responseCode==-1){
       LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }
    [self.loadingView successEndLoading];
}

@end
