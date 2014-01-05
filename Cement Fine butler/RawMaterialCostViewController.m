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
#import "RawMaterialLeftViewController.h"

#define kSegmentedHeight 40.f

@interface RawMaterialCostViewController ()<UIScrollViewDelegate,MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *lblTextLoss;
@property (strong, nonatomic) IBOutlet UILabel *lblValueLoss;
@property (strong, nonatomic) HMSegmentedControl *segmented;
@property (strong, nonatomic) UIScrollView *scrollViewOfProducts;

@property (strong, nonatomic) TitleView *titleView;
@property (nonatomic,retain) NSString *timeInfo;

//@property (strong, nonatomic) NSDictionary *responseData;
//@property (strong, nonatomic) NSDictionary *data;
//@property (retain, nonatomic) ASIFormDataRequest *request;
//@property (retain,nonatomic) MBProgressHUD *progressHUD;
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
    self.titleView = [[TitleView alloc] initWithArrow:YES];
    self.titleView.lblTitle.text = @"原材料成本";
    [self.titleView.bgBtn addTarget:self.navigationController action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.titleView;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showNav:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] highlightedImage:[UIImage imageNamed:@"search_click"] target:self action:@selector(showSearchCondition:)];
    
    self.topView.backgroundColor = kRelativelyColor;
    self.lblValueLoss.textColor = [UIColor redColor];
    
    self.scrollViewOfProducts = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height+kSegmentedHeight, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-self.topView.frame.size.height-kSegmentedHeight-kTabBarHeight)];
    self.scrollViewOfProducts.bounces = NO;
    self.scrollViewOfProducts.pagingEnabled = YES;
    self.scrollViewOfProducts.showsHorizontalScrollIndicator = NO;
    self.scrollViewOfProducts.delegate = self;
    [self.scrollView addSubview:self.scrollViewOfProducts];
    
    self.rightVC = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
    self.rightVC.conditions = @[@{kCondition_Time:kCondition_Time_Array}];
    self.rightVC.currentSelectDict = @{kCondition_Time:[NSNumber numberWithInt:2]};
//    self.leftVC = [[RawMaterialLeftViewController alloc] init];
//    self.leftVC.conditions = @[@"原材料成本损失",@"原材料成本总览"];
    //获取请求数据
    self.URL = kRawMaterialLoss;
    [self sendRequest];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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


-(void)buildViewWithData{
    NSArray *products = [self.data objectForKey:@"products"];
    NSUInteger productCount = products.count;
    NSDictionary *overview = [self.data objectForKey:@"overview"];
    double totalLoss = [[overview objectForKey:@"totalLoss"] doubleValue];
    NSString *lblStr = @"";
    if(totalLoss>=0){
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
    if (self.segmented) {
        [self.segmented removeFromSuperview];
    }
    self.segmented = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height, kScreenWidth, kSegmentedHeight)];
    self.segmented.selectedSegmentIndex = 0;
    [self.segmented setScrollEnabled:YES];
    [self.segmented setBackgroundColor:kGeneralColor];
    [self.segmented setTextColor:[UIColor darkTextColor]];
    [self.segmented setSelectedTextColor:kRelativelyColor];
    [self.segmented setSelectionStyle:HMSegmentedControlSelectionStyleFullWidthStripe];
    [self.segmented setSelectionIndicatorHeight:3];
    [self.segmented setSelectionIndicatorColor:[UIColor yellowColor]];//kRelativelyColor
    [self.segmented setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
    [self.segmented addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
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

- (void)showNav:(id)sender{
//    NSArray *lines = [kSharedApp.factory objectForKey:@"lines"];
//    NSMutableArray *lineArray = [NSMutableArray arrayWithObject:@{@"name":@"全部",@"_id":[NSNumber numberWithInt:0]}];
//    for (NSDictionary *line in lines) {
//        NSString *name = [line objectForKey:@"name"];
//        NSNumber *_id = [NSNumber numberWithLong:[[line objectForKey:@"id"] longValue]];
//        NSDictionary *dict = @{@"_id":_id,@"name":name};
//        [lineArray addObject:dict];
//    }
//    NSArray *products = [kSharedApp.factory objectForKey:@"products"];
//    NSMutableArray *productArray = [NSMutableArray arrayWithObject:@{@"name":@"全部",@"_id":[NSNumber numberWithInt:0]}];
//    for (NSDictionary *product in products) {
//        NSString *name = [product objectForKey:@"name"];
//        NSNumber *_id = [NSNumber numberWithLong:[[product objectForKey:@"id"] longValue]];
//        NSDictionary *dict = @{@"_id":_id,@"name":name};
//        [productArray addObject:dict];
//    }
//    NSArray *timeArray = kCondition_Time_Array;
//    //原材料成本管理模块
//    JASidePanelController *costManagerController = [[JASidePanelController alloc] init];
//    UINavigationController *rawMaterialsCostManagerNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"rawMaterialsCostManagerNavController"];
//    RightViewController* costManagerRightController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
//    if (kSharedApp.multiGroup) {
//        //集团
//        costManagerRightController.conditions = @[@{@"时间段":kCondition_Time_Array}];
//    }else{
//        //集团下的工厂
//        costManagerRightController.conditions = @[@{@"时间段":timeArray},@{@"产线":lineArray},@{@"产品":productArray}];
//    }
//    costManagerRightController.currentSelectDict = @{kCondition_Time:[NSNumber numberWithInt:2]};
//    [costManagerController setCenterPanel:rawMaterialsCostManagerNavController];
//    [costManagerController setRightPanel:costManagerRightController];
//    
////    rawMaterialsCostManagerNavController.modalPresentationStyle =UIModalPresentationCustom;
////    rawMaterialsCostManagerNavController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self presentModalViewController:costManagerController animated:YES];
////    UINavigationController *datePickerViewController = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"datePickerViewController2"];
////    [self presentModalViewController:datePickerViewController animated:YES];
    
    [self.sidePanelController showLeftPanelAnimated:YES];
}

#pragma mark observe
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"searchCondition"]) {
//        SearchCondition *searchCondition = [change objectForKey:@"new"];
//        self.condition = @{@"timeType":[NSNumber numberWithInt:searchCondition.timeType]};
//        if (4==[[self.condition objectForKey:@"timeType"] intValue]) {
////            self.showRight = YES;
//        }
//        [self sendRequest];
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 自定义公共VC
-(void)responseCode0WithData{
    [self buildViewWithData];
}

-(void)responseWithOtherCode{
    [super responseWithOtherCode];
}

-(void)setRequestParams{
    NSDictionary *timeInfo = [Tool getTimeInfo:self.condition.timeType];
    self.timeInfo = [timeInfo objectForKey:@"timeDesc"];
    self.titleView.lblTimeInfo.text = self.timeInfo ;
    NSDate *startTimeDate = [NSDate dateWithTimeIntervalSince1970:[[timeInfo objectForKey:@"startTime"] doubleValue]/1000];
    NSDate *endTimeDate = [NSDate dateWithTimeIntervalSince1970:[[timeInfo objectForKey:@"endTime"] doubleValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startTimeStr = [formatter stringFromDate:startTimeDate];
    NSString *endTimeStr = [formatter stringFromDate:endTimeDate];
    [self.request setPostValue:startTimeStr forKey:@"startTime"];
    [self.request setPostValue:endTimeStr forKey:@"endTime"];
}
-(void)clear{
    self.scrollView.hidden = YES;
}
@end
