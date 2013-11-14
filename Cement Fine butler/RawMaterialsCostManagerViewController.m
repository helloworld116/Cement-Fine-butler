//
//  RawMaterialsCostManagerViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-17.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "RawMaterialsCostManagerViewController.h"
#import "HistroyTrendsViewController.h"
#import "CostReductionViewController.h"
#import "CostComparisonViewController.h"
#import "TimeTableView.h"
#import "TimeConditionCell.h"

#define kLabelHeight 30//底部字段描述label高度
#define kLabelOrignX 10//label距离父容器左边距离

@interface RawMaterialsCostManagerViewController ()<MBProgressHUDDelegate>
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain, nonatomic) NSDictionary *data;
//@property (retain, nonatomic) NODataView *noDataView;
@property (retain, nonatomic) PromptMessageView *messageView;
@property (retain, nonatomic) NSString *reportTitlePre;//报表标题前缀，指明时间段

@property (retain, nonatomic) NSDictionary *lastRequestCondition;//最后发送请求的查询条件
@property (nonatomic) BOOL showRight;//条件选择为自定义时间时为YES，其他情况下为NO
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (retain,nonatomic) NSDictionary *currentSelectIndexDict;
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
    self.currentSelectIndexDict = @{kCondition_Time:[NSNumber numberWithInt:2]};
    self.navigationItem.title = @"原材料成本管理";
    
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //观察查询条件修改
    [self.sidePanelController.rightPanel addObserver:self forKeyPath:@"searchCondition" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    RightViewController *rightController = (RightViewController *)self.sidePanelController.rightPanel;
    TimeTableView *timeTableView = rightController.timeTableView;
    int timeSelectIndex = [timeTableView indexPathForSelectedRow].row;
    if (timeSelectIndex==4) {
        timeTableView.currentSelectCellIndex=4;
        [timeTableView reloadData];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (self.showRight) {
//        [self.sidePanelController showRightPanelAnimated:NO];
//    }
    //
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.sidePanelController.visiblePanel==self.sidePanelController.rightPanel) {
        self.showRight = YES;
    }else{
        self.showRight = NO;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //移除观察条件
    [self.sidePanelController.rightPanel removeObserver:self forKeyPath:@"searchCondition"];
//    [self.sidePanelController showCenterPanelAnimated:NO];
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
    self.bottomView.hidden=NO;
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
    self.webView.hidden = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate

- (IBAction)showSearch:(id)sender {
    [self.sidePanelController showRightPanelAnimated:YES];
}

- (IBAction)moreAction:(id)sender {
    NSMutableArray *menuItems = [NSMutableArray array];
    NSArray *recoveryMaterials = [self.data objectForKey:@"recoveryMaterials"];
    if (recoveryMaterials&&recoveryMaterials.count>0) {
        KxMenuItem *menuItem1 = [KxMenuItem menuItem:@"成本还原" image:nil target:self action:@selector(costReduction:)];
        [menuItems addObject:menuItem1];
    }
//    KxMenuItem *menuItem2 = [KxMenuItem menuItem:@"取消还原" image:nil target:self action:@selector(cancelReduction:)];
    KxMenuItem *menuItem3 = [KxMenuItem menuItem:@"同比" image:nil target:self action:@selector(yearCompareYear:)];
    KxMenuItem *menuItem4 = [KxMenuItem menuItem:@"环比" image:nil target:self action:@selector(monthCompareMonth:)];
    KxMenuItem *menuItem5 = [KxMenuItem menuItem:@"历史趋势" image:nil target:self action:@selector(historyTrends:)];
    [menuItems addObject:menuItem3];
    [menuItems addObject:menuItem4];
    [menuItems addObject:menuItem5];
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(10, 0, 30, 0)
                 menuItems:menuItems];
}

#pragma mark observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"searchCondition"]) {
        SearchCondition *searchCondition = [change objectForKey:@"new"];
        NSDictionary *condition = @{@"productId":[NSNumber numberWithLong:searchCondition.productID],@"lineId":[NSNumber numberWithLong:searchCondition.lineID],@"timeType":[NSNumber numberWithInt:searchCondition.timeType]};
        if (4==[[condition objectForKey:@"timeType"] intValue]) {
            self.showRight = YES;
        }
        [self sendRequest:condition];
        RightViewController *rightController = (RightViewController *)self.sidePanelController.rightPanel;
        TimeTableView *timeTableView = rightController.timeTableView;
        int timeSelectIndex=0;
        for (TimeConditionCell *timeCell in [timeTableView visibleCells]) {
            if(!timeCell.selectedImgView.hidden){
                timeSelectIndex = timeCell.cellID;
                break;
            }
        }
        int lineSelectIndex = [rightController.lineTableView indexPathForSelectedRow].row;
        int productSelectIndex = [rightController.productTableView indexPathForSelectedRow].row;
        self.currentSelectIndexDict = @{kCondition_Time:[NSNumber numberWithInt:timeSelectIndex],kCondition_Lines:[NSNumber numberWithInt:lineSelectIndex],kCondition_Products:[NSNumber numberWithInt:productSelectIndex]};
    }
}

#pragma mark 成本还原
-(void)costReduction:(id)sender{
    CostReductionViewController *viewController = [[CostReductionViewController alloc] init];
    viewController.chartTitle = self.reportTitlePre;
    viewController.data = [self.data objectForKey:@"recoveryMaterials"];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark 取消还原
-(void)cancelReduction:(id)sender{

}

#pragma mark 同比
-(void)yearCompareYear:(id)sender{
    CostComparisonViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"costComparisonViewController"];
    viewController.type=2;
    viewController.condition = self.lastRequestCondition;
    viewController.title = @"原材料同比成本";
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark 环比
-(void)monthCompareMonth:(id)sender{
    CostComparisonViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"costComparisonViewController"];
    viewController.type=1;
    viewController.condition = self.lastRequestCondition;
    viewController.title = @"原材料环比成本";
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark 历史趋势
-(void)historyTrends:(id)sender{
    NSArray *unitCostTypeArray = @[@{@"_id":[NSNumber numberWithInt:0],@"name":@"直接材料单位成本"},@{@"_id":[NSNumber numberWithInt:1],@"name":@"原材料单位成本"}];
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
    
//    JASidePanelController *historyController = [[JASidePanelController alloc] init];
    HistroyTrendsViewController *historyTrendsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"historyTrendsViewController"];
//    RightViewController *rightController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
    NSArray *conditions = @[@{kCondition_UnitCostType:unitCostTypeArray},@{kCondition_Time:timeArray},@{kCondition_Lines:lineArray},@{kCondition_Products:productArray}];
//    rightController.conditions = conditions;
//    rightController.currentSelectDict = @{kCondition_Time:[NSNumber numberWithInt:2]};
//    [historyController setCenterPanel:historyTrendsViewController];
//    [historyController setRightPanel:rightController];
//    historyController.hidesBottomBarWhenPushed = YES;
    RightViewController *rightController = self.sidePanelController.rightPanel;
    historyTrendsViewController.preViewControllerCondition = rightController.conditions;
    historyTrendsViewController.preSelectedDict = self.currentSelectIndexDict;
    [rightController resetConditions:conditions];
    [self.navigationController pushViewController:historyTrendsViewController animated:YES];
}

#pragma mark 发送网络请求
-(void) sendRequest:(NSDictionary *)condition{
    //清除原数据
    self.data = nil;
    if (self.messageView) {
        [self.messageView removeFromSuperview];
        self.messageView = nil;
    }
    self.webView.hidden=YES;
    self.bottomView.hidden=YES;
    //加载过程提示
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.scrollView];
    self.progressHUD.labelText = @"加载中...";
    self.progressHUD.labelFont = [UIFont systemFontOfSize:12];
    self.progressHUD.dimBackground = YES;
    self.progressHUD.opacity=1.0;
    self.progressHUD.delegate = self;
    [self.scrollView addSubview:self.progressHUD];
    [self.progressHUD show:YES];
    
    int timeType = [[condition objectForKey:@"timeType"] intValue];
    NSDictionary *timeInfo = [Tool getTimeInfo:timeType];
    self.reportTitlePre = [timeInfo objectForKey:@"timeDesc"];
    DDLogCInfo(@"******  Request URL is:%@  ******",kMaterialCostURL);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kMaterialCostURL]];
//    // 设置持久连接的超时时间为120秒
//    [self.request setPersistentConnectionTimeoutSeconds:120];
    self.request.timeOutSeconds = kASIHttpRequestTimeoutSeconds;
//    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    int factoryId = [[kSharedApp.factory objectForKey:@"id"] intValue];
    [self.request setPostValue:[NSNumber numberWithInt:factoryId] forKey:@"factoryId"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"startTime"] longLongValue]] forKey:@"startTime"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"endTime"] longLongValue]] forKey:@"endTime"];
    long lineId = [[condition objectForKey:@"lineId"] longValue];
    [self.request setPostValue:[NSNumber numberWithLong:lineId] forKey:@"lineId"];
    long productId = [[condition objectForKey:@"productId"] longValue];
    [self.request setPostValue:[NSNumber numberWithLong:productId] forKey:@"productId"];
    [self.request setPostValue:[NSNumber numberWithInt:0] forKey:@"period"];//0:当期   1:上期   2:同期
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(requestFailed:)];
    [self.request setDidFinishSelector:@selector(requestSuccess:)];
    [self.request startAsynchronous];
    
    self.lastRequestCondition = condition;
}

#pragma mark 网络请求
-(void) requestFailed:(ASIHTTPRequest *)request{
    [self.progressHUD hide:YES];
    NSString *message = nil;
    if ([@"The request timed out" isEqualToString:[[request error] localizedDescription]]) {
        message = @"网络请求超时啦。。。";
    }else{
        message = @"网络出错啦。。。";
    }
    self.messageView = [[PromptMessageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight) message:message];
    [self.view performSelector:@selector(addSubview:) withObject:self.messageView afterDelay:0.5];
}

-(void)requestSuccess:(ASIHTTPRequest *)request{
    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
    int errorCode = [[dict objectForKey:@"error"] intValue];
    if (errorCode==kErrorCode0) {
        self.data = [dict objectForKey:@"data"];
        [self.webView reload];
        [self performSelector:@selector(setBottomViewOfSubView) withObject:nil afterDelay:0.5];
    }else if(errorCode==kErrorCodeExpired){
       LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }else{
        self.data = nil;
        [self.webView reload];
        [self setBottomViewOfSubView];
        self.messageView = [[PromptMessageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight)];
        [self.view performSelector:@selector(addSubview:) withObject:self.messageView afterDelay:0.5];
    }
    [self.progressHUD hide:YES];
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[self.progressHUD removeFromSuperview];
	self.progressHUD = nil;
}

@end
