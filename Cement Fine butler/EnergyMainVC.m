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

@interface EnergyMainVC ()<UIScrollViewDelegate,DropDownViewDeletegate>
@property (nonatomic,strong) IBOutlet UIView *topOfView;
@property (nonatomic,strong) PPiFlatSegmentedControl *segmented;
    
@property (nonatomic,strong) IBOutlet UIView *middleView;
@property (nonatomic,strong) DropDownView *dropDownView;
@property (nonatomic,strong) IBOutlet UIImageView *imgViewTime;//指示时间可以下拉的
@property (nonatomic,strong) IBOutlet UILabel *lblDetailLoss;
    
@property (nonatomic,strong) IBOutlet UIScrollView *bottomScrollView;

@property (nonatomic) int type;//0表示煤耗，1表示电耗
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
    self.lblDetailLoss.text = @"使用0.00公斤    损失0.00公斤";
    self.URL = kEnergyMonitoring;
    [self sendRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTopView{
    self.segmented =[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(7, 7, kScreenWidth-14, 38) items:@[@{@"text":@"煤耗"},                                                                          @{@"text":@"电耗"}] iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {
            self.bottomScrollView.contentOffset=CGPointMake(segmentIndex*kScreenWidth, 0);
            self.type = segmentIndex;
            [self setupMiddleView];
         }];
    self.segmented.color=[UIColor whiteColor];
    self.segmented.borderWidth=1;
    self.segmented.borderColor=[Tool hexStringToColor:@"#e0d7c6"];
    self.segmented.selectedColor=[Tool hexStringToColor:@"#e8e5df"];
    self.segmented.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                    NSForegroundColorAttributeName:[Tool hexStringToColor:@"#c3c6c9"]};
    self.segmented.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[Tool hexStringToColor:@"#3f4a58"]};
    [self.topOfView addSubview:self.segmented];
}
    
-(void)setupMiddleView{
    if (self.type==0) {
        //煤耗
        NSDictionary *coal = [self.data objectForKey:@"coal"];
        double coalAmount = [Tool doubleValue:[coal objectForKey:@"coalAmount"]];
        double coalLossAmount = [Tool doubleValue:[coal objectForKey:@"coalLossAmount"]];
        NSString *status;
        if (coalLossAmount>=0) {
            status = @"损失";
        }else{
            coalLossAmount = -coalLossAmount;
            status = @"节约";
        }
        self.lblDetailLoss.text = [NSString stringWithFormat:@"使用%@公斤    %@%@公斤",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:coalAmount]],status,[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:coalLossAmount]]];
    }else if(self.type==1){
        //电耗
        NSDictionary *elec = [self.data objectForKey:@"elec"];
        double elecAmount = [Tool doubleValue:[elec objectForKey:@"elecAmount"]];
        double elecLossAmount = [Tool doubleValue:[elec objectForKey:@"elecLossAmount"]];
        NSString *status;
        if (elecLossAmount>=0) {
            status = @"损失";
        }else{
            elecLossAmount = -elecLossAmount;
            status = @"节约";
        }
        self.lblDetailLoss.text = [NSString stringWithFormat:@"使用%@度    %@%@度",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:elecAmount]],status,[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:elecLossAmount]]];
    }
}
    
-(void)setupBottomView{
    CGSize scrollViewSize = self.bottomScrollView.frame.size;
    CGFloat contentHeight = kScreenHeight-self.topOfView.frame.size.height-self.middleView.frame.size.height-kNavBarHeight-kTabBarHeight-kStatusBarHeight;
    self.bottomScrollView.contentSize = CGSizeMake(scrollViewSize.width*2, contentHeight);
    EnergyView *energyView;
    //煤耗
    energyView = [[[NSBundle mainBundle] loadNibNamed:@"EnergyView" owner:self options:nil] objectAtIndex:0];
    energyView.frame = CGRectMake(0, 0, scrollViewSize.width, scrollViewSize.height);
    [energyView setupValue:[self.data objectForKey:@"coal"] withType:0];
    [self.bottomScrollView addSubview:energyView];
    //电耗
    energyView = [[[NSBundle mainBundle] loadNibNamed:@"EnergyView" owner:self options:nil] objectAtIndex:0];
    energyView.frame = CGRectMake(scrollViewSize.width, 0, scrollViewSize.width, scrollViewSize.height);
    [energyView setupValue:[self.data objectForKey:@"elec"] withType:1];
    [self.bottomScrollView addSubview:energyView];
    self.bottomScrollView.hidden = NO;
}

-(IBAction)changeDate:(id)sender {
    if (self.dropDownView) {
        [self.dropDownView hideDropDown:sender];
        self.dropDownView = nil;
    }else{
        self.dropDownView = [[DropDownView alloc] initWithDropDown:sender height:90.f list:@[@"今天",@"昨天",@"本月",@"本年"]];
        self.dropDownView.delegate = self;
    }
    //旋转代码
    CGAffineTransform transform = self.imgViewTime.transform;
    transform = CGAffineTransformRotate(transform, (M_PI/180.0)*180.0f);
    self.imgViewTime.transform = transform;
}

-(void)dropDownDelegateMethod:(DropDownView *)sender{
    CGAffineTransform transform = self.imgViewTime.transform;
    transform = CGAffineTransformRotate(transform, (M_PI/180.0)*180.0f);
    self.imgViewTime.transform = transform;
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self sendRequest];
    });
    self.dropDownView = nil;
}
    
#pragma mark - UIScrollViewDelegate
    
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmented setEnabled:YES forSegmentAtIndex:page];
    self.type = page;
    [self setupMiddleView];
}
    
-(void)showPopupView:(id)sender{
    if (self.type==0) {
        //煤耗
    }else if (self.type==1){
        //电耗
        ElecPopupVC *elecPopupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ElecPopupVC"];
        double customElecUnitAmount = [Tool doubleValue:[[self.data objectForKey:@"elec"] objectForKey:@"customElecUnitAmount  "]];
        elecPopupVC.defaultValue = customElecUnitAmount;
        [self presentPopupViewController:elecPopupVC animationType:MJPopupViewAnimationFade];
    }
}


#pragma mark 自定义公共VC
-(void)responseCode0WithData{
    [self setupMiddleView];
    [self setupBottomView];
}

-(void)responseWithOtherCode{
    [super responseWithOtherCode];
}

-(void)setRequestParams{
    [super setRequestParams];
}

-(void)clear{
    self.bottomScrollView.hidden  = YES;
}
@end
