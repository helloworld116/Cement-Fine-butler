//
//  ProductColumnViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-3.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "ProductColumnViewController.h"
#import "RealTimeReportLeftController.h"
#import "InventoryColumnViewController.h"

@interface ProductColumnViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *topContainerView;
@property (strong, nonatomic) IBOutlet UIWebView *bottomWebiew;

@property (strong, nonatomic) TitleView *titleView;
@property (retain, nonatomic) NSString *reportTitlePre;//报表标题前缀，指明时间段

@property (strong, nonatomic) REMenu *menu;
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
    if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
    self.titleView = [[TitleView alloc] init];
    self.titleView.lblTitle.text = @"产量报表";
    [self.titleView.bgBtn addTarget:self.navigationController action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.titleView;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showNav:)];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchCondition:)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(toggleMenu)];
    [(UIScrollView *)[[self.bottomWebiew subviews] objectAtIndex:0] setBounces:NO];//禁用上下拖拽
    self.bottomWebiew.delegate = self;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Column2D" ofType:@"html"];
    [self.bottomWebiew loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    UIScrollView *sc = (UIScrollView *)[[self.bottomWebiew subviews] objectAtIndex:0];
    sc.contentSize = CGSizeMake(self.bottomWebiew.frame.size.width, self.bottomWebiew.frame.size.height);
    sc.showsHorizontalScrollIndicator = NO;
    
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
//    self.leftVC = [[RealTimeReportLeftController alloc] init];
//    self.leftVC.conditions = @[@"产量报表",@"库存报表"];
    
    //异步请求数据
    self.URL = kOutputReportURL;
    [self sendRequest];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (kSharedApp.startFactoryId!=kSharedApp.finalFactoryId) {
        RightViewController *rightViewController = (RightViewController *)self.sidePanelController.rightPanel;
        for (NSDictionary *factory in kSharedApp.factorys) {
            if ([[factory objectForKey:@"id"] intValue]==[[kSharedApp.user objectForKey:@"factoryid"] intValue]) {
                //选中的是集团
                [rightViewController resetConditions:@[@{kCondition_Time:kCondition_Time_Array}]];
            }else{
                //选中的是集团下的子工厂
                if (kSharedApp.finalFactoryId==[[factory objectForKey:@"id"] intValue]) {
                    NSArray *lineArray = [Factory allLines];
                    NSArray *productArray = [Factory allProducts];
                    NSArray *newCondition = @[@{kCondition_Time:kCondition_Time_Array},@{kCondition_Lines:lineArray},@{kCondition_Products:productArray}];
                    [rightViewController resetConditions:newCondition];
                    break;
                }
            }
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    //观察查询条件修改
//    [self.sidePanelController.rightPanel addObserver:self forKeyPath:@"searchCondition" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
//    RightViewController *rightController = (RightViewController *)self.sidePanelController.rightPanel;
//    TimeTableView *timeTableView = rightController.timeTableView;
//    NSIndexPath *indexPath = [timeTableView indexPathForSelectedRow];
//    if (indexPath.row==4) {
//        timeTableView.currentSelectCellIndex=4;
//        [timeTableView reloadData];
//    }
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

- (void)viewDidUnload {
    [self setTopContainerView:nil];
    [self setBottomWebiew:nil];
    [self setScrollView:nil];
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
            double value = [Tool doubleValue:[product objectForKey:@"output"]];
            NSString *name = [product objectForKey:@"name"];
            NSString *color = [kColorList objectAtIndex:i];
            NSDictionary *reportDict = @{@"name":name,@"value":[NSNumber numberWithDouble:value],@"color":color};
            [products addObject:reportDict];
            [productsForSort addObject:[NSNumber numberWithDouble:value]];
        }
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
        NSArray *sortedNumbers = [productsForSort sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        double max = [[sortedNumbers objectAtIndex:0] doubleValue];
        int newMax = [Tool max:max];
//        NSString *title = [self.reportTitlePre stringByAppendingString:@"产量报表"];
        NSDictionary *configDict = @{@"tagName":@"产量(吨)",@"height":[NSNumber numberWithFloat:self.bottomWebiew.frame.size.height],@"width":[NSNumber numberWithFloat:self.bottomWebiew.frame.size.width],@"start_scale":[NSNumber numberWithInt:0],@"end_scale":[NSNumber numberWithInt:newMax],@"scale_space":[NSNumber numberWithInt:newMax/5]};
        NSString *js = [NSString stringWithFormat:@"drawColumn('%@','%@')",[Tool objectToString:products],[Tool objectToString:configDict]];
        DDLogCVerbose(@"js is %@",js);
        [webView stringByEvaluatingJavaScriptFromString:js];
    }
}
   
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate


//#pragma mark 观察条件变化
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"searchCondition"]) {
//        SearchCondition *searchCondition = [change objectForKey:@"new"];
//        self.condition = @{@"productId":[NSNumber numberWithLong:searchCondition.productID],@"lineId":[NSNumber numberWithLong:searchCondition.lineID],@"timeType":[NSNumber numberWithInt:searchCondition.timeType]};
//        [self sendRequest];
//    }
//}

- (void)showNav:(id)sender {
    [self.sidePanelController showLeftPanelAnimated:YES];
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showSearchCondition:(id)sender {
    [self.sidePanelController showRightPanelAnimated:YES];
}

#pragma mark 自定义公共VC
-(void)responseCode0WithData{
    [self.bottomWebiew reload];
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
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"endTime"] longLongValue]] forKey:@"endTime"];
    [self.request setPostValue:[NSNumber numberWithLong:self.condition.lineID] forKey:@"lineId"];
    [self.request setPostValue:[NSNumber numberWithLong:self.condition.productID] forKey:@"productId"];
}

-(void)clear{
    self.scrollView.hidden = YES;
}
@end
