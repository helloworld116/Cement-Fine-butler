//
//  RawMaterialCostViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "RawMaterialCostViewController.h"
#import "HMSegmentedControl.h"
#import "ProductViewController.h"

@interface RawMaterialCostViewController ()<UIScrollViewDelegate,MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *lblTextLoss;
@property (strong, nonatomic) IBOutlet UILabel *lblValueLoss;
@property (strong, nonatomic) HMSegmentedControl *segmented;
@property (strong, nonatomic) UIScrollView *scrollViewOfProducts;

@property (strong, nonatomic) TitleView *titleView;
@property (nonatomic,retain) NSString *timeInfo;

@property (strong, nonatomic) NSDictionary *responseData;
@property (strong, nonatomic) NSDictionary *data;
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@end

@implementation RawMaterialCostViewController

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
    // Do any additional setup after loading the view from its nib.
    self.topView.backgroundColor = kRelativelyColor;
    self.lblTextLoss.textColor = kGeneralColor;
    self.lblValueLoss.textColor = [UIColor redColor];
    
    self.titleView = [[TitleView alloc] init];
    self.titleView.lblTitle.text = @"原材料成本损失";
    self.navigationItem.titleView = self.titleView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchCondition:)];
    
//    NSString *responseString = @"{\"error\":0,\"message\":\"\",\"data\":{\"overview\":{\"totalLoss\":3453.76},\"products\":[{\"id\":1,\"name\":\"PC32.5\",\"quotesCosts\":89.45,\"totalLoss\":786.54,\"actualCosts\":87.90,\"standardCosts\":88.56,\"suggestion\":\"您今日生产情况高于行业平均水平，根据最新行情数据建议改进生产配方\"},{\"id\":2,\"name\":\"PC42.5\",\"quotesCosts\":563.45,\"totalLoss\":689.80,\"actualCosts\":56.90,\"standardCosts\":90.56,\"suggestion\":\"您今日生产情况低于行业平均水平，根据最新行情数据建议保持生产配方\"},{\"id\":3,\"name\":\"PC42.5\",\"quotesCosts\":78.89,\"totalLoss\":1899.54,\"actualCosts\":87.96,\"standardCosts\":66.77,\"suggestion\":\"您今日生产情况低于行业平均水平，根据最新行情数据建议改进生产配方\"}]}}";
//    self.responseData = [Tool stringToDictionary:responseString];
//    [self buildViewWithData];
    
    self.segmented = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height, kScreenWidth, 40)];
    [self.segmented setScrollEnabled:YES];
    [self.segmented setBackgroundColor:[UIColor colorWithRed:158/255 green:171/255 blue:30/255 alpha:1]];
    [self.segmented setTextColor:kRelativelyColor];
    [self.segmented setSelectedTextColor:[UIColor blackColor]];
    [self.segmented setSelectionStyle:HMSegmentedControlSelectionStyleBox];
    [self.segmented setSelectionIndicatorHeight:0];
    [self.segmented setSelectionIndicatorColor:kRelativelyColor];
    [self.segmented setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
    [self.segmented addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    self.scrollViewOfProducts = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height+self.segmented.frame.size.height, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-self.topView.frame.size.height-self.segmented.frame.size.height-kTabBarHeight)];
    self.scrollViewOfProducts.pagingEnabled = YES;
    self.scrollViewOfProducts.showsHorizontalScrollIndicator = NO;
    self.scrollViewOfProducts.delegate = self;
    [self.scrollView addSubview:self.scrollViewOfProducts];
    
    NSDictionary *condition = @{@"timeType":@2};
    [self sendRequest:condition];
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

-(void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl{
    self.scrollViewOfProducts.contentOffset = CGPointMake(segmentedControl.selectedSegmentIndex*kScreenWidth, 0);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmented setSelectedSegmentIndex:page animated:YES];
}

#pragma mark 发送网络请求
-(void) sendRequest:(NSDictionary *)condition{
    //清除原数据
    self.scrollView.hidden = YES;
    self.data = nil;
    //加载过程提示
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.labelText = @"加载中...";
    self.progressHUD.labelFont = [UIFont systemFontOfSize:12];
//    self.progressHUD.dimBackground = YES;
    self.progressHUD.opacity=1.0;
    self.progressHUD.delegate = self;
    [self.view addSubview:self.progressHUD];
    [self.progressHUD show:YES];
    
    int timeType = [[condition objectForKey:@"timeType"] intValue];
    NSDictionary *timeInfo = [Tool getTimeInfo:timeType];
    self.timeInfo = [timeInfo objectForKey:@"timeDesc"];
    self.titleView.lblTimeInfo.text = self.timeInfo ;
    NSDate *startTimeDate = [NSDate dateWithTimeIntervalSince1970:[[timeInfo objectForKey:@"startTime"] doubleValue]/1000];
    NSDate *endTimeDate = [NSDate dateWithTimeIntervalSince1970:[[timeInfo objectForKey:@"endTime"] doubleValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startTimeStr = [formatter stringFromDate:startTimeDate];
    NSString *endTimeStr = [formatter stringFromDate:endTimeDate];
    DDLogCInfo(@"******  Request URL is:%@  ******",kRawMaterialLoss);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kRawMaterialLoss]];
    self.request.timeOutSeconds = kASIHttpRequestTimeoutSeconds;
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithInt:kSharedApp.finalFactoryId] forKey:@"factoryId"];
    [self.request setPostValue:startTimeStr forKey:@"startTime"];
    [self.request setPostValue:endTimeStr forKey:@"endTime"];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(requestFailed:)];
    [self.request setDidFinishSelector:@selector(requestSuccess:)];
    [self.request startAsynchronous];
    
//    self.lastRequestCondition = condition;
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
}

-(void)requestSuccess:(ASIHTTPRequest *)request{
    [self.progressHUD hide:YES];
    self.responseData = [Tool stringToDictionary:request.responseString];
    int errorCode = [[self.responseData objectForKey:@"error"] intValue];
    if (errorCode==kErrorCode0) {
        [self buildViewWithData];
    }else if(errorCode==kErrorCodeExpired){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }else{
        self.data = nil;
    }
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[self.progressHUD removeFromSuperview];
	self.progressHUD = nil;
}

-(void)buildViewWithData{
    self.data = [self.responseData objectForKey:@"data"];
    NSArray *products = [self.data objectForKey:@"products"];
    NSUInteger productCount = products.count;
    NSDictionary *overview = [self.data objectForKey:@"overview"];
    double totalLoss = [[overview objectForKey:@"totalLoss"] doubleValue];
    NSString *lblStr = @"";
    if(totalLoss>0){
        lblStr = [lblStr stringByAppendingString:@"总节约"];
    }else{
        lblStr = [lblStr stringByAppendingString:@"总损失"];
        totalLoss = -totalLoss;
    }
    if (totalLoss/100000>1) {
        totalLoss/=10000;
        lblStr = [lblStr stringByAppendingString:@"(万元)："];
    }else{
        lblStr = [lblStr stringByAppendingString:@"(元)："];
    }
    self.lblTextLoss.text = lblStr;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.##"];
    NSString *totalLossStr = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:totalLoss]];
    self.lblValueLoss.text = totalLossStr;
    self.scrollViewOfProducts.contentSize = CGSizeMake(self.scrollViewOfProducts.frame.size.width*productCount, self.scrollViewOfProducts.frame.size.height);
    NSMutableArray *productNames = [NSMutableArray array];
    for (int i=0;i<products.count;i++) {
        NSDictionary *product = products[i];
        NSString *name = [product objectForKey:@"name"];
        [productNames addObject:name];
        ProductViewController *viewController = [[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
        viewController.product = product;
        viewController.view.frame = CGRectMake(i*kScreenWidth, 0, kScreenWidth, self.scrollViewOfProducts.frame.size.height);
        [self.scrollViewOfProducts addSubview:viewController.view];
    }
    self.segmented.sectionTitles = productNames;
    [self.scrollView addSubview:self.segmented];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.scrollView.hidden = NO;
    });
}

- (void)showSearchCondition:(id)sender {
    [self.sidePanelController showRightPanelAnimated:YES];
}

#pragma mark observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"searchCondition"]) {
        SearchCondition *searchCondition = [change objectForKey:@"new"];
        NSDictionary *condition = @{@"timeType":[NSNumber numberWithInt:searchCondition.timeType]};
        if (4==[[condition objectForKey:@"timeType"] intValue]) {
//            self.showRight = YES;
        }
        [self sendRequest:condition];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
