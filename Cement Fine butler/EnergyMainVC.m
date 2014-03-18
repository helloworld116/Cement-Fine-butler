//
//  EnergyMainVC.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-17.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "EnergyMainVC.h"
#import "EnergyView.h"
#import "DropDownView.h"
#import "ElecPopupVC.h"
#import "CoalPopupVC.h"
#import <HMSegmentedControl.h>
#import "CoalView.h"
#import "ElecView.h"
#import "EnergyDetailVC.h"

@interface EnergyMainVC ()<UIScrollViewDelegate>
@property (nonatomic,strong) IBOutlet UIView *topOfView;
@property (nonatomic,strong) HMSegmentedControl *segmented;

@property (nonatomic,strong) IBOutlet UIScrollView *bottomScrollView;

@property (nonatomic) int type;//0表示煤耗，1表示电耗
@property (nonatomic,strong) CoalView *coalView;
@property (nonatomic,strong) ElecView *elecView;
@property (nonatomic,strong) CoalPopupVC *coalPopupVC;
@property (nonatomic,strong) ElecPopupVC *elecPopupVC;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation EnergyMainVC
static int loadTime=0;

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
    self.navigationItem.title = @"能源监控";
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.delegate = self;
    self.URL = kEnergyMonitoring;
    [self sendRequest];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    [self.request clearDelegatesAndCancel];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (loadTime!=0) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTopView{
    self.segmented = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.topOfView.frame.size.height)];
    [self.segmented setScrollEnabled:YES];
    __weak EnergyMainVC *weakSelf = self;
    [self.segmented setIndexChangeBlock:^(NSInteger index) {
        weakSelf.type = index;
    }];
    [self.segmented setBackgroundColor:[Tool hexStringToColor:@"#f3f3f3"]];
    [self.segmented setTextColor:[Tool hexStringToColor:@"#3f4a58"]];
    [self.segmented setSelectedTextColor:[Tool hexStringToColor:@"#49bbed"]];
    [self.segmented setSelectionStyle:HMSegmentedControlSelectionStyleFullWidthStripe];
    [self.segmented setSelectionIndicatorHeight:2];
    [self.segmented setSelectionIndicatorColor:kGeneralColor];
    [self.segmented setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
    [self.segmented addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    self.segmented.sectionTitles = @[@"煤耗",@"电耗"];
    [self.topOfView addSubview:self.segmented];
}

    
-(void)setupBottomView{
    CGSize scrollViewSize = self.bottomScrollView.frame.size;
    CGFloat contentHeight = kScreenHeight-self.topOfView.frame.size.height-kNavBarHeight-kTabBarHeight-kStatusBarHeight;
    self.bottomScrollView.contentSize = CGSizeMake(scrollViewSize.width*2, contentHeight);
    //煤耗
    if (!self.coalView) {
        self.coalView = [[CoalView alloc] initWithFrame:CGRectMake(0, 0, scrollViewSize.width, scrollViewSize.height) withData:[self.data objectForKey:@"coal"]];
        [self.bottomScrollView addSubview:self.coalView];
    }else{
        if (self.type==0) {
            [self.coalView setupValue:[self.data objectForKey:@"coal"]];
        }
    }
    if (!self.elecView) {
        self.elecView = [[ElecView alloc] initWithFrame:CGRectMake(scrollViewSize.width, 0, scrollViewSize.width, scrollViewSize.height) withData:[self.data objectForKey:@"elec"]];
        [self.bottomScrollView addSubview:self.elecView];
    }else{
        if (self.type==1) {
            [self.elecView setupValue:[self.data objectForKey:@"elec"]];
        }
    }
    self.bottomScrollView.hidden = NO;
}

-(void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl{
    self.bottomScrollView.contentOffset = CGPointMake(segmentedControl.selectedSegmentIndex*kScreenWidth, 0);
}

#pragma mark - UIScrollViewDelegate
    
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmented setSelectedSegmentIndex:page animated:YES];
    self.type = page;
}
    
-(void)showPopupView:(id)sender withIndex:(NSInteger)index{
    if (self.type==0) {
        //煤耗
        if (!self.coalPopupVC) {
            self.coalPopupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CoalPopupVC"];
        }
        self.coalPopupVC.coal = [self.data objectForKey:@"coal"];
        [self presentPopupViewController:self.coalPopupVC animationType:MJPopupViewAnimationFade];
    }else if (self.type==1){
        //电耗
        if (!self.elecPopupVC) {
            self.elecPopupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ElecPopupVC"];
        }
        NSDictionary *elec = [[self.data objectForKey:@"elec"] objectAtIndex:index];
        double customElecUnitAmount = [Tool doubleValue:elec[@"customElecUnitAmount"]];
        self.elecPopupVC.defaultValue = customElecUnitAmount;
        [self presentPopupViewController:self.elecPopupVC animationType:MJPopupViewAnimationFade];
    }
}


#pragma mark 自定义公共VC
-(void)responseCode0WithData{
    if (loadTime==0) {
        [self setupTopView];
    }
    loadTime++;
    [self setupBottomView];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
}

-(void)responseWithOtherCode{
    [super responseWithOtherCode];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
}

-(void)setRequestParams{
    [super setRequestParams];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
}

-(void)clear{
    [self.timer invalidate];
//    self.bottomScrollView.hidden = YES;
}

-(void)showElecDetail:(id)sender{
    EnergyDetailVC *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EnergyDetailVC"];
    nextVC.data = [self.data objectForKey:@"elec"];
    nextVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - timer
-(void)onTimer:(id)sender{
    [self sendRequestWithNoProgress];
}
@end
