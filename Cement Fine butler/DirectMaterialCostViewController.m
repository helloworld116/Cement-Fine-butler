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
#import "CostPopupView.h"

@interface DirectMaterialCostViewController ()<DropDownViewDeletegate,UIScrollViewDelegate>
//顶部控件
@property (nonatomic,strong) IBOutlet UIView *topOfView;//头部容器
@property (nonatomic,strong) DropDownView *dropDownView;
@property (nonatomic,strong) IBOutlet UIButton *btnDate;
@property (nonatomic,strong) IBOutlet UIImageView *imgViewTime;//指示时间可以下拉的箭头
@property (nonatomic,strong) IBOutlet UIImageView *imgViewStatus;
@property (nonatomic,strong) IBOutlet UILabel *lblStatus;//指示节约或损失
@property (nonatomic,strong) IBOutlet UILabel *lblValue;//节约或损失的数值
@property (nonatomic,strong) IBOutlet UILabel *lblUnit;//单位

@property (nonatomic,strong) IBOutlet UILabel *lblDetail;
@property (nonatomic,strong) IBOutlet UIImageView *imgViewDetail;

//中间部分控件
@property (nonatomic,strong) IBOutlet UIView *middleView;
@property (nonatomic,strong) PPiFlatSegmentedControl *segmented;

//底部控件
@property (nonatomic,strong) IBOutlet UIScrollView *bottomScorllView;

-(IBAction)changeDate:(id)sender;
-(IBAction)showDetail:(id)sender;

@property (nonatomic) NSInteger selectIndex;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCustomUnitCost:) name:@"customUnitCost" object:nil];
    self.URL = kRawMaterialLoss;
    [self sendRequest];
}
    
-(void)setupTopView{
    double totalLoss = [[[self.data objectForKey:@"overview"] objectForKey:@"totalLoss"] doubleValue];
    if (totalLoss>=0) {
        //损失
        self.lblStatus.textColor = [Tool hexStringToColor:@"#f58383"];
        self.lblValue.textColor = [Tool hexStringToColor:@"#f58383"];
        self.lblUnit.textColor = [Tool hexStringToColor:@"#f58383"];
        self.imgViewStatus.image = [UIImage imageNamed:@"redmoney_icon"];
        self.lblStatus.text = @"总损失";
        self.lblValue.text = [Tool numberToStringWithFormatter:[NSNumber numberWithDouble:totalLoss]];
    }else{
        self.lblStatus.textColor = [Tool hexStringToColor:@"#70dea9"];
        self.lblValue.textColor = [Tool hexStringToColor:@"#70dea9"];
        self.lblUnit.textColor = [Tool hexStringToColor:@"#70dea9"];
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
            self.selectIndex = segmentIndex;
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
    self.middleView.hidden = NO;
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
    self.bottomScorllView.hidden = NO;
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
    //旋转代码
    CGAffineTransform transform = self.imgViewTime.transform;
    transform = CGAffineTransformRotate(transform, (M_PI/180.0)*180.0f);
    self.imgViewTime.transform = transform;
}


-(IBAction)showDetail:(id)sender {
    CostDetailVC *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CostDetailVC"];
    nextVC.date = self.btnDate.currentTitle;
    nextVC.timeType = self.timeType;
    [self.navigationController pushViewController:nextVC animated:YES];
}

-(void)dropDownDelegateMethod:(DropDownView *)sender{
    CGAffineTransform transform = self.imgViewTime.transform;
    transform = CGAffineTransformRotate(transform, (M_PI/180.0)*180.0f);
    self.imgViewTime.transform = transform;
    self.timeType = sender.timeType;
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
    self.selectIndex = page;
    [self.segmented setEnabled:YES forSegmentAtIndex:page];
}

-(void)showPopupView:(id)sender{
    CostPopupVC *costPopupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CostPopupVC"];
    NSDictionary *currentSelectProduct = [[self.data objectForKey:@"products"] objectAtIndex:self.selectIndex];
    costPopupVC.defaultValue = [Tool doubleValue:[currentSelectProduct objectForKey:@"customCost"]];
    [self presentPopupViewController:costPopupVC animationType:MJPopupViewAnimationFade];
}

-(void)setCustomUnitCost:(NSNotification*) notification{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    NSNumber *value = [notification object];
    if ([value doubleValue]) {
        //1更新本地
        NSMutableDictionary *newData = [NSMutableDictionary dictionaryWithDictionary:self.data];
        NSMutableArray *newProducts = [NSMutableArray arrayWithArray:[self.data objectForKey:@"products"]];
        NSMutableDictionary *product = [NSMutableDictionary dictionaryWithDictionary:[[newData objectForKey:@"products"] objectAtIndex:self.selectIndex]];
        
        double newProductTotalLoss = [Tool doubleValue:[product objectForKey:@"totalActualCost"]]-[value doubleValue]*[Tool doubleValue:[product objectForKey:@"usedQuantity"]];
        [product setValue:[NSNumber numberWithDouble:newProductTotalLoss] forKey:@"totalLoss"];
        [product setValue:value forKey:@"customCost"];
        [product setValue:value forKey:@"compareCost"];
        [newProducts replaceObjectAtIndex:self.selectIndex withObject:product];
        [newData setValue:newProducts forKey:@"products"];
        double newAllProductTotalLoss = 0;
        for (NSDictionary *dict in newProducts) {
            newAllProductTotalLoss+=[Tool doubleValue:[dict objectForKey:@"totalLoss"]];
        }
        [newData setValue:@{@"totalLoss":[NSNumber numberWithDouble:newAllProductTotalLoss]} forKey:@"overview"];
        ProductDirectMaterialCosts *productDirectMaterialCosts = [[self.bottomScorllView subviews] objectAtIndex:self.selectIndex];
        [productDirectMaterialCosts updateValue:product];
        self.data = newData;
        //必须在修改self.data后执行setupTopView
        [self setupTopView];
        //2保存自定义数据
        long productId = [Tool longValue:[product objectForKey:@"id"]];
        DDLogCInfo(@"******  Request URL is:%@  ******",kCustomCostUpdate);
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kCustomCostUpdate]];
        request.timeOutSeconds = kASIHttpRequestTimeoutSeconds;
        [request setUseCookiePersistence:YES];
        [request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
        [request setPostValue:[NSNumber numberWithInt:kSharedApp.finalFactoryId] forKey:@"factoryId"];
        [request setPostValue:[NSNumber numberWithLong:productId] forKey:@"productId"];
        [request setPostValue:value forKey:@"customUnitCost"];
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
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }else{
        
    }
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
    [super setRequestParams];
}

-(void)clear{
    self.topOfView.hidden = YES;
    self.middleView.hidden = YES;
    self.bottomScorllView.hidden  = YES;
    self.selectIndex = 0;
    for (UIView *view in [self.bottomScorllView subviews]) {
        [view removeFromSuperview];
    }
}

@end
