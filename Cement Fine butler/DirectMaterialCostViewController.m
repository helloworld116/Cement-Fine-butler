//
//  DirectMaterialCostViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-13.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "DirectMaterialCostViewController.h"
#import "DropDownView.h"
#import "ProductDirectMaterialCosts.h"
#import "CostPopupVC.h"
#import "CostDetailVC.h"

@interface DirectMaterialCostViewController ()<DropDownViewDeletegate,UIScrollViewDelegate>
//顶部控件
@property (nonatomic,strong) IBOutlet UIView *topOfView;//头部容器
@property (nonatomic,strong) DropDownView *dropDownView;
@property (nonatomic,strong) IBOutlet UIImageView *imgViewTime;//指示时间可以下拉的箭头
@property (nonatomic,strong) IBOutlet UIImageView *imgViewStatus;
@property (nonatomic,strong) IBOutlet UILabel *lblStatus;//指示节约或损失
@property (nonatomic,strong) IBOutlet UILabel *lblValue;//节约或损失的数值

@property (nonatomic,strong) IBOutlet UILabel *lblDetail;
@property (nonatomic,strong) IBOutlet UIImageView *imgViewDetail;

//中间部分控件
@property (nonatomic,strong) IBOutlet UIView *middleView;
@property (nonatomic,strong) PPiFlatSegmentedControl *segmented;

//底部控件
@property (nonatomic,strong) IBOutlet UIScrollView *bottomScorllView;


-(IBAction)changeDate:(id)sender;
-(IBAction)showDetail:(id)sender;

@end

@implementation DirectMaterialCostViewController

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
    self.navigationItem.title = @"直接材料成本";
    self.bottomScorllView.pagingEnabled = YES;
    self.bottomScorllView.showsHorizontalScrollIndicator = NO;
    self.bottomScorllView.bounces = NO;
    self.bottomScorllView.delegate = self;
    
    self.URL = kRawMaterialLoss;
    [self sendRequest];
}
    
-(void)setupTopView{
    double totalLoss = [[[self.data objectForKey:@"overview"] objectForKey:@"totalLoss"] doubleValue];
    if (totalLoss>=0) {
        //损失
        self.lblStatus.textColor = [Tool hexStringToColor:@"#f58383"];
        self.lblValue.textColor = [Tool hexStringToColor:@"#f58383"];
        self.imgViewStatus.image = [UIImage imageNamed:@"redmoney_icon"];
        self.lblStatus.text = @"总损失";
        self.lblValue.text = [Tool numberToStringWithFormatter:[NSNumber numberWithDouble:totalLoss]];
    }else{
        self.lblStatus.textColor = [Tool hexStringToColor:@"#70dea9"];
        self.lblValue.textColor = [Tool hexStringToColor:@"#70dea9"];
        self.imgViewStatus.image = [UIImage imageNamed:@"money_icon"];
        self.lblStatus.text = @"总节约";
        self.lblValue.text = [Tool numberToStringWithFormatter:[NSNumber numberWithDouble:(-totalLoss)]];
    }
    self.topOfView.hidden = NO;
}

- (void)setupMiddleView:(NSArray *)products{
    NSMutableArray *items = [@[] mutableCopy];
    for (NSDictionary *product in products) {
        [items addObject:@{@"text":[product objectForKey:@"name"]}];
    }
    self.segmented =[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(7, 7, kScreenWidth-14, 38) items:items iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {
            self.bottomScorllView.contentOffset=CGPointMake(segmentIndex*kScreenWidth, 0);
        }];
    self.segmented.color=[UIColor whiteColor];
    self.segmented.borderWidth=1;
    self.segmented.borderColor=[Tool hexStringToColor:@"#e0d7c6"];
    self.segmented.selectedColor=[Tool hexStringToColor:@"#e8e5df"];
    self.segmented.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                               NSForegroundColorAttributeName:[Tool hexStringToColor:@"#c3c6c9"]};
    self.segmented.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                       NSForegroundColorAttributeName:[Tool hexStringToColor:@"#3f4a58"]};
    [self.middleView addSubview:self.segmented];
}

-(void)setupBottomView:(NSArray *)products{
    CGSize scrollViewSize = self.bottomScorllView.frame.size;
    CGFloat contentHeight = kScreenHeight-self.topOfView.frame.size.height-self.middleView.frame.size.height-kNavBarHeight-kTabBarHeight-kStatusBarHeight;
    self.bottomScorllView.contentSize = CGSizeMake(scrollViewSize.width*products.count, contentHeight);
    ProductDirectMaterialCosts *productDirectMaterialCosts;
    for (int i=0; i<products.count; i++) {
        productDirectMaterialCosts = [[[NSBundle mainBundle] loadNibNamed:@"ProductDirectMaterialCosts" owner:self options:nil] objectAtIndex:0];
        NSDictionary *product = products[i];
        [productDirectMaterialCosts setupValue:product];
        productDirectMaterialCosts.frame = CGRectMake(scrollViewSize.width*i, 0, scrollViewSize.width, scrollViewSize.height);
        [self.bottomScorllView addSubview:productDirectMaterialCosts];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)changeDate:(id)sender {
    if (self.dropDownView) {
        [self.dropDownView hideDropDown:sender];
        self.dropDownView = nil;
    }else{
        self.dropDownView = [[DropDownView alloc] initWithDropDown:sender height:90.f list:@[@"今天",@"昨天",@"本月",@"本年"]];
        self.dropDownView.delegate = self;
    }
}


-(IBAction)showDetail:(id)sender {
    CostDetailVC *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CostDetailVC"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

-(void)dropDownDelegateMethod:(DropDownView *)sender{
    self.dropDownView = nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmented setEnabled:YES forSegmentAtIndex:page];
}

-(void)showPopupView:(id)sender{
    CostPopupVC *costPopupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CostPopupVC"];
    [self presentPopupViewController:costPopupVC animationType:MJPopupViewAnimationFade];
}
    
#pragma mark 自定义公共VC
-(void)responseCode0WithData{
    NSArray *products = [self.data objectForKey:@"products"];
    [self setupTopView];
    [self setupMiddleView:products];
    [self setupBottomView:products];
}
    
-(void)responseWithOtherCode{
    [super responseWithOtherCode];
}
    
-(void)setRequestParams{
    [self.request setPostValue:@"2013-11-1" forKey:@"startTime"];
    [self.request setPostValue:@"2013-11-30" forKey:@"endTime"];
}
-(void)clear{
    self.topOfView.hidden = YES;
}

@end
