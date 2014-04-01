//
//  InventoryView.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-3-31.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "InventoryView.h"

@interface InventoryView()<UIScrollViewDelegate,MBProgressHUDDelegate,UIWebViewDelegate>
@property (nonatomic,strong) IBOutlet UIView *viewTop;
@property (nonatomic,strong) IBOutlet UIButton *btnLeft;
@property (nonatomic,strong) IBOutlet UIButton *btnRight;
@property (nonatomic,strong) IBOutlet UILabel *lblTypeName;

@property (nonatomic,strong) IBOutlet UIScrollView *scrollVBttom;

@property (nonatomic,strong) NSMutableArray *loadedStatus;
@property (nonatomic,strong) MBProgressHUD *progressHUD;
@property (nonatomic,strong) ASIFormDataRequest *request;
@property (nonatomic) NSInteger selectIndex;
@property (nonatomic,strong) NSDictionary *data;
-(IBAction)goLeft:(id)sender;
-(IBAction)goRight:(id)sender;
@end

@implementation InventoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"InventoryView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
        self.frame = frame;
        CGFloat viewHeight = CGRectGetHeight(frame);
        CGFloat viewWidth = CGRectGetWidth(frame);
        CGFloat topViewHeight = CGRectGetHeight(self.viewTop.frame);
        CGFloat scrollViewHeight = viewHeight-topViewHeight;
        self.scrollVBttom.delegate = self;
        self.scrollVBttom.frame = CGRectMake(0, topViewHeight, kScreenWidth, scrollViewHeight);
        self.scrollVBttom.contentSize = CGSizeMake(viewWidth*2, scrollViewHeight);
        self.loadedStatus = [@[@{@"status":@0},@{@"status":@0}] mutableCopy];
        [self showSelectedIndx:0];
    }
    return self;
}

-(void)showSelectedIndx:(NSInteger)selectedIndex{
    self.selectIndex = selectedIndex;
    if (selectedIndex==0) {
        self.btnRight.enabled=YES;
        self.btnLeft.enabled=NO;
        self.lblTypeName.text = @"原材料库存";
    }else if(selectedIndex==1){
        self.btnRight.enabled=NO;
        self.btnLeft.enabled=YES;
        self.lblTypeName.text = @"成本库存";
    }
    if ([self.loadedStatus[selectedIndex][@"status"] intValue]==0) {
        [self sendRequest];
        [self.loadedStatus replaceObjectAtIndex:selectedIndex withObject:@{@"status":@1}];
    }
    self.scrollVBttom.contentOffset = CGPointMake(self.selectIndex*kScreenWidth, 0);
}

-(IBAction)goLeft:(id)sender{
    [self showSelectedIndx:0];
}


-(IBAction)goRight:(id)sender{
    [self showSelectedIndx:1];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self showSelectedIndx:page];
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
    
    DDLogCInfo(@"******  Request URL is:%@  ******",kStockReportURL);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kStockReportURL]];
    self.request.timeOutSeconds = kASIHttpRequestTimeoutSeconds;
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithInt:kSharedApp.finalFactoryId] forKey:@"factoryId"];
    [self.request setPostValue:[NSNumber numberWithLong:self.selectIndex] forKey:@"type"];
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
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Bar2D" ofType:@"html"];
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(self.selectIndex*kScreenWidth, 0, kScreenWidth, self.scrollVBttom.contentSize.height)];
            webView.delegate = self;
            webView.backgroundColor = [UIColor clearColor];
            UIScrollView *sc = (UIScrollView *)[[webView subviews] objectAtIndex:0];
            sc.bounces = NO;//禁用上下拖拽
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
            [self.scrollVBttom addSubview:webView];
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
    NSArray *dataArray = [self.data objectForKey:@"materials"];
    if (dataArray.count>0) {
        NSMutableArray *productsForSort = [NSMutableArray array];
        NSMutableArray *products = [NSMutableArray array];
        for (int i=0;i<dataArray.count;i++) {
            NSDictionary *product = [dataArray objectAtIndex:i];
            double value = [Tool doubleValue:[product objectForKey:@"stock"]];
            if (value) {
                NSString *name = [product objectForKey:@"name"];
                NSString *color = [kColorList objectAtIndex:i];
                NSDictionary *reportDict = @{@"name":name,@"value":[NSNumber numberWithDouble:value],@"color":color};
                [products addObject:reportDict];
                [productsForSort addObject:[NSNumber numberWithDouble:value]];
            }
        }
        if (products.count) {
            NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
            NSArray *sortedNumbers = [productsForSort sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            double max = [Tool doubleValue:[sortedNumbers objectAtIndex:0]];
            int newMax = [Tool max:max];
            double min = [Tool doubleValue:[sortedNumbers objectAtIndex:sortedNumbers.count-1]];
            int newMin = [Tool min:min];
            NSDictionary *configDict = @{@"tagName":@"损耗(吨)",@"height":[NSNumber numberWithFloat:webView.frame.size.height],@"width":[NSNumber numberWithFloat:webView.frame.size.width],@"start_scale":[NSNumber numberWithInt:newMin],@"end_scale":[NSNumber numberWithInt:newMax],@"scale_space":[NSNumber numberWithInt:(newMax-newMin)/5]};
            NSString *js = [NSString stringWithFormat:@"drawBar2D('%@','%@')",[Tool objectToString:products],[Tool objectToString:configDict]];
            DDLogCVerbose(@"js is %@",js);
            [webView stringByEvaluatingJavaScriptFromString:js];
        }else{
            //            self.webView.hidden = YES;
            //            self.view.backgroundColor = [UIColor whiteColor];
            //            CGRect messageViewFrame = self.view.frame;
            //            messageViewFrame.origin = CGPointMake(0, 0);
            //            self.messageView = [[PromptMessageView alloc] initWithFrame:messageViewFrame];
            //            self.messageView.center = self.view.center;
            //            self.messageView.labelMsg.text = @"没有满足条件的数据";
            //            [self.view addSubview:self.messageView];
        }
    }else{
        //        self.webView.hidden = YES;
        //        self.view.backgroundColor = [UIColor whiteColor];
        //        CGRect messageViewFrame = self.view.frame;
        //        messageViewFrame.origin = CGPointMake(0, 0);
        //        self.messageView = [[PromptMessageView alloc] initWithFrame:messageViewFrame];
        //        self.messageView.center = self.view.center;
        //        self.messageView.labelMsg.text = @"没有满足条件的数据";
        //        [self.view addSubview:self.messageView];
    }
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate
@end
