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
#import "RawMaterialLeftViewController.h"

#define kLabelHeight 30//底部字段描述label高度
#define kLabelOrignX 10//label距离父容器左边距离

@interface RawMaterialsCostManagerViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (retain, nonatomic) TitleView *titleView;
@property (retain, nonatomic) NSString *reportTitlePre;//报表标题前缀，指明时间段

@property (retain, nonatomic) NSDictionary *lastRequestCondition;//最后发送请求的查询条件
@property (nonatomic) BOOL showRight;//条件选择为自定义时间时为YES，其他情况下为NO
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
    //iOS7设置view
    if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    self.titleView = [[TitleView alloc] init];
    self.titleView.lblTitle.text = @"原材料成本管理";
    self.navigationItem.titleView = self.titleView;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showNav:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"..." style:UIBarButtonItemStylePlain target:self action:@selector(moreAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch:)];
    
    self.webView.delegate = self;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Pie2D" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    UIScrollView *sc = (UIScrollView *)[[self.webView subviews] objectAtIndex:0];
    sc.showsHorizontalScrollIndicator = NO;
    sc.showsVerticalScrollIndicator = NO;
    sc.bounces = NO;//禁用上下拖拽
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.rightVC = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
    if (kSharedApp.multiGroup) {
        //集团
        self.rightVC.conditions = @[@{kCondition_Time:kCondition_Time_Array}];
    }else{
        //集团下的工厂
        NSArray *lineArray = [Factory allLines];
        NSArray *productArray = [Factory allProducts];
        self.rightVC.conditions = @[@{kCondition_Time:kCondition_Time_Array},@{kCondition_Lines:lineArray},@{kCondition_Products:productArray}];
    }
    self.rightVC.currentSelectDict = @{kCondition_Time:[NSNumber numberWithInt:2]};
    self.leftVC = [[RawMaterialLeftViewController alloc] init];
    self.leftVC.conditions = @[@"原材料成本损失",@"原材料成本总览"];

    //获取请求数据
    self.URL = kMaterialCostURL;
    [self sendRequest];
}

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    //观察查询条件修改
//    [self.sidePanelController.rightPanel addObserver:self forKeyPath:@"searchCondition" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
//    RightViewController *rightController = (RightViewController *)self.sidePanelController.rightPanel;
//    TimeTableView *timeTableView = rightController.timeTableView;
//    int timeSelectIndex = [timeTableView indexPathForSelectedRow].row;
//    if (timeSelectIndex==4) {
//        timeTableView.currentSelectCellIndex=4;
//        [timeTableView reloadData];
//    }
//}
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
////    if (self.showRight) {
////        [self.sidePanelController showRightPanelAnimated:NO];
////    }
//    //
//    if (kSharedApp.startFactoryId!=kSharedApp.finalFactoryId) {
//        RightViewController *rightViewController = (RightViewController *)self.sidePanelController.rightPanel;
//        for (NSDictionary *factory in kSharedApp.factorys) {
//            if ([[factory objectForKey:@"id"] intValue]==[[kSharedApp.user objectForKey:@"factoryid"] intValue]) {
//                //选中的是集团
//                [rightViewController resetConditions:@[@{@"时间段":kCondition_Time_Array}]];
//            }else{
//                //选中的是集团下的子工厂
//                if (kSharedApp.finalFactoryId==[[factory objectForKey:@"id"] intValue]) {
//                    NSArray *lines = [factory objectForKey:@"lines"];
//                    NSMutableArray *lineArray = [NSMutableArray arrayWithObject:@{@"name":@"全部",@"_id":[NSNumber numberWithInt:0]}];
//                    for (NSDictionary *line in lines) {
//                        NSString *name = [line objectForKey:@"name"];
//                        NSNumber *_id = [NSNumber numberWithLong:[[line objectForKey:@"id"] longValue]];
//                        NSDictionary *dict = @{@"_id":_id,@"name":name};
//                        [lineArray addObject:dict];
//                    }
//                    NSArray *products = [factory objectForKey:@"products"];
//                    NSMutableArray *productArray = [NSMutableArray arrayWithObject:@{@"name":@"全部",@"_id":[NSNumber numberWithInt:0]}];
//                    for (NSDictionary *product in products) {
//                        NSString *name = [product objectForKey:@"name"];
//                        NSNumber *_id = [NSNumber numberWithLong:[[product objectForKey:@"id"] longValue]];
//                        NSDictionary *dict = @{@"_id":_id,@"name":name};
//                        [productArray addObject:dict];
//                    }
//                    NSArray *newCondition = @[@{@"时间段":kCondition_Time_Array},@{@"产线":lineArray},@{@"产品":productArray}];
//                    [rightViewController resetConditions:newCondition];
//                    break;
//                }
//            }
//        }
//    }
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    if (self.sidePanelController.visiblePanel==self.sidePanelController.rightPanel) {
//        self.showRight = YES;
//    }else{
//        self.showRight = NO;
//    }
//}
//
//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    //移除观察条件
//    [self.sidePanelController.rightPanel removeObserver:self forKeyPath:@"searchCondition"];
////    [self.sidePanelController showCenterPanelAnimated:NO];
//    [KxMenu dismissMenu];
//}

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
        if (self.data&&(NSNull *)self.data!=[NSNull null]) {
            NSArray *materials = [self.data objectForKey:@"materials"];
            for (int i=0; i<materials.count; i++) {
                NSDictionary *material = [materials objectAtIndex:i];
                NSString *color = [kColorList objectAtIndex:i];
//                NSString *color = [UIColor randomColorString];
                NSString *name = [NSString stringWithFormat:@"%@ %@元/吨",[material objectForKey:@"name"],[material objectForKey:@"unitCost"]];
                NSString *value = [NSString stringWithFormat:@"%.2f",[[material objectForKey:@"unitCost"] doubleValue]];
//                double value = [[material objectForKey:@"unitCost"] doubleValue];
                NSDictionary *data = @{@"name":name,@"value":value,@"color":color};
                [dataArray addObject:data];
            }
            NSString *pieData = [Tool objectToString:dataArray];
            NSString *title = @"直接材料成本";
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

- (void)showSearch:(id)sender {
    [self.sidePanelController showRightPanelAnimated:YES];
}

- (void)moreAction:(id)sender {
    NSMutableArray *menuItems = [NSMutableArray array];
    if (![Tool isNullOrNil:self.data]) {
        NSArray *recoveryMaterials = [self.data objectForKey:@"recoveryMaterials"];
        if (recoveryMaterials&&recoveryMaterials.count>0) {
            KxMenuItem *menuItem1 = [KxMenuItem menuItem:@"成本还原" image:nil target:self action:@selector(costReduction:)];
            [menuItems addObject:menuItem1];
        }
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
        self.condition = [change objectForKey:@"new"];
        if (4==self.condition.timeType) {
//            self.showRight = YES;
        }
        [self sendRequest];
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
    viewController.timeType = self.condition.timeType;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark 环比
-(void)monthCompareMonth:(id)sender{
    CostComparisonViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"costComparisonViewController"];
    viewController.type=1;
    viewController.timeType = self.condition.timeType;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark 历史趋势
-(void)historyTrends:(id)sender{
    HistroyTrendsViewController *historyTrendsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"historyTrendsViewController"];
    [self.navigationController pushViewController:historyTrendsViewController animated:YES];
}

#pragma mark 自定义公共VC
-(void)responseCode0WithData{
    [self.webView reload];
    [self setBottomViewOfSubView];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.scrollView.hidden = NO;
    });
}

-(void)responseWithOtherCode{
    [super responseWithOtherCode];
}

-(void)setRequestParams{
    NSDictionary *timeInfo = [Tool getTimeInfo:self.condition.timeType];
    self.reportTitlePre = [timeInfo objectForKey:@"timeDesc"];
    self.titleView.lblTimeInfo.text = self.reportTitlePre;
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"startTime"] longLongValue]] forKey:@"startTime"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"endTime"] longLongValue]] forKey:@"endTime"];;
    [self.request setPostValue:[NSNumber numberWithLong:self.condition.lineID] forKey:@"lineId"];
    [self.request setPostValue:[NSNumber numberWithLong:self.condition.productID] forKey:@"productId"];
    [self.request setPostValue:[NSNumber numberWithInt:0] forKey:@"period"];//0:当期   1:上期   2:同期

}
-(void)clear{
    self.scrollView.hidden = YES;
}

@end
