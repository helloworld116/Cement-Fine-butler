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

@property (strong, nonatomic) TitleView *titleView;
@property (nonatomic,retain) NSString *timeInfo;
@end

@implementation EnergyMonitoringOverViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        NSString *testStr = @"{\"error\":0,\"message\":\"\",\"data\":{\"overview\":{\"coalFee\":4567.42,\"coalAmount\":245.67,\"electricityFee\":78878.88,\"electricityAmount\":78766.10},\"products\":[{\"id\":1,\"name\":\"PC32.5\",\"coalFee\":1236.45,\"coalAmount\":430.60,\"coalUnitAmount\":110.67,\"industryCoalUnitAmount\":109.78,\"electricityFee\":8768.67,\"electricityAmount\":8780.99,\"electricityUnitAmount\":60.99,\"industryElectricityUnitAmount\":59},{\"id\":2,\"name\":\"PC42.5\",\"coalFee\":1452.89,\"coalAmount\":686.98,\"coalUnitAmount\":100.88,\"industryCoalUnitAmount\":110.58,\"electricityFee\":4552.56,\"electricityAmount\":4544.67,\"electricityUnitAmount\":79.10,\"industryElectricityUnitAmount\":89.09},{\"id\":3,\"name\":\"PC42.5\",\"coalFee\":636.45,\"coalAmount\":569.76,\"coalUnitAmount\":109.87,\"industryCoalUnitAmount\":105.53,\"electricityFee\":4353.67,\"electricityAmount\":989.77,\"electricityUnitAmount\":95.45,\"industryElectricityUnitAmount\":98.56},{\"id\":4,\"name\":\"PC52.5\",\"coalFee\":675.56,\"coalAmount\":899.80,\"coalUnitAmount\":176.32,\"industryCoalUnitAmount\":110.50,\"electricityFee\":8456.66,\"electricityAmount\":3534.60,\"electricityUnitAmount\":200.89,\"industryElectricityUnitAmount\":249.98}]}}";
//        self.responseData = [Tool stringToDictionary:testStr];
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
    self.topView.backgroundColor = kGeneralColor;
    self.lblTextCoalFee.textColor = kRelativelyColor;
    self.lblTextCoalAmount.textColor = kRelativelyColor;
    self.lblValueCoalFee.textColor = kRelativelyColor;
    self.lblValueCoalAmount.textColor = kRelativelyColor;
    self.bottomView.backgroundColor = kRelativelyColor;
    self.lblTextElectricityFee.textColor = kGeneralColor;
    self.lblTextElectricityAmount.textColor = kGeneralColor;
    self.lblValueElectricityFee.textColor = kGeneralColor;
    self.lblValueElectricityAmount.textColor = kGeneralColor;
    
    self.titleView = [[TitleView alloc] init];
    self.titleView.lblTitle.text = @"能源监控";
    self.navigationItem.titleView = self.titleView;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchCondition:)];
    UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
    [bt setFrame:CGRectMake(0, 0, 40, 30)];
    [bt setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [bt setImage:[UIImage imageNamed:@"search_click"] forState:UIControlStateHighlighted];
    [bt addTarget:self action:@selector(showSearchCondition:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bt];
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
    [numberFormatter setPositiveFormat:@"###,##0.##"];
    NSDictionary *overview = [self.data objectForKey:@"overview"];
    double coalFee = [[overview objectForKey:@"coalFee"] doubleValue];
    double coalAmount = [[overview objectForKey:@"coalAmount"] doubleValue];
    double electricityFee = [[overview objectForKey:@"electricityFee"] doubleValue];
    double electricityAmount = [[overview objectForKey:@"electricityAmount"] doubleValue];
    
    if (coalFee/100000>1) {
        coalFee/=10000;
        self.lblTextCoalFee.text = @"煤费(万元)";
    }else{
        self.lblTextCoalFee.text = @"煤费(元)";
    }
    NSString *coalFeeString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalFee]];
    self.lblValueCoalFee.text = coalFeeString;
    
    if (coalAmount/100000>1) {
        coalAmount/=10000;
        self.lblTextCoalAmount.text = @"煤耗(万吨)";
    }else{
        self.lblTextCoalAmount.text = @"煤耗(吨)";
    }
    NSString *coalAmountString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalAmount]];
    self.lblValueCoalAmount.text = coalAmountString;
    
    if (electricityFee/100000>1) {
        electricityFee/=10000;
        self.lblTextElectricityFee.text = @"电费(万元)";
    }else{
        self.lblTextElectricityFee.text = @"电费(元)";
    }
    NSString *eletricityFeeString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityFee]];
    self.lblValueElectricityFee.text = eletricityFeeString;
    
    if (electricityAmount/100000>1) {
        electricityAmount/=10000;
        self.lblTextElectricityAmount.text = @"电耗(万度)";
    }else{
        self.lblTextElectricityAmount.text = @"电耗(度)";
    }
    
    NSString *eletricityAmountString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityAmount]];
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
