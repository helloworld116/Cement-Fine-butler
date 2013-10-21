//
//  CostComparisonViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-19.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "CostComparisonViewController.h"
#define kLabelHeight 30//底部字段描述label高度
#define kLabelOrignX 10//label距离父容器左边距离


@interface CostComparisonViewController ()
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain, nonatomic) NSDictionary *data;
@property (retain, nonatomic) NODataView *noDataView;
@property (retain, nonatomic) NSString *reportTitlePre;//报表标题前缀，指明时间段
@end

@implementation CostComparisonViewController

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
    //最开始异步请求数据
//    NSDictionary *condition = @{@"lineId": [NSNumber numberWithLong:0],@"productId": [NSNumber numberWithLong:0],@"timeType":[NSNumber numberWithInt:2]};
    [self sendRequest:self.condition];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    self.webView.delegate = self;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Pie2D" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    UIScrollView *sc = (UIScrollView *)[[self.webView subviews] objectAtIndex:0];
    sc.showsHorizontalScrollIndicator = NO;
    sc.showsVerticalScrollIndicator = NO;
    sc.bounces = NO;//禁用上下拖拽
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark 发送网络请求
-(void) sendRequest:(NSDictionary *)condition{
    if (self.noDataView) {
        [self.noDataView removeFromSuperview];
        self.noDataView = nil;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    int timeType = [[condition objectForKey:@"timeType"] intValue];
    NSDictionary *timeInfo = [Tool getTimeInfo:timeType];
    self.reportTitlePre = [timeInfo objectForKey:@"timeDesc"];
    DDLogCInfo(@"******  Request URL is:%@  ******",kMaterialCostURL);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kMaterialCostURL]];
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    int factoryId = [[kSharedApp.factory objectForKey:@"id"] intValue];
    [self.request setPostValue:[NSNumber numberWithInt:factoryId] forKey:@"factoryId"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"startTime"] longLongValue]] forKey:@"startTime"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"endTime"] longLongValue]] forKey:@"endTime"];
    [self.request setPostValue:[NSNumber numberWithLong:[[condition objectForKey:@"lineId"] longValue]] forKey:@"lineId"];
    [self.request setPostValue:[NSNumber numberWithLong:[[condition objectForKey:@"productId"] longValue]] forKey:@"productId"];
    [self.request setPostValue:[NSNumber numberWithInt:self.type] forKey:@"period"];//0:当期   1:上期   2:同期
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(requestFailed:)];
    [self.request setDidFinishSelector:@selector(requestSuccess:)];
    [self.request startAsynchronous];
}

#pragma mark 网络请求
-(void) requestFailed:(ASIHTTPRequest *)request{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)requestSuccess:(ASIHTTPRequest *)request{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //    [self.loadingView removeFromSuperView];
    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
    int errorCode = [[dict objectForKey:@"error"] intValue];
    if (errorCode==0) {
        self.data = [dict objectForKey:@"data"];
        [self.webView reload];
        [self setBottomViewOfSubView];
    }else if(errorCode==kErrorCodeNegative1){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }else{
        self.data = nil;
        [self.webView reload];
        [self setBottomViewOfSubView];
        self.noDataView = [[NODataView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight)];
        [self.view performSelector:@selector(addSubview:) withObject:self.noDataView afterDelay:0.5];
    }
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

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setWebView:nil];
    [self setBottomView:nil];
    [super viewDidUnload];
}
@end
