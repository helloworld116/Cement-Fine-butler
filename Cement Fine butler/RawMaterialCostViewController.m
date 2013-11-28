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

@interface RawMaterialCostViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *lblTextLoss;
@property (strong, nonatomic) IBOutlet UILabel *lblValueLoss;
@property (strong, nonatomic) HMSegmentedControl *segmented;
@property (strong, nonatomic) UIScrollView *scrollViewOfProducts;

@property (strong, nonatomic) NSDictionary *responseData;
@property (strong, nonatomic) NSDictionary *data;
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
    NSString *responseString = @"{\"error\":0,\"message\":\"\",\"data\":{\"overview\":{\"totalLoss\":3453.76},\"products\":[{\"id\":1,\"name\":\"PC32.5\",\"quotesCosts\":89.45,\"totalLoss\":786.54,\"actualCosts\":87.90,\"standardCosts\":88.56,\"suggestion\":\"您今日生产情况高于行业平均水平，根据最新行情数据建议改进生产配方\"},{\"id\":2,\"name\":\"PC42.5\",\"quotesCosts\":563.45,\"totalLoss\":689.80,\"actualCosts\":56.90,\"standardCosts\":90.56,\"suggestion\":\"您今日生产情况低于行业平均水平，根据最新行情数据建议保持生产配方\"},{\"id\":3,\"name\":\"PC42.5\",\"quotesCosts\":78.89,\"totalLoss\":1899.54,\"actualCosts\":87.96,\"standardCosts\":66.77,\"suggestion\":\"您今日生产情况低于行业平均水平，根据最新行情数据建议改进生产配方\"}]}}";
    self.responseData = [Tool stringToDictionary:responseString];
    self.data = [self.responseData objectForKey:@"data"];
    
    NSArray *products = [self.data objectForKey:@"products"];
    NSUInteger productCount = products.count;
    
    NSDictionary *overview = [self.data objectForKey:@"overview"];
    double totalLoss = [[overview objectForKey:@"totalLoss"] doubleValue];
    if (totalLoss/100000>1) {
        totalLoss/=10000;
        self.lblTextLoss.text = @"总损失(万元):";
    }else{
        self.lblTextLoss.text = @"总损失(元):";
    }
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.##"];
    NSString *totalLossStr = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:totalLoss]];
    self.lblValueLoss.text = totalLossStr;

    self.segmented = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height, kScreenWidth, 40)];
    self.scrollViewOfProducts = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height+self.segmented.frame.size.height, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-self.topView.frame.size.height-self.segmented.frame.size.height-kTabBarHeight)];
    self.scrollViewOfProducts.contentSize = CGSizeMake(self.scrollViewOfProducts.frame.size.width*productCount, self.scrollViewOfProducts.frame.size.height);
    self.scrollViewOfProducts.pagingEnabled = YES;
    self.scrollViewOfProducts.showsHorizontalScrollIndicator = NO;
    self.scrollViewOfProducts.delegate = self;
    [self.scrollView addSubview:self.scrollViewOfProducts];
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
    self.segmented.selectionIndicatorLocation =HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmented.selectionStyle = HMSegmentedControlSelectionStyleBox;
    [self.segmented addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.segmented];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
