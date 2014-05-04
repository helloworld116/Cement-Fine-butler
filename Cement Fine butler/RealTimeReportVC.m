//
//  RealTimeReportVC.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-3-28.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "RealTimeReportVC.h"
#import <HMSegmentedControl.h>
#import "ProductionView.h"
#import "InventoryView.h"

@interface RealTimeReportVC ()<UIScrollViewDelegate>
@property (nonatomic,strong) IBOutlet UIView *topOfView;
@property (nonatomic,strong) HMSegmentedControl *segmented;
@property (nonatomic,strong) IBOutlet UIScrollView *bottomScrollView;
@property (nonatomic,strong) ProductionView *productView;
@property (nonatomic,strong) InventoryView *inventoryView;
@end

@implementation RealTimeReportVC

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
    if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_icon"] highlightedImage:[UIImage imageNamed:@"return_click_icon"] target:self action:@selector(pop:)];
    self.navigationItem.title = @"实时报表";
    
    CGFloat topViewHeight = CGRectGetHeight(self.topOfView.frame);
    CGFloat scrollViewHeight = kScreenHeight-kStatusBarHeight-kNavBarHeight-topViewHeight;
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    self.bottomScrollView.delegate = self;
    self.bottomScrollView.frame = CGRectMake(0, topViewHeight, kScreenWidth, scrollViewHeight);
    self.bottomScrollView.contentSize = CGSizeMake(viewWidth*2, scrollViewHeight);
    self.bottomScrollView.bounces = NO;
    
    //setView
    [self setupTopView];
    [self setupBottomView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.productView) {
        [self.productView cancelRequest];
    }
    if (self.inventoryView) {
        [self.inventoryView cancelRequest];
    }
}

-(void)setupTopView{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topOfView.frame.size.height-1, kScreenWidth, 1)];
    lineView.backgroundColor = [Tool hexStringToColor:@"#c2c2c2"];
    [self.topOfView addSubview:lineView];
    
    self.segmented = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.topOfView.frame.size.height-1)];
    [self.segmented setScrollEnabled:YES];
//    __weak RealTimeReportVC *weakSelf = self;
//    [self.segmented setIndexChangeBlock:^(NSInteger index) {
//        weakSelf.type = index;
//    }];
    [self.segmented setBackgroundColor:[Tool hexStringToColor:@"#f3f3f3"]];
    [self.segmented setTextColor:[Tool hexStringToColor:@"#3f4a58"]];
    [self.segmented setSelectedTextColor:[Tool hexStringToColor:@"#49bbed"]];
    [self.segmented setSelectionStyle:HMSegmentedControlSelectionStyleFullWidthStripe];
    [self.segmented setSelectionIndicatorHeight:2];
    [self.segmented setSelectionIndicatorColor:kGeneralColor];
    [self.segmented setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
    [self.segmented addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    self.segmented.sectionTitles = @[@"产量报表",@"库存报表"];
    [self.topOfView addSubview:self.segmented];
}

-(void)setupBottomView{
    if (CGPointEqualToPoint(self.bottomScrollView.contentOffset, CGPointMake(0, 0))) {
        if (!_productView) {
            _productView = [[ProductionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.bottomScrollView.contentSize.height)];
            [self.bottomScrollView addSubview:_productView];
        }
    }else{
        if (!_inventoryView) {
            _inventoryView = [[InventoryView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, self.bottomScrollView.contentSize.height)];
            [self.bottomScrollView addSubview:_inventoryView];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    self.bottomScrollView.contentOffset = CGPointMake(page*kScreenWidth, 0);
    [self.segmented setSelectedSegmentIndex:page animated:YES];
    [self setupBottomView];
}

-(void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl{
    self.bottomScrollView.contentOffset = CGPointMake(segmentedControl.selectedSegmentIndex*kScreenWidth, 0);
    [self setupBottomView];
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
