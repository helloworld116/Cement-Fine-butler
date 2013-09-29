//
//  ProductColumnViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-3.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "ProductColumnViewController.h"

@interface ProductColumnViewController ()
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain, nonatomic) NSDictionary *data;
@property (retain, nonatomic) LoadingView *loadingView;

@property (retain, nonatomic) NSString *reportTitlePre;//报表标题前缀，指明时间段
@end

@implementation ProductColumnViewController

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
    //最开始异步请求数据
    NSDictionary *condition = @{@"lineId": [NSNumber numberWithLong:0],@"productId": [NSNumber numberWithLong:0],@"timeType":[NSNumber numberWithInt:2]};
    [self sendRequest:condition];//默认查询原材料库存
    //设置view相关
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.topItem.title = @"产量报表";
    
    [(UIScrollView *)[[self.bottomWebiew subviews] objectAtIndex:0] setBounces:NO];//禁用上下拖拽
    self.bottomWebiew.delegate = self;
    self.bottomWebiew.scalesPageToFit = IS_RETINA;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Column2D" ofType:@"html"];
    [self.bottomWebiew loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    UIScrollView *sc = (UIScrollView *)[[self.bottomWebiew subviews] objectAtIndex:0];
    sc.contentSize = CGSizeMake(self.bottomWebiew.frame.size.width, self.bottomWebiew.frame.size.height);
    sc.showsHorizontalScrollIndicator = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //观察查询条件修改
    [self.sidePanelController.rightPanel addObserver:self forKeyPath:@"searchCondition" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //移除观察条件
    [self.sidePanelController.rightPanel removeObserver:self forKeyPath:@"searchCondition"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTopContainerView:nil];
    [self setBottomWebiew:nil];
    [self setScrollView:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
}

#pragma mark begin webviewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (self.data&&(NSNull *)self.data!=[NSNull null]) {
        NSArray *productArray = [self.data objectForKey:@"products"];
        NSMutableArray *productsForSort = [NSMutableArray array];
        NSMutableArray *products = [NSMutableArray array];
        for (int i=0;i<productArray.count;i++) {
            NSDictionary *product = [productArray objectAtIndex:i];
            double value = [[product objectForKey:@"output"] doubleValue];
            NSString *name = [product objectForKey:@"name"];
            NSString *color = [kColorList objectAtIndex:i];
            NSDictionary *reportDict = @{@"name":name,@"value":[NSNumber numberWithDouble:value],@"color":color};
            [products addObject:reportDict];
            [productsForSort addObject:[NSNumber numberWithDouble:value]];
        }
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
        NSArray *sortedNumbers = [productsForSort sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        double max = [[sortedNumbers objectAtIndex:0] doubleValue];
        max = [Tool max:max];
        NSString *title = [self.reportTitlePre stringByAppendingString:@"产量报表"];
        NSDictionary *configDict = @{@"title":title,@"tagName":@"产量(吨)",@"height":[NSNumber numberWithFloat:self.bottomWebiew.frame.size.height],@"width":[NSNumber numberWithFloat:self.bottomWebiew.frame.size.width],@"start_scale":[NSNumber numberWithFloat:0],@"end_scale":[NSNumber numberWithFloat:max],@"scale_space":[NSNumber numberWithFloat:max/5]};
        NSString *js = [NSString stringWithFormat:@"drawColumn('%@','%@')",[Tool objectToString:products],[Tool objectToString:configDict]];
        [webView stringByEvaluatingJavaScriptFromString:js];
    }else if([Tool isNullOrNil:self.data]){
        //没有满足条件的数据
        
    }
}
   
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate

#pragma mark 发送网络请求
-(void) sendRequest:(NSDictionary *)condition{
    self.loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight)];
    [self.view addSubview:self.loadingView];
    [self.loadingView startLoading];
    int timeType = [[condition objectForKey:@"timeType"] intValue];
    NSDictionary *timeInfo = [Tool getTimeInfo:timeType];
    self.reportTitlePre = [timeInfo objectForKey:@"timeDesc"];
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kOutputReportURL]];
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"startTime"] longLongValue]] forKey:@"startTime"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"endTime"] longLongValue]] forKey:@"endTime"];
    [self.request setPostValue:[NSNumber numberWithLong:[[condition objectForKey:@"lineId"] longValue]] forKey:@"lineId"];
    [self.request setPostValue:[NSNumber numberWithLong:[[condition objectForKey:@"productId"] longValue]] forKey:@"productId"];
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(requestFailed:)];
    [self.request setDidFinishSelector:@selector(requestSuccess:)];
    [self.request startAsynchronous];
}

#pragma mark 网络请求
-(void) requestFailed:(ASIHTTPRequest *)request{

}

-(void)requestSuccess:(ASIHTTPRequest *)request{
    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
    int responseCode = [[dict objectForKey:@"error"] intValue];
    if (responseCode==0) {
        self.data = [dict objectForKey:@"data"];
        [self.bottomWebiew reload];
        
        [self.loadingView successEndLoading];
    }else if(responseCode==-1){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }else{

    }
}

#pragma mark 观察条件变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"searchCondition"]) {
        SearchCondition *searchCondition = [change objectForKey:@"new"];
        NSDictionary *condition = @{@"productId":[NSNumber numberWithLong:searchCondition.productID],@"lineId":[NSNumber numberWithLong:searchCondition.lineID],@"timeType":[NSNumber numberWithInt:searchCondition.timeType]};
        [self sendRequest:condition];
    }
}

- (IBAction)showNav:(id)sender {
    [self.sidePanelController showLeftPanelAnimated:YES];
}

- (IBAction)showSearchCondition:(id)sender {
    [self.sidePanelController showRightPanelAnimated:YES];
}
@end
