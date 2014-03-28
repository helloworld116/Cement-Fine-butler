//
//  ProductionView.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-3-28.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "ProductionView.h"
@interface ProductionView()<MBProgressHUDDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) UIButton *btnLast;//更换按钮前最后一个选中的按钮
@property (nonatomic,strong) MBProgressHUD *progressHUD;
@property (nonatomic,strong) ASIFormDataRequest *request;
@property (nonatomic) NSInteger selectIndex;

@property (nonatomic,strong) NSDictionary *data;
@property (nonatomic,strong) NSMutableArray *loadedStatus;

-(IBAction)showToday:(id)sender;
-(IBAction)showYesterday:(id)sender;
-(IBAction)showCurrentMonth:(id)sender;
-(IBAction)showCurrentYear:(id)sender;
@end

@implementation ProductionView

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ProductionView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
        self.frame = frame;
        CGFloat viewHeight = CGRectGetHeight(frame);
        CGFloat viewWidth = CGRectGetWidth(frame);
        CGFloat topViewHeight = CGRectGetHeight(self.viewTop.frame);
        self.scrollVBttom.delegate = self;
        self.scrollVBttom.contentSize = CGSizeMake(viewWidth*4, viewHeight-topViewHeight);
        [self showSelectedIndx:0];
        self.loadedStatus = [@[@{@"index":@0,@"status":@NO},@{@"index":@1,@"status":@NO},@{@"index":@2,@"status":@NO},@{@"index":@3,@"status":@NO}] mutableCopy];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

/**
 *  <#Description#>
 *
 *  @param index 0表示今天，1表示昨天，2表示本月，3是本年
 */
-(void)showSelectedIndx:(NSInteger)selectedIndex{
    self.selectIndex = selectedIndex;
    self.btnLast.backgroundColor = [UIColor whiteColor];
    self.btnLast.titleLabel.textColor = [Tool hexStringToColor:@"#93baeb"];
    switch (selectedIndex) {
        case 0:
            self.btnToday.backgroundColor = [Tool hexStringToColor:@"#93baeb"];
            self.btnToday.titleLabel.textColor = [UIColor whiteColor];
            [self.btnToday setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btnToday setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            self.btnToday.layer.cornerRadius = 6.f;
            self.btnLast = self.btnToday;
            break;
        case 1:
            self.btnYestaday.backgroundColor = [Tool hexStringToColor:@"#93baeb"];
            self.btnYestaday.titleLabel.textColor = [UIColor whiteColor];
            [self.btnYestaday setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btnYestaday setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            self.btnYestaday.layer.cornerRadius = 6.f;
            self.btnLast = self.btnYestaday;
            break;
        case 2:
            self.btnCurrentMonth.backgroundColor = [Tool hexStringToColor:@"#93baeb"];
            self.btnCurrentMonth.titleLabel.textColor = [UIColor whiteColor];
            [self.btnCurrentMonth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btnCurrentMonth setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            self.btnCurrentMonth.layer.cornerRadius = 6.f;
            self.btnLast = self.btnCurrentMonth;
            break;
        case 3:
            self.btnCurrentYear.backgroundColor = [Tool hexStringToColor:@"#93baeb"];
            self.btnCurrentYear.titleLabel.textColor = [UIColor whiteColor];
            [self.btnCurrentYear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btnCurrentYear setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            self.btnCurrentYear.layer.cornerRadius = 6.f;
            self.btnLast = self.btnCurrentYear;
            break;
        default:
            break;
    }
    if (!self.loadedStatus[selectedIndex][@"status"]) {
        [self sendRequest];
        self.loadedStatus[selectedIndex][@"status"] = @YES;
    }
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self showSelectedIndx:page];
}

-(IBAction)showToday:(id)sender{
    [self showSelectedIndx:0];
}

-(IBAction)showYesterday:(id)sender{
    [self showSelectedIndx:1];
}

-(IBAction)showCurrentMonth:(id)sender{
    [self showSelectedIndx:2];
}

-(IBAction)showCurrentYear:(id)sender{
    [self showSelectedIndx:3];
}
#pragma mark 发送网络请求
-(void) sendRequest{
    //清除数据及处理界面
//    self.responseData = nil;
//    self.data = nil;
//    self.messageView.hidden = YES;
//    //自定义清除
//    [self clear];
    //加载过程提示
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self];
    self.progressHUD.labelText = @"正在加载中...";
    self.progressHUD.labelFont = [UIFont systemFontOfSize:12];
    //    self.progressHUD.dimBackground = YES;
    self.progressHUD.opacity=1.0;
    self.progressHUD.delegate = self;
    [self addSubview:self.progressHUD];
    [self.progressHUD show:YES];
    
    DDLogCInfo(@"******  Request URL is:%@  ******",kOutputReportURL);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kOutputReportURL]];
    self.request.timeOutSeconds = kASIHttpRequestTimeoutSeconds;
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithInt:kSharedApp.finalFactoryId] forKey:@"factoryId"];
    NSDictionary *timeInfo = [Tool getTimeInfo:self.selectIndex];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"startTime"] longLongValue]] forKey:@"startTime"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"endTime"] longLongValue]] forKey:@"endTime"];
    [self.request setPostValue:[NSNumber numberWithLong:0] forKey:@"lineId"];
    [self.request setPostValue:[NSNumber numberWithLong:0] forKey:@"productId"];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(requestFailed:)];
    [self.request setDidFinishSelector:@selector(requestSuccess:)];
    [self.request startAsynchronous];
}

#pragma mark 网络请求
-(void) requestFailed:(ASIHTTPRequest *)request{
    [self.progressHUD hide:YES];
    NSString *message = nil;
    if ([@"The request timed out" isEqualToString:[[request error] localizedDescription]]) {
        message = @"网络请求超时啦。。。";
    }else{
        message = @"网络出错啦。。。";
    }
//    self.messageView.frame = self.view.frame;
//    self.messageView.labelMsg.text = message;
//    self.messageView.hidden = NO;
}

-(void)requestSuccess:(ASIHTTPRequest *)request{
    [self.progressHUD hide:YES];
    NSDictionary *responseData = [Tool stringToDictionary:request.responseString];
    int errorCode = [[responseData objectForKey:@"error"] intValue];
    if (errorCode==kErrorCode0) {
        self.data = [responseData objectForKey:@"data"];
        if ([Tool isNullOrNil:self.data]) {
//            self.messageView.frame = self.view.frame;
//            self.messageView.labelMsg.text = @"没有满足条件的数据！！！";
//            self.messageView.hidden = NO;
//            [self responseCode0WithNOData];
        }else{
//            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Bar2D" ofType:@"html"];
//            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
//            [self.view addSubview:self.webView];
        }
    }else if(errorCode==kErrorCodeExpired){
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            LoginViewController *loginViewController = (LoginViewController *)[kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
            kSharedApp.window.rootViewController = loginViewController;
        });
    }else{
        
    }
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[self.progressHUD removeFromSuperview];
	self.progressHUD = nil;
}

#pragma mark begin webviewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    if (self.dataArray.count>0) {
//        NSMutableArray *productsForSort = [NSMutableArray array];
//        NSMutableArray *products = [NSMutableArray array];
//        for (int i=0;i<self.dataArray.count;i++) {
//            NSDictionary *product = [self.dataArray objectAtIndex:i];
//            double value = [Tool doubleValue:[product objectForKey:@"value"]];
//            if (value) {
//                NSString *name = [product objectForKey:@"name"];
//                NSString *color = [kColorList objectAtIndex:i];
//                NSDictionary *reportDict = @{@"name":name,@"value":[NSNumber numberWithDouble:value],@"color":color};
//                [products addObject:reportDict];
//                [productsForSort addObject:[NSNumber numberWithDouble:value]];
//            }
//        }
//        if (products.count) {
//            NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
//            NSArray *sortedNumbers = [productsForSort sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
//            double max = [Tool doubleValue:[sortedNumbers objectAtIndex:0]];
//            int newMax = [Tool max:max];
//            double min = [Tool doubleValue:[sortedNumbers objectAtIndex:sortedNumbers.count-1]];
//            int newMin = [Tool min:min];
//            NSDictionary *configDict = @{@"tagName":@"损耗(吨)",@"height":[NSNumber numberWithFloat:self.webView.frame.size.height],@"width":[NSNumber numberWithFloat:self.webView.frame.size.width],@"start_scale":[NSNumber numberWithInt:newMin],@"end_scale":[NSNumber numberWithInt:newMax],@"scale_space":[NSNumber numberWithInt:(newMax-newMin)/5]};
//            NSString *js = [NSString stringWithFormat:@"drawBar2D('%@','%@')",[Tool objectToString:products],[Tool objectToString:configDict]];
//            DDLogCVerbose(@"js is %@",js);
//            [webView stringByEvaluatingJavaScriptFromString:js];
//        }else{
//            self.webView.hidden = YES;
//            self.view.backgroundColor = [UIColor whiteColor];
//            CGRect messageViewFrame = self.view.frame;
//            messageViewFrame.origin = CGPointMake(0, 0);
//            self.messageView = [[PromptMessageView alloc] initWithFrame:messageViewFrame];
//            self.messageView.center = self.view.center;
//            self.messageView.labelMsg.text = @"没有满足条件的数据";
//            [self.view addSubview:self.messageView];
//        }
//    }else{
//        self.webView.hidden = YES;
//        self.view.backgroundColor = [UIColor whiteColor];
//        CGRect messageViewFrame = self.view.frame;
//        messageViewFrame.origin = CGPointMake(0, 0);
//        self.messageView = [[PromptMessageView alloc] initWithFrame:messageViewFrame];
//        self.messageView.center = self.view.center;
//        self.messageView.labelMsg.text = @"没有满足条件的数据";
//        [self.view addSubview:self.messageView];
//    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate
@end
