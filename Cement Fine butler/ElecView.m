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
        [self setupValue:data];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setElecCustomUnitCost:) name:@"elecCustomUnitCost" object:nil];
    }
    return self;
}

-(IBAction)showDetail:(id)sender{
    EnergyMainVC *viewController;
    for (UIView *next = [self superview]; next; next = [next superview]) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[EnergyMainVC class]]) {
            viewController = (EnergyMainVC *)nextResponder;
        }
    }
    [viewController showElecDetail:sender];
}

-(void)setupValue:(NSArray *)data{
    self.products = data;
    [self setupTopView];
    [self setupMiddleView:0];
    [self setupBottomView];
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
        [self setupMiddleView:segmentIndex];
    }];
    self.segmented.currentSelected = self.selectIndex;
    self.segmented.color=[UIColor whiteColor];
    self.segmented.borderWidth=1;
    self.segmented.borderColor=[Tool hexStringToColor:@"#e0d7c6"];
    self.segmented.selectedColor=[Tool hexStringToColor:@"#e8e5df"];
    self.segmented.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[Tool hexStringToColor:@"#c3c6c9"]};
    self.segmented.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[Tool hexStringToColor:@"#3f4a58"]};
    [self.topOfView addSubview:self.segmented];
}

-(void)setupMiddleView:(NSInteger)index{
    NSDictionary *product = [self.products objectAtIndex:index];
    double elecAmount = [Tool doubleValue:[product objectForKey:@"elecAmount"]];
    double elecLossAmount = [Tool doubleValue:[product objectForKey:@"elecLossAmount"]];
    NSString *status;
    if (elecLossAmount>=0) {
        status = @"损失";
    }else{
        elecLossAmount = -elecLossAmount;
        status = @"节约";
    }
    self.lblDetailLoss.text = [NSString stringWithFormat:@"使用%@度    %@%@度",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:elecAmount]],status,[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:elecLossAmount]]];
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
        EnergyMainVC *viewController;
        for (UIView *next = [self superview]; next; next = [next superview]) {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[EnergyMainVC class]]) {
                viewController = (EnergyMainVC *)nextResponder;
            }
        }
        viewController.timeType = sender.timeType;
        [viewController sendRequest];
    });
    self.dropDownView = nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    self.selectIndex = page;
    [self.segmented setEnabled:YES forSegmentAtIndex:page];
    [self setupMiddleView:page];
}

-(void)setElecCustomUnitCost:(NSNotification*) notification{
    EnergyMainVC *viewController;
    for (UIView *next = [self superview]; next; next = [next superview]) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[EnergyMainVC class]]) {
            viewController = (EnergyMainVC *)nextResponder;
        }
    }
    [viewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    NSNumber *value = [notification object];
    //对标成本设置为空或者没有修改的情况下不提交修改
    if ([value doubleValue]&&[value doubleValue]!=[Tool doubleValue: [self.products[self.selectIndex] objectForKey:@"customElecUnitAmount"]]) {
        NSMutableArray *newProducts = [NSMutableArray arrayWithArray:self.products];
        NSDictionary *elec = self.products[self.selectIndex];
        double elecAmount = [Tool doubleValue:[elec objectForKey:@"elecAmount"]];
        double usedQuantity = [Tool doubleValue:[elec objectForKey:@"usedQuantity"]];
        double currPrice = [Tool doubleValue:[elec objectForKey:@"currPrice"]];
        double productId = [Tool doubleValue:[elec objectForKey:@"productId"]];
        
        NSMutableDictionary *newElec = [NSMutableDictionary dictionaryWithDictionary:self.products[self.selectIndex]];
        [newElec setObject:value forKey:@"compareUnitAmount"];
        [newElec setObject:value forKey:@"customElecUnitAmount"];
        //电损失数量（elecLossAmount）= 电使用量(elecAmount)  -  产品的产量(usedQuantity) * 对标电耗(compareUnitAmount)
        //必须在设置修改后查询
        double compareUnitAmount = [Tool doubleValue:[newElec objectForKey:@"compareUnitAmount"]];
        double elecLossAmount = elecAmount - usedQuantity*compareUnitAmount;
        [newElec setObject:[NSNumber numberWithDouble:elecLossAmount] forKey:@"elecLossAmount"];
        //        损失(lossCost) =电损失数量（elecLossAmount）* 电的当前价格(currPrice)
        double lossCost = elecLossAmount*currPrice;
        [newElec setObject:[NSNumber numberWithDouble:lossCost] forKey:@"lossCost"];
        [newProducts replaceObjectAtIndex:self.selectIndex withObject:newElec];
        self.products = newProducts;
        [self setupBottomView];
        //2保存自定义数据
        DDLogCInfo(@"******  Request URL is:%@  ******",kCustomElecUpdate);
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kCustomElecUpdate]];
        request.timeOutSeconds = kASIHttpRequestTimeoutSeconds;
        [request setUseCookiePersistence:YES];
        [request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
        [request setPostValue:[NSNumber numberWithInt:kSharedApp.finalFactoryId] forKey:@"factoryId"];
        [request setPostValue:[NSNumber numberWithLong:productId] forKey:@"productId"];
        [request setPostValue:value forKey:@"customUnitOutput"];
        [request setDelegate:self];
        [request setDidFailSelector:@selector(updateRequestFailed:)];
        [request setDidFinishSelector:@selector(updateRequestSuccess:)];
        [request startAsynchronous];
    }
}

#pragma mark 网络请求
-(void) updateRequestFailed:(ASIHTTPRequest *)request{
    
}

-(void)updateRequestSuccess:(ASIHTTPRequest *)request{
    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
    int errorCode = [[dict objectForKey:@"error"] intValue];
    if (errorCode==kErrorCode0) {
        
    }else if(errorCode==kErrorCodeExpired){
        LoginViewController *loginViewController = (LoginViewController *)[kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }else{
        
    }
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
    [viewController showPopupView:sender withIndex:((ElecView *)[[self superview] superview]).selectIndex];
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