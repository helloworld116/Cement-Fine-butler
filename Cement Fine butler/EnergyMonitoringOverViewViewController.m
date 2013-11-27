//
//  EnergyMonitoringOverViewViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-26.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "EnergyMonitoringOverViewViewController.h"
#import "EnergyMonitoringListViewController.h"

@interface EnergyMonitoringOverViewViewController ()<UIScrollViewDelegate>
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

@property (strong, nonatomic) NSDictionary *responseData;//响应数据
@property (strong, nonatomic) NSDictionary *data;//真正用到的数据
@end

@implementation EnergyMonitoringOverViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSString *testStr = @"{\"error\":0,\"message\":\"\",\"data\":{\"overview\":{\"coalFee\":4567.42,\"coalAmount\":245.67,\"electricityFee\":78878.88,\"electricityAmount\":68766.10},\"products\":[{\"id\":1,\"name\":\"PC32.5\",\"coalFee\":1236.45,\"cocalAmount\":430.60,\"coalUnitAmount\":110.67,\"industryCoalUnitAmount\":109.78,\"electricityFee\":8768.67,\"electricityAmount\":8780.99,\"industryElectricityUnitAmount\":59},{\"id\":2,\"name\":\"PC42.5\",\"coalFee\":1452.89,\"cocalAmount\":686.98,\"coalUnitAmount\":100.88,\"industryCoalUnitAmount\":110.58,\"electricityFee\":4552.56,\"electricityAmount\":4544.67,\"industryElectricityUnitAmount\":89.09},{\"id\":3,\"name\":\"PC42.5\",\"coalFee\":636.45,\"cocalAmount\":569.76,\"coalUnitAmount\":109.87,\"industryCoalUnitAmount\":105.53,\"electricityFee\":4353.67,\"electricityAmount\":989.77,\"industryElectricityUnitAmount\":98.56},{\"id\":4,\"name\":\"PC52.5\",\"coalFee\":675.56,\"cocalAmount\":899.80,\"coalUnitAmount\":176.32,\"industryCoalUnitAmount\":110.50,\"electricityFee\":8456.66,\"electricityAmount\":3534.60,\"industryElectricityUnitAmount\":249.98}]}}";
        self.responseData = [Tool stringToDictionary:testStr];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.view.backgroundColor = [UIColor grayColor];
    self.title = @"能源监控";
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.topView.userInteractionEnabled = YES;
    UITapGestureRecognizer *topTabGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCoalInfo:)];
    [self.topView addGestureRecognizer:topTabGesture];
    self.bottomView.userInteractionEnabled = YES;
    UITapGestureRecognizer *bottomTabGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showElectricityInfo:)];
    [self.bottomView addGestureRecognizer:bottomTabGesture];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height-kNavBarHeight-kTabBarHeight+1);
    NSLog(@"%f",self.scrollView.contentSize.height);

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.##"];
    self.data = [self.responseData objectForKey:@"data"];
    NSDictionary *overview = [self.data objectForKey:@"overview"];
    double coalFee = [[overview objectForKey:@"coalFee"] doubleValue];
    double coalAmount = [[overview objectForKey:@"coalAmount"] doubleValue];
    double electricityFee = [[overview objectForKey:@"electricityFee"] doubleValue];
    double electricityAmount = [[overview objectForKey:@"electricityAmount"] doubleValue];
    
    if (coalFee/10000>1) {
        coalFee/=10000;
        self.lblTextCoalFee.text = @"今日煤费(万元)";
    }else{
        self.lblTextCoalFee.text = @"今日煤费(元)";
    }
    NSString *coalFeeString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalFee]];
    self.lblValueCoalFee.text = coalFeeString;
    
    if (coalAmount/10000>1) {
        coalAmount/=10000;
        self.lblTextCoalAmount.text = @"今日煤耗(万吨)";
    }else{
        self.lblTextCoalAmount.text = @"今日煤耗(吨)";
    }
    NSString *coalAmountString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:coalAmount]];
    self.lblValueCoalAmount.text = coalAmountString;
    
    if (electricityFee/10000>1) {
        electricityFee/=10000;
        self.lblTextElectricityFee.text = @"今日电费(万元)";
    }else{
        self.lblTextElectricityFee.text = @"今日电费(元)";
    }
    NSString *eletricityFeeString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityFee]];
    self.lblValueElectricityFee.text = eletricityFeeString;
    
    if (electricityAmount/10000>1) {
        electricityAmount/=10000;
        self.lblTextElectricityAmount.text = @"今日电耗(万度)";
    }else{
        self.lblTextElectricityAmount.text = @"今日电耗(度)";
    }
    NSString *eletricityAmountString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:electricityAmount]];
    self.lblValueElectricityAmount.text = eletricityAmountString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showCoalInfo:(id)sender{
    if (![Tool isNullOrNil:self.data]) {
        EnergyMonitoringListViewController *nextViewController = [[EnergyMonitoringListViewController alloc] initWithNibName:@"EnergyMonitoringListViewController" bundle:nil];
        nextViewController.hidesBottomBarWhenPushed = YES;
        nextViewController.type = 0;
        nextViewController.data = self.data;
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

-(void)showElectricityInfo:(id)sender{
    if (![Tool isNullOrNil:self.data]) {
        EnergyMonitoringListViewController *nextViewController = [[EnergyMonitoringListViewController alloc] initWithNibName:@"EnergyMonitoringListViewController" bundle:nil];
        nextViewController.hidesBottomBarWhenPushed = YES;
        nextViewController.type = 1;
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
@end
