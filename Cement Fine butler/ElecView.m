//
//  ElecView.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-3-7.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "ElecView.h"
#import "EnergyMainVC.h"
#import "DropDownView.h"
#import <PPiFlatSegmentedControl.h>

@interface ElecView()<DropDownViewDeletegate,UIScrollViewDelegate>
@property (nonatomic,strong) IBOutlet UIView *topOfView;
@property (nonatomic,strong) PPiFlatSegmentedControl *segmented;

@property (nonatomic,strong) IBOutlet UIView *middleView;
@property (nonatomic,strong) DropDownView *dropDownView;
@property (nonatomic,strong) IBOutlet UIImageView *imgViewTime;//指示时间可以下拉的
@property (nonatomic,strong) IBOutlet UILabel *lblDetailLoss;

@property (nonatomic,strong) IBOutlet UIScrollView *bottomScrollView;
@property (nonatomic) int selectIndex;
-(IBAction)changeDate:(id)sender;
-(IBAction)showDetail:(id)sender;

@property (nonatomic,strong) NSArray *products;
@end

@implementation ElecView

- (id)initWithFrame:(CGRect)frame withData:(NSArray *)data
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"EnergyView" owner:self options:nil] objectAtIndex:1];
    if (self) {
        self.frame = frame;
        self.products = data;
        self.bottomScrollView.showsHorizontalScrollIndicator= NO;
        self.bottomScrollView.pagingEnabled = YES;
        self.bottomScrollView.delegate = self;
        [self setupTopView];
        [self setupMiddleView];
        [self setupBottomView];
    }
    return self;
}

-(IBAction)showDetail:(id)sender{
    
}

-(void)setupTopView{
    self.middleView.hidden = NO;
    NSMutableArray *items = [@[] mutableCopy];
    for (NSDictionary *product in self.products) {
        [items addObject:@{@"text":[product objectForKey:@"productName"]}];
    }
    self.segmented =[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(7, 10, kScreenWidth-14, 38) items:items iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {
        self.selectIndex = segmentIndex;
        self.bottomScrollView.contentOffset=CGPointMake(segmentIndex*kScreenWidth, 0);
    }];
    self.segmented.color=[UIColor whiteColor];
    self.segmented.borderWidth=1;
    self.segmented.borderColor=[Tool hexStringToColor:@"#e0d7c6"];
    self.segmented.selectedColor=[Tool hexStringToColor:@"#e8e5df"];
    self.segmented.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[Tool hexStringToColor:@"#c3c6c9"]};
    self.segmented.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[Tool hexStringToColor:@"#3f4a58"]};
    [self.topOfView addSubview:self.segmented];
}

-(void)setupMiddleView{
    double totalElecAmount=0.f,totalElecLossAmount=0.f;
    for (NSDictionary *product in self.products) {
        double elecAmount = [Tool doubleValue:[product objectForKey:@"elecAmount"]];
        double elecLossAmount = [Tool doubleValue:[product objectForKey:@"elecLossAmount"]];
        totalElecAmount += elecAmount;
        totalElecLossAmount += elecLossAmount;
    }
    NSString *status;
    if (totalElecLossAmount>=0) {
        status = @"损失";
    }else{
        totalElecLossAmount = -totalElecLossAmount;
        status = @"节约";
    }
    self.lblDetailLoss.text = [NSString stringWithFormat:@"使用%@度    %@%@度",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:totalElecAmount]],status,[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:totalElecLossAmount]]];
}

-(void)setupBottomView{
    CGSize scrollViewSize = self.bottomScrollView.frame.size;
    self.bottomScrollView.contentSize = CGSizeMake(scrollViewSize.width*self.products.count, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight-145);
    ElecProductView *productView;
    for (int i=0; i<self.products.count; i++) {
        NSDictionary *product = self.products[i];
        productView = [[ElecProductView alloc] initWithFrame:CGRectMake(scrollViewSize.width*i, 0, scrollViewSize.width, self.bottomScrollView.contentSize.height) withData:product];
        [self.bottomScrollView addSubview:productView];
    }
}


-(IBAction)changeDate:(id)sender {
    if (self.dropDownView) {
        [self.dropDownView hideDropDown:sender];
        self.dropDownView = nil;
    }else{
        self.dropDownView = [[DropDownView alloc] initWithDropDown:sender height:120.f list:@[@"今天",@"昨天",@"本月",@"本年"]];
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
        //        [self sendRequest];
    });
    self.dropDownView = nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    self.selectIndex = page;
    [self.segmented setEnabled:YES forSegmentAtIndex:page];
}

@end


@interface ElecProductView()
@property (nonatomic,strong) IBOutlet UIView *leftTopView;
@property (nonatomic,strong) IBOutlet UILabel *lblRealValue;
@property (nonatomic,strong) IBOutlet UILabel *lblRealText;


@property (nonatomic,strong) IBOutlet UIView *leftBottomView;
@property (nonatomic,strong) IBOutlet UILabel *lblBenchmarkingValue;
@property (nonatomic,strong) IBOutlet UILabel *lblBenchmarkingText;

@property (nonatomic,strong) IBOutlet UIView *rightView;
@property (nonatomic,strong) IBOutlet UIImageView *imgViewType;
@property (nonatomic,strong) IBOutlet UILabel *lblStatus;
@property (nonatomic,strong) IBOutlet UILabel *lblValue;
@property (nonatomic,strong) IBOutlet UILabel *lblSuggestion;

-(IBAction)showPopupView:(id)sender;
@end

@implementation ElecProductView
-(id)initWithFrame:(CGRect)frame withData:(NSDictionary *)data{
    self = [[[NSBundle mainBundle] loadNibNamed:@"EnergyView" owner:self options:nil] objectAtIndex:2];
    if (self) {
        self.frame = frame;
        [self setupValue:data];
    }
    return self;
}

-(IBAction)showPopupView:(id)sender{
    EnergyMainVC *viewController;
    for (UIView *next = [self superview]; next; next = [next superview]) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[EnergyMainVC class]]) {
            viewController = (EnergyMainVC *)nextResponder;
        }
    }
    [viewController showPopupView:sender];
}

-(void)setupValue:(NSDictionary *)data{
    double elecUnitAmount = [Tool doubleValue:[data objectForKey:@"elecUnitAmount"]];
    double compareUnitAmount = [Tool doubleValue:[data objectForKey:@"compareUnitAmount"]];
    double lossCost = [Tool doubleValue:[data objectForKey:@"lossCost"]];
    NSString *suggestion = [Tool stringToString:[data objectForKey:@"suggestion"]];
    self.lblRealText.text=@"电耗（度/吨）";
    self.lblRealValue.text=[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:elecUnitAmount]];
    self.lblBenchmarkingText.text=@"对标电耗（度/吨）";
    self.lblBenchmarkingValue.text=[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:compareUnitAmount]];
    if (lossCost>=0) {
        self.lblStatus.text =@"损失 (元)";
        self.rightView.backgroundColor = [Tool hexStringToColor:@"#f58383"];
        self.lblValue.text = [Tool numberToStringWithFormatterWithNODecimal:[NSNumber numberWithDouble:lossCost]];
    }else{
        self.lblStatus.text =@"节约 (元)";
        self.rightView.backgroundColor = [Tool hexStringToColor:@"#70dea9"];
        self.lblValue.text = [Tool numberToStringWithFormatterWithNODecimal:[NSNumber numberWithDouble:-lossCost]];
    }
    self.imgViewType.image = [UIImage imageNamed:@"power_consumption_icon_new"];
    self.lblSuggestion.text = suggestion;
}
@end