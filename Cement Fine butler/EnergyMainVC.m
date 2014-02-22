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

@interface EnergyMainVC ()<UIScrollViewDelegate,DropDownViewDeletegate>
@property (nonatomic,strong) IBOutlet UIView *topOfView;
@property (nonatomic,strong) PPiFlatSegmentedControl *segmented;
    
@property (nonatomic,strong) IBOutlet UIView *middleView;
@property (nonatomic,strong) DropDownView *dropDownView;
@property (nonatomic,strong) IBOutlet UIImageView *imgViewTime;//指示时间可以下拉的
@property (nonatomic,strong) IBOutlet UILabel *lblDetailLoss;
    
@property (nonatomic,strong) IBOutlet UIScrollView *bottomScrollView;

@property (nonatomic) int type;//0表示煤耗，1表示电耗
@property (nonatomic,strong) EnergyView *coalView,*elecView;
@property (nonatomic,strong) CoalPopupVC *coalPopupVC;
@property (nonatomic,strong) ElecPopupVC *elecPopupVC;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setElecCustomUnitCost:) name:@"elecCustomUnitCost" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCoalCustomUnitCost:) name:@"coalCustomUnitCost" object:nil];
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
    //煤耗
    if (!self.coalView) {
        self.coalView = [[[NSBundle mainBundle] loadNibNamed:@"EnergyView" owner:self options:nil] objectAtIndex:0];
        self.coalView.frame = CGRectMake(0, 0, scrollViewSize.width, scrollViewSize.height);
        [self.bottomScrollView addSubview:self.coalView];
    }
    [self.coalView setupValue:[self.data objectForKey:@"coal"] withType:0];
    //电耗
    if (!self.elecView) {
        self.elecView = [[[NSBundle mainBundle] loadNibNamed:@"EnergyView" owner:self options:nil] objectAtIndex:0];
        self.elecView.frame = CGRectMake(scrollViewSize.width, 0, scrollViewSize.width, scrollViewSize.height);
        [self.bottomScrollView addSubview:self.elecView];
    }
    [self.elecView setupValue:[self.data objectForKey:@"elec"] withType:1];
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
        double customElecUnitAmount = [Tool doubleValue:[[self.data objectForKey:@"elec"] objectForKey:@"customElecUnitAmount"]];
        self.elecPopupVC.defaultValue = customElecUnitAmount;
        [self presentPopupViewController:self.elecPopupVC animationType:MJPopupViewAnimationFade];
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

-(void)setElecCustomUnitCost:(NSNotification*) notification{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    NSNumber *value = [notification object];
    //对标成本设置为空或者没有修改的情况下不提交修改
    if ([value doubleValue]&&[value doubleValue]!=[Tool doubleValue: [[self.data objectForKey:@"elec"] objectForKey:@"customElecUnitAmount"]]) {
        NSMutableDictionary *newData = [NSMutableDictionary dictionaryWithDictionary:self.data];
        NSDictionary *elec = [self.data objectForKey:@"elec"];
        double elecAmount = [Tool doubleValue:[elec objectForKey:@"elecAmount"]];
        double usedQuantity = [Tool doubleValue:[elec objectForKey:@"usedQuantity"]];
        double currPrice = [Tool doubleValue:[elec objectForKey:@"currPrice"]];
        
        NSMutableDictionary *newElec = [NSMutableDictionary dictionaryWithDictionary:[self.data objectForKey:@"elec"]];
        [newElec setObject:value forKey:@"compareUnitAmount"];
        [newElec setObject:value forKey:@"customElecUnitAmount"];
//        电损失数量（elecLossAmount）= 电使用量(elecAmount)  -  产品的产量(usedQuantity) * 对标电耗(compareUnitAmount)
        //必须在设置修改后查询
        double compareUnitAmount = [Tool doubleValue:[newElec objectForKey:@"compareUnitAmount"]];
        double elecLossAmount = elecAmount - usedQuantity*compareUnitAmount;
        [newElec setObject:[NSNumber numberWithDouble:elecLossAmount] forKey:@"elecLossAmount"];
//        损失(lossCost) =电损失数量（elecLossAmount）* 电的当前价格(currPrice)
        double lossCost = elecLossAmount*currPrice;
        [newElec setObject:[NSNumber numberWithDouble:lossCost] forKey:@"lossCost"];
        [newData setObject:newElec forKey:@"elec"];
        self.data = newData;
        [self setupMiddleView];
        [self setupBottomView];
        //2保存自定义数据
        DDLogCInfo(@"******  Request URL is:%@  ******",kCustomElecUpdate);
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kCustomElecUpdate]];
        request.timeOutSeconds = kASIHttpRequestTimeoutSeconds;
        [request setUseCookiePersistence:YES];
        [request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
        [request setPostValue:[NSNumber numberWithInt:kSharedApp.finalFactoryId] forKey:@"factoryId"];
        [request setPostValue:value forKey:@"customUnitOutput"];
        [request setDelegate:self];
        [request setDidFailSelector:@selector(updateRequestFailed:)];
        [request setDidFinishSelector:@selector(updateRequestSuccess:)];
        [request startAsynchronous];
    }
}

-(void)setCoalCustomUnitCost:(NSNotification*) notification{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    NSDictionary *noficationData = [notification object];
    NSNumber *value = [noficationData objectForKey:@"value"];
    if ([value doubleValue]) {
        NSMutableDictionary *newData = [NSMutableDictionary dictionaryWithDictionary:self.data];
        NSDictionary *coal = [self.data objectForKey:@"coal"];
        double coalAmount = [Tool doubleValue:[coal objectForKey:@"coalAmount"]];
        double usedQuantity = [Tool doubleValue:[coal objectForKey:@"usedQuantity"]];
        double currPrice = [Tool doubleValue:[coal objectForKey:@"currPrice"]];
        NSMutableDictionary *newCoal = [NSMutableDictionary dictionaryWithDictionary:[self.data objectForKey:@"coal"]];
        [newCoal setObject:value forKey:@"compareUnitAmount"];
        int coalSelectIndex = [[noficationData objectForKey:@"selectedIndex"] intValue];
        if (coalSelectIndex==3) {
            [newCoal setObject:value forKey:@"customElecUnitAmount"];
            if ([Tool doubleValue:[coal objectForKey:@"customElecUnitAmount"]]!=[value doubleValue]) {
                //2保存自定义数据
                DDLogCInfo(@"******  Request URL is:%@  ******",kCustomCoalUpdate);
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kCustomCoalUpdate]];
                request.timeOutSeconds = kASIHttpRequestTimeoutSeconds;
                [request setUseCookiePersistence:YES];
                [request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
                [request setPostValue:[NSNumber numberWithInt:kSharedApp.finalFactoryId] forKey:@"factoryId"];
                [request setPostValue:value forKey:@"customUnitOutput"];
                [request setDelegate:self];
                [request setDidFailSelector:@selector(updateRequestFailed:)];
                [request setDidFinishSelector:@selector(updateRequestSuccess:)];
                [request startAsynchronous];
            }
        }
        //必须在设置修改后查询
        double compareUnitAmount = [Tool doubleValue:[newCoal objectForKey:@"compareUnitAmount"]];
        //    煤损失数量（coalLossAmount）= 煤使用量(coalAmount)-产品的产量(usedQuantity) * 对标煤耗(compareUnitAmount)
        double coalLossAmount = coalAmount - usedQuantity*compareUnitAmount;
        [newCoal setObject:[NSNumber numberWithDouble:coalLossAmount] forKey:@"coalLossAmount"];
        //    损失(lossCost) =煤损失数量（coalLossAmount）*  煤的当前价格(currPrice)
        double lossCost = coalLossAmount * currPrice;
        [newCoal setObject:[NSNumber numberWithDouble:lossCost] forKey:@"lossCost"];
        [newData setObject:newCoal forKey:@"coal"];
        self.data = newData;
        [self setupMiddleView];
        [self setupBottomView];
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
@end
