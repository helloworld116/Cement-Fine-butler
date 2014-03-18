//
//  CoalView.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-3-7.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "CoalView.h"
#import "EnergyMainVC.h"
#import "DropDownView.h"

@interface CoalView()<DropDownViewDeletegate>

@property (nonatomic,retain) NSDictionary *data;

@property (nonatomic,strong) IBOutlet UIView *topView;
@property (nonatomic,strong) DropDownView *dropDownView;
@property (nonatomic,strong) IBOutlet UIImageView *imgViewTime;//指示时间可以下拉的
@property (nonatomic,strong) IBOutlet UILabel *lblDetailLoss;

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
-(IBAction)changeDate:(id)sender;

@end

@implementation CoalView

- (id)initWithFrame:(CGRect)frame withData:(NSDictionary *)data
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"EnergyView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
        self.frame = frame;
        [self setupValue:data];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCoalCustomUnitCost:) name:@"coalCustomUnitCost" object:nil];
    return self;
}


-(void)setupValue:(NSDictionary *)data{
    self.data = data;
    //煤耗
    double coalAmount = [Tool doubleValue:[data objectForKey:@"coalAmount"]];
    double coalLossAmount = [Tool doubleValue:[data objectForKey:@"coalLossAmount"]];
    NSString *status;
    if (coalLossAmount>=0) {
        status = @"损失";
    }else{
        coalLossAmount = -coalLossAmount;
        status = @"节约";
    }
    self.lblDetailLoss.text = [NSString stringWithFormat:@"使用%@公斤    %@%@公斤",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:coalAmount]],status,[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:coalLossAmount]]];
    
    double coalUnitAmount = [Tool doubleValue:[data objectForKey:@"coalUnitAmount"]];
    double compareUnitAmount = [Tool doubleValue:[data objectForKey:@"compareUnitAmount"]];
    double lossCost = [Tool doubleValue:[data objectForKey:@"lossCost"]];
    NSString *suggestion = [Tool stringToString:[data objectForKey:@"suggestion"]];
    
    self.lblRealText.text=@"煤耗（公斤/吨）";
    self.lblRealValue.text=[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:coalUnitAmount]];
    self.lblBenchmarkingText.text=@"对标煤耗（公斤/吨）";
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
    self.imgViewType.image = [UIImage imageNamed:@"coal_consumption_icon_new"];
    self.lblSuggestion.text = suggestion;
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

-(IBAction)showPopupView:(id)sender{
    EnergyMainVC *viewController;
    for (UIView *next = [self superview]; next; next = [next superview]) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[EnergyMainVC class]]) {
            viewController = (EnergyMainVC *)nextResponder;
        }
    }
    [viewController showPopupView:sender withIndex:0];
}

-(void)setCoalCustomUnitCost:(NSNotification*) notification{
    EnergyMainVC *viewController;
    for (UIView *next = [self superview]; next; next = [next superview]) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[EnergyMainVC class]]) {
            viewController = (EnergyMainVC *)nextResponder;
        }
    }
    [viewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    NSDictionary *noficationData = [notification object];
    NSNumber *value = [noficationData objectForKey:@"value"];
    if ([value doubleValue]) {
        NSDictionary *coal = self.data;
        double coalAmount = [Tool doubleValue:[coal objectForKey:@"coalAmount"]];
        double usedQuantity = [Tool doubleValue:[coal objectForKey:@"usedQuantity"]];
        double currPrice = [Tool doubleValue:[coal objectForKey:@"currPrice"]];
        NSMutableDictionary *newCoal = [NSMutableDictionary dictionaryWithDictionary:self.data];
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
        //煤损失数量（coalLossAmount）= 煤使用量(coalAmount)-产品的产量(usedQuantity) * 对标煤耗(compareUnitAmount)
        double coalLossAmount = coalAmount - usedQuantity*compareUnitAmount;
        [newCoal setObject:[NSNumber numberWithDouble:coalLossAmount] forKey:@"coalLossAmount"];
        //    损失(lossCost) =煤损失数量（coalLossAmount）*  煤的当前价格(currPrice)
        double lossCost = coalLossAmount * currPrice;
        [newCoal setObject:[NSNumber numberWithDouble:lossCost] forKey:@"lossCost"];
        self.data = newCoal;
        [self setupValue:self.data];
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
