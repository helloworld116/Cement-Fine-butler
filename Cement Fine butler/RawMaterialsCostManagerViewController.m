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

@interface RawMaterialsCostManagerViewController ()
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain, nonatomic) NSDictionary *data;
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
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationItem.title = @"原材料成本管理";
    //最开始异步请求数据
    NSDictionary *condition = @{@"lineId": [NSNumber numberWithLong:0],@"productId": [NSNumber numberWithLong:0]};
    [self sendRequest:condition];

    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.topItem.title = @"原材料成本管理";
    
    //
    [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];//禁用上下拖拽
    self.webView.delegate = self;
    self.webView.scalesPageToFit = IS_RETINA;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Pie2D" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    UIScrollView *sc = (UIScrollView *)[[self.webView subviews] objectAtIndex:0];
//    sc.contentSize = CGSizeMake(self.webView.frame.size.width, self.webView.frame.size.height);
    sc.showsHorizontalScrollIndicator = NO;
    sc.showsVerticalScrollIndicator = NO;
    //    self.bottomWebiew.frame = CGRectMake(self.bottomWebiew.frame.origin.x, self.bottomWebiew.frame.origin.y, self.bottomWebiew.frame.size.width*2, self.bottomWebiew.frame.size.height);

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
}

- (void) setBottomViewOfSubView {
    for (UIView *subView in [self.bottomView subviews]) {
        [subView removeFromSuperview];
    }
    NSDictionary *overView = [self.data objectForKey:@"overView"];
    if (overView&&(NSNull *)overView!=[NSNull null]) {
        if ([Tool isNullOrNil:[overView objectForKey:@"budgetedUnitCost"]]) {
        }
        if ([Tool isNullOrNil:[overView objectForKey:@"costHuanbiRate"]]) {
        }
        if ([Tool isNullOrNil:[overView objectForKey:@"costTongbiRate"]]) {
        }
        if ([Tool isNullOrNil:[overView objectForKey:@"currentUnitCost"]]) {
        }
        if ([Tool isNullOrNil:[overView objectForKey:@"totalCost"]]) {
        }
        if ([Tool isNullOrNil:[overView objectForKey:@"unitCost"]]) {
        }
        NSString *preStr = @"<font size=20 color='red'>";
        NSString *sufStr = @"</font>";
        
        RTLabel *lblTotalCost = [[RTLabel alloc] initWithFrame:CGRectMake(10, 0, 300, kLabelHeight)];
        NSString *strTotalCost = [@"总成本：" stringByAppendingFormat:@"%@%@%@%@",preStr,@"355640",sufStr,@"元"];
        [lblTotalCost setText:strTotalCost];
        [self.bottomView addSubview:lblTotalCost];
        
        RTLabel *lblFinanceUitCost = [[RTLabel alloc] initWithFrame:CGRectMake(10, kLabelHeight, 300, kLabelHeight)];
        NSString *strFinanceUnitCost = [@"财务单位成本：" stringByAppendingFormat:@"%@%@%@%@",preStr,@"109.32",sufStr,@"元/吨"];
        [lblFinanceUitCost setText:strFinanceUnitCost];
        [self.bottomView addSubview:lblFinanceUitCost];
        
        RTLabel *lblCurrentUitCost = [[RTLabel alloc] initWithFrame:CGRectMake(10, kLabelHeight*2, 300, kLabelHeight)];
        NSString *strCurrentUnitCost = [@"当前单位成本：" stringByAppendingFormat:@"%@%@%@%@",preStr,@"114.93",sufStr,@"元/吨"];
        [lblCurrentUitCost setText:strCurrentUnitCost];
        [self.bottomView addSubview:lblCurrentUitCost];
        
        RTLabel *lblPlanUitCost = [[RTLabel alloc] initWithFrame:CGRectMake(10, kLabelHeight*3, 300, kLabelHeight)];
        NSString *strPlanUnitCost = [@"计划单位成本：" stringByAppendingFormat:@"%@%@%@%@",preStr,@"105.78",sufStr,@"元/吨"];
        [lblPlanUitCost setText:strPlanUnitCost];
        [self.bottomView addSubview:lblPlanUitCost];
        
        RTLabel *lblTongbi = [[RTLabel alloc] initWithFrame:CGRectMake(10, kLabelHeight*4, 300, kLabelHeight)];
        NSString *strTongbi = [@"同比增长：" stringByAppendingFormat:@"%@%@%@",preStr,@"12.45%",sufStr];
        [lblTongbi setText:strTongbi];
        [self.bottomView addSubview:lblTongbi];
        
        RTLabel *lblHuanbi = [[RTLabel alloc] initWithFrame:CGRectMake(10, kLabelHeight*5, 300, kLabelHeight)];
        NSString *strHuanbi = [@"环比增长：" stringByAppendingFormat:@"%@%@%@",preStr,@"19.87%",sufStr];
        [lblHuanbi setText:strHuanbi];
        [self.bottomView addSubview:lblHuanbi];
        
        //底部view实际高度
        CGFloat bottomViewHeight = kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight-self.bottomView.frame.origin.y;
        //底部view需要的高度，距离上下都是10
        CGFloat bottomViewNeedHeight = kLabelHeight*self.bottomView.subviews.count + 10*2;
        //减去10是为了减少在两者差距很小的情况下，避免可拖动
        if (bottomViewHeight<bottomViewNeedHeight-10) {
            self.scrollView.contentSize = CGSizeMake(kScreenWidth,kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight+bottomViewNeedHeight-bottomViewHeight+30);
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
//    NSString *data = @"[{'name':'熟料','value':56.95,'color':'#a5c2d5'},{'name':'粉煤灰','value':27.05,'color':'#cbab4f'},{'name':'矿渣','value':14.55,'color':'#76a871'},{'name':'石膏','value':1.45,'color':'#9f7961'}]";
//    NSString *columnConfig= [NSString stringWithFormat:@"{'title':'2013-09-01至2013-09-30直接材料成本','height':%f,'width':%f}",self.webView.frame.size.height,self.webView.frame.size.width];
//    NSString *js = [NSString stringWithFormat:@"drawColumn(\"%@\",\"%@\")",data,columnConfig];
//    DDLogVerbose(@"dates is %@",js);
//    [webView stringByEvaluatingJavaScriptFromString:js];
    
    if (self.data&&(NSNull *)self.data!=[NSNull null]) {
        
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate

- (IBAction)showSearch:(id)sender {
    [self.sidePanelController showRightPanelAnimated:YES];
}

- (IBAction)moreAction:(id)sender {
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"成本还原"
                     image:nil
                    target:self
                    action:@selector(costReduction:)],
      
      [KxMenuItem menuItem:@"取消还原"
                     image:nil
                    target:self
                    action:@selector(cancelReduction:)],
      
      [KxMenuItem menuItem:@"上期"
                     image:nil
                    target:self
                    action:@selector(yearCompareYear:)],
      
      [KxMenuItem menuItem:@"同期"
                     image:nil
                    target:self
                    action:@selector(monthCompareMonth:)],
      
      [KxMenuItem menuItem:@"历史趋势"
                     image:nil
                    target:self
                    action:@selector(historyTrends:)],
      ];
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(10, 5, 30, 40)
                 menuItems:menuItems];
}

#pragma mark observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"searchCondition"]) {
        SearchCondition *condition = [change objectForKey:@"new"];
        DDLogCVerbose(@"line is %ld",condition.productID);
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
    JASidePanelController *sidePanelController = [[JASidePanelController alloc] init];
    HistroyTrendsViewController *historyTrendsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"historyTrendsViewController"];
    [sidePanelController setCenterPanel:historyTrendsViewController];
    RightViewController* rightController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
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
    rightController.conditions = @[@{kCondition_UnitCostType:unitCostArray},@{kCondition_Time:timeArray},@{kCondition_Lines:lineArray},@{kCondition_Products:productArray}];
    [sidePanelController setRightPanel:rightController];
    sidePanelController.modalPresentationStyle = UIModalPresentationCurrentContext;
//    sidePanelController.modalTransitionStyle = 2;
    [self presentViewController:sidePanelController animated:YES completion:nil];
//    NSArray *stockType = @[@{@"_id":[NSNumber numberWithInt:0],@"name":@"原材料库存"},@{@"_id":[NSNumber numberWithInt:1],@"name":@"成品库存"}];
//    @[@{@"库存类型":stockType},@{@"时间段":timeArray},@{@"产线":lineArray},@{@"产品":productArray}];
}

#pragma mark 发送网络请求
-(void) sendRequest:(NSDictionary *)condition{
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kMaterialCostURL]];
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithLongLong:1377964800000] forKey:@"startTime"];
    [self.request setPostValue:[NSNumber numberWithLongLong:1380470400000] forKey:@"endTime"];
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
    if ([[dict objectForKey:@"error"] intValue]==0) {
        self.data = [dict objectForKey:@"data"];
        [self.webView reload];
        [self setBottomViewOfSubView];
    }else{
        
    }
}

@end
