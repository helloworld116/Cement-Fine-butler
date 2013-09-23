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
    [self.sidePanelController.rightPanel addObserver:self forKeyPath:@"searchCondition" options:NSKeyValueObservingOptionOld context:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //移除观察条件
    [self.sidePanelController.rightPanel removeObserver:self forKeyPath:@"searchCondition"];
}

- (void) setBottomViewOfSubView {
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
    DDLogCInfo(@"real height is %f and need height is %f and the subview count is %d",bottomViewHeight,bottomViewNeedHeight,self.bottomView.subviews.count);
    //减去10是为了减少在两者差距很小的情况下，避免可拖动
    if (bottomViewHeight<bottomViewNeedHeight-10) {
       self.scrollView.contentSize = CGSizeMake(kScreenWidth,kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight+bottomViewNeedHeight-bottomViewHeight+30);
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
    //    NSString *data = @"[{ids:1,name:\"UC浏览器\",value:40.0,color:\"#4572a7\"},{ids:2,name:\"QQ浏览器\",value:37.1,color:\"#aa4643\"},{ids:3,name:\"欧朋浏览器\",value:13.8,color:\"#89a54e\"},{ids:4,name:\"百度浏览器\",value:1.6,color:\"#80699b\"},{ids:5,name:\"海豚浏览器\",value:1.4,color:\"#92a8cd\"},{ids:6,name:\"天天浏览器\",value:1.2,color:\"#db843d\"},{ids:7,name:\"其他\",value:4.9,color:\"#a47d7c\"}]";
    //    function drawLineChart(todayPrice,dates,advicePrices,realPrices)
    //    NSString *todayPrice = nil;
    //    if (![self.currentProduct objectForKey:@"advicePrice"]) {
    //        todayPrice = [NSString stringWithFormat:@"%.1f",[[self.currentProduct objectForKey:@"advicePrice"] doubleValue]];//今日推荐售价
    //    }
    //    NSArray *prices = [self.currentProduct objectForKey:@"chardata"];
    //    NSMutableString *advicePrice = [NSMutableString string];
    //    NSMutableString *realPrice = [NSMutableString string];
    //    NSMutableString *dates = [NSMutableString string];
    //    NSDictionary *dict = nil;
    //    for (int i=0; i<prices.count; i++) {
    //        dict = [prices objectAtIndex:i];
    //        [advicePrice appendFormat:@"%.1f",[[dict objectForKey:@"advicePrice"] doubleValue]];
    //        [realPrice appendFormat:@"%.1f",[[dict objectForKey:@"price"] doubleValue]];
    //        [dates appendString:[Tool timeIntervalToString:[[dict objectForKey:@"time"] doubleValue] dateformat:kDateFormatDay]];
    //        if (i!=prices.count-1) {
    //            [advicePrice appendString:@","];
    //            [realPrice appendString:@","];
    //            [dates appendString:@","];
    //        }
    //    }
    //
    //    NSString *js = [@"drawLineChart(" stringByAppendingFormat:@"'%@','%@','%@','%@'%@",todayPrice,dates,advicePrice,realPrice,@")"];
    NSString *data = @"[{'name':'熟料','value':56.95,'color':'#a5c2d5'},{'name':'粉煤灰','value':27.05,'color':'#cbab4f'},{'name':'矿渣','value':14.55,'color':'#76a871'},{'name':'石膏','value':1.45,'color':'#9f7961'}]";
    NSString *columnConfig= [NSString stringWithFormat:@"{'title':'2013-09-01至2013-09-30直接材料成本','height':%f,'width':%f}",self.webView.frame.size.height,self.webView.frame.size.width];
    //    NSString *js = [[ stringByAppendingString:data] stringByAppendingFormat:@""];
    NSString *js = [NSString stringWithFormat:@"drawColumn(\"%@\",\"%@\")",data,columnConfig];
    DDLogVerbose(@"dates is %@",js);
    [webView stringByEvaluatingJavaScriptFromString:js];
//    UIScrollView *sc = (UIScrollView *)[[webView subviews] objectAtIndex:0];
//    sc.contentSize = CGSizeMake(webView.frame.size.width, webView.frame.size.height-25);
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

- (void) pushMenuItem:(id)sender
{
    NSLog(@"%@", sender);
}

#pragma mark observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"searchCondition"]) {
        DDLogCVerbose(@"search condtion change");
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
    NSArray *timeArray = @[@"本年",@"本季度",@"本月",@"今天"];
    NSArray *lineArray = @[@"全部",@"1号线",@"2号线"];
    NSArray *productArray = @[@"全部",@"PC32.5",@"PC42.5"];
    rightController.conditions = @[@{@"时间段":timeArray},@{@"产线":lineArray},@{@"产品":productArray}];
    [sidePanelController setRightPanel:rightController];
    sidePanelController.modalPresentationStyle = UIModalPresentationCurrentContext;
//    sidePanelController.modalTransitionStyle = 2;
    [self presentViewController:sidePanelController animated:YES completion:nil];
}
@end
