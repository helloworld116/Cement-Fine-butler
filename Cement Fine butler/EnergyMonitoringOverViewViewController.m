//
//  EnergyMonitoringOverViewViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-26.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "EnergyMonitoringOverViewViewController.h"
#import "EnergyMonitoringListViewController.h"

@interface EnergyMonitoringOverViewViewController ()<UIScrollViewDelegate,MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UILabel *lblTextCoalFee;
@property (strong, nonatomic) IBOutlet UILabel *lblValueCoalFee;
@property (strong, nonatomic) IBOutlet UILabel *lblTextCoalAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblValueCoalAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblTextElectricityFee;
@property (strong, nonatomic) IBOutlet UILabel *lblValueElectricityFee;
@property (strong, nonatomic) IBOutlet UILabel *lblTextElectricityAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblValueElectricityAmount;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewCoalFee;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewCoalAmount;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewEleFee;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewEleAmount;

@property (strong, nonatomic) TitleView *titleView;
@property (nonatomic,retain) NSString *timeInfo;
@end

@implementation EnergyMonitoringOverViewViewController

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
    if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
//    self.view.backgroundColor = [UIColor grayColor];
    UIColor *coalColor = [Tool hexStringToColor:@"#f7c839"];
    UIColor *eleColor = [Tool hexStringToColor:@"#52d596"];
    
    self.topView.backgroundColor = kRelativelyColor;
    self.lblTextCoalFee.textColor = coalColor;
    self.lblTextCoalAmount.textColor = coalColor;
    self.lblValueCoalFee.textColor = coalColor;
    self.lblValueCoalAmount.textColor = coalColor;
    self.imgViewCoalFee.image = [UIImage imageNamed:@"coal_fee_icon"];
    self.imgViewCoalAmount.image = [UIImage imageNamed:@"coal_consumption_icon"];
    
    self.bottomView.backgroundColor = kRelativelyColor;
    self.lblTextElectricityFee.textColor = eleColor;
    self.lblTextElectricityAmount.textColor = eleColor;
    self.lblValueElectricityFee.textColor = eleColor;
    self.lblValueElectricityAmount.textColor = eleColor;
    self.imgViewEleFee.image = [UIImage imageNamed:@"electricity_icon"];
    self.imgViewEleAmount.image = [UIImage imageNamed:@"power_consumption_icon"];
    
    self.titleView = [[TitleView alloc] init];
    self.titleView.lblTitle.text = @"能源监控";
    self.navigationItem.titleView = self.titleView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] highlightedImage:[UIImage imageNamed:@"search_click"] target:self action:@selector(showSearchCondition:)];
    
//    CGRect viewFrame = self.view.frame;
//    viewFrame.size.height = kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight;
//    self.view.frame = viewFrame;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.topView.userInteractionEnabled = YES;
    UITapGestureRecognizer *topTabGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCoalInfo:)];
    [self.topView addGestureRecognizer:topTabGesture];
    self.bottomView.userInteractionEnabled = YES;
    UITapGestureRecognizer *bottomTabGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showElectricityInfo:)];
    [self.bottomView addGestureRecognizer:bottomTabGesture];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height-kNavBarHeight-kTabBarHeight+1);
    
    self.messageView = [[PromptMessageView alloc] initWithFrame:CGRectZero];
    CGRect messageViewRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kStatusBarHeight);
    self.messageView.frame = messageViewRect;
    self.messageView.hidden = YES;
    [self.view addSubview:self.messageView];
    
    self.rightVC = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
    self.rightVC.conditions = @[@{kCondition_Time:kCondition_Time_Array}];
    self.rightVC.currentSelectDict = @{kCondition_Time:[NSNumber numberWithInt:2]};
    //获取请求数据
    self.URL = kEnergyMonitoring;
    [self sendRequest];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showCoalInfo:(id)sender{
    [self goNextViewController:0];
}

-(void)showElectricityInfo:(id)sender{
    [self goNextViewController:1];
}

-(void)goNextViewController:(int)type{
    if (![Tool isNullOrNil:self.data]) {
        EnergyMonitoringListViewController *nextViewController = [[EnergyMonitoringListViewController alloc] initWithNibName:@"EnergyMonitoringListViewController" bundle:nil];
        nextViewController.hidesBottomBarWhenPushed = YES;
        nextViewController.type = type;
        nextViewController.timeInfo = self.timeInfo;
        nextViewController.data = self.data;
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

#pragma mark UIScollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    scrollView.contentInset = UIEdgeInsetsMake(1, 0, -1, 0);
//    NSLog(@"height is %f",scrollView.contentSize.height);
}

- (void)showSearchCondition:(id)sender {
    [self.sidePanelController showRightPanelAnimated:YES];
}

//#pragma mark observe
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

-(void)setLabelValue{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.00"];
    NSDictionary *overview = [self.data objectForKey:@"overview"];
    double coalFee = [[overview objectForKey:@"coalFee"] doubleValue];
    double coalLoss = [[overview objectForKey:@"coalLoss"] doubleValue];
    double electricityFee = [[overview objectForKey:@"electricityFee"] doubleValue];
    double electricityLoss = [[overview objectForKey:@"electricityLoss"] doubleValue];
    
    NSString *type;
    if (coalLoss>=0) {
        type=@"损失";
    }else{
        type=@"节约";
        coalLoss=-coalLoss;
    }
    if (coalLoss/100000>1) {
        coalLoss/=10000;
        self.lblTextCoalFee.text = [NSString stringWithFormat:@"煤总%@(万元)",type ];
    }else{
        self.lblTextCoalFee.text = [NSString stringWithFormat:@"煤总%@(元)",type ];
    }
    NSString *coalFeeString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalLoss]];
    self.lblValueCoalFee.text = coalFeeString;
    
    if (coalFee/100000>1) {
        coalFee/=10000;
        self.lblTextCoalAmount.text = @"煤耗(万元)";
    }else{
        self.lblTextCoalAmount.text = @"煤耗(元)";
    }
    NSString *coalAmountString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalFee]];
    self.lblValueCoalAmount.text = coalAmountString;
    
    if (electricityLoss>=0) {
        type=@"损失";
    }else{
        type=@"节约";
        electricityLoss=-electricityLoss;
    }
    if (electricityLoss/100000>1) {
        electricityLoss/=10000;
        self.lblTextElectricityFee.text = [NSString stringWithFormat:@"电总%@(万元)",type];
    }else{
        self.lblTextElectricityFee.text = [NSString stringWithFormat:@"电总%@(万元)",type];
    }
    NSString *eletricityFeeString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityLoss]];
    self.lblValueElectricityFee.text = eletricityFeeString;
    
    if (electricityFee/100000>1) {
        electricityFee/=10000;
        self.lblTextElectricityAmount.text = @"电耗(万元)";
    }else{
        self.lblTextElectricityAmount.text = @"电耗(元)";
    }
    
    NSString *eletricityAmountString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityFee]];
    self.lblValueElectricityAmount.text = eletricityAmountString;
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.scrollView.hidden = NO;
    });
}

#pragma mark 自定义公共VC
-(void)responseCode0WithData{
    [self setLabelValue];
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
