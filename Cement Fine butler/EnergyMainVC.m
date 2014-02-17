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

@interface EnergyMainVC ()<UIScrollViewDelegate,DropDownViewDeletegate>
@property (nonatomic,strong) IBOutlet UIView *topView;
@property (nonatomic,strong) PPiFlatSegmentedControl *segmented;
    
@property (nonatomic,strong) IBOutlet UIView *middleView;
@property (nonatomic,strong) DropDownView *dropDownView;
@property (nonatomic,strong) IBOutlet UIImageView *imgViewTime;//指示时间可以下拉的
@property (nonatomic,strong) IBOutlet UILabel *lblDetailLoss;
    
@property (nonatomic,strong) IBOutlet UIScrollView *bottomScrollView;
@end

@implementation EnergyMainVC

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
    [self setupTopView];
    [self setupMiddleView];
    [self setupBottomView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTopView{
    self.segmented =[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(7, 7, kScreenWidth-14, 38) items:@[@{@"text":@"煤耗"},                                                                          @{@"text":@"电耗"}] iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {
             self.bottomScrollView.contentOffset=CGPointMake(segmentIndex*kScreenWidth, 0);
         }];
    self.segmented.color=[UIColor whiteColor];
    self.segmented.borderWidth=1;
    self.segmented.borderColor=[Tool hexStringToColor:@"#e0d7c6"];
    self.segmented.selectedColor=[Tool hexStringToColor:@"#e8e5df"];
    self.segmented.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                    NSForegroundColorAttributeName:[Tool hexStringToColor:@"#c3c6c9"]};
    self.segmented.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[Tool hexStringToColor:@"#3f4a58"]};
    [self.topView addSubview:self.segmented];
}
    
-(void)setupMiddleView{

}
    
-(void)setupBottomView{
    CGSize scrollViewSize = self.bottomScrollView.frame.size;
    CGFloat contentHeight = kScreenHeight-self.topView.frame.size.height-self.middleView.frame.size.height-kNavBarHeight-kTabBarHeight-kStatusBarHeight;
    self.bottomScrollView.contentSize = CGSizeMake(scrollViewSize.width*2, contentHeight);
    EnergyView *energyView;
    //煤耗
    energyView = [[[NSBundle mainBundle] loadNibNamed:@"EnergyView" owner:self options:nil] objectAtIndex:0];
    energyView.frame = CGRectMake(0, 0, scrollViewSize.width, scrollViewSize.height);
    [self.bottomScrollView addSubview:energyView];
    //电耗
    energyView = [[[NSBundle mainBundle] loadNibNamed:@"EnergyView" owner:self options:nil] objectAtIndex:0];
    energyView.frame = CGRectMake(scrollViewSize.width, 0, scrollViewSize.width, scrollViewSize.height);
    [self.bottomScrollView addSubview:energyView];
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
    [self presentPopupViewController:nil animationType:MJPopupViewAnimationFade];
}
@end
