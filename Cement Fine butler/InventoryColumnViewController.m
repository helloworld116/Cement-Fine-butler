//
//  InventoryColumnViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-7.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "InventoryColumnViewController.h"
#import "LoadingView.h"

@interface InventoryColumnViewController ()<MBProgressHUDDelegate>
@property (nonatomic,retain) LoadingView *loadingView;
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain, nonatomic) NSDictionary *data;
@property (retain, nonatomic) PromptMessageView *messageView;
@property (retain,nonatomic) MBProgressHUD *progressHUD;
@property (retain,nonatomic) NSString *chartTitle;
@end

@implementation InventoryColumnViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.loadingView = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil] objectAtIndex:0];
//    [self.loadingView startLoading];
//    [self.view insertSubview:self.loadingView aboveSubview:self.bottomWebiew];
//    [self.view bringSubviewToFront:self.loadingView];
//    DDLogVerbose(@"self view subview is %@",[self.view subviews]);
    //观察查询条件修改
    [self.sidePanelController.rightPanel addObserver:self forKeyPath:@"searchCondition" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
//    [self.sidePanelController showCenterPanelAnimated:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //移除观察条件
    [self.sidePanelController.rightPanel removeObserver:self forKeyPath:@"searchCondition"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //最开始异步请求数据
    [self sendRequest:0];//默认查询原材料库存
    self.title = @"库存报表";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showNav:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchCondition:)];
    
    [(UIScrollView *)[[self.bottomWebiew subviews] objectAtIndex:0] setBounces:NO];//禁用上下拖拽
    self.bottomWebiew.delegate = self;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Column2D" ofType:@"html"];
    [self.bottomWebiew loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    UIScrollView *sc = (UIScrollView *)[[self.bottomWebiew subviews] objectAtIndex:0];
    sc.contentSize = CGSizeMake(self.bottomWebiew.frame.size.width, self.bottomWebiew.frame.size.height);
    sc.showsHorizontalScrollIndicator = NO;
    //    self.bottomWebiew.frame = CGRectMake(self.bottomWebiew.frame.origin.x, self.bottomWebiew.frame.origin.y, self.bottomWebiew.frame.size.width*2, self.bottomWebiew.frame.size.height);
    //设置没有数据或发生错误时的view
    self.messageView = [[PromptMessageView alloc] initWithFrame:CGRectZero];
    CGRect messageViewRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kStatusBarHeight);
    self.messageView.frame = messageViewRect;
    self.messageView.hidden = YES;
    [self.view addSubview:self.messageView];
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
    //    NSString *requestString = [[request URL] absoluteString];
    //    NSArray *components = [requestString componentsSeparatedByString:@":"];
    //    if(([[components objectAtIndex:0] isEqualToString:@"sector"]&&[[components objectAtIndex:1] isEqualToString:@"false"])||([[components objectAtIndex:0] isEqualToString:@"legend"])){
    //        return NO;
    //    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (self.data) {
        NSArray *stockArray = [self.data objectForKey:@"materials"];
        if(stockArray.count>0){
            NSMutableArray *stocksForSort = [NSMutableArray array];
            NSMutableArray *stocks = [NSMutableArray array];
            for (int i=0;i<stockArray.count;i++) {
                NSDictionary *stock = [stockArray objectAtIndex:i];
                double value = [[stock objectForKey:@"stock"] doubleValue];
                NSString *name = [stock objectForKey:@"name"];
                NSString *color = [kColorList objectAtIndex:i];
                NSDictionary *reportDict = @{@"name":name,@"value":[NSNumber numberWithDouble:value],@"color":color};
                [stocks addObject:reportDict];
                [stocksForSort addObject:[NSNumber numberWithDouble:value]];
            }
            NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
            NSArray *sortedNumbers = [stocksForSort sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            double max = [[sortedNumbers objectAtIndex:0] doubleValue];
            max = [Tool max:max];
            NSDictionary *configDict = @{@"title":self.chartTitle,@"tagName":@"库存(吨)",@"height":[NSNumber numberWithFloat:self.bottomWebiew.frame.size.height],@"width":[NSNumber numberWithFloat:self.bottomWebiew.frame.size.width],@"start_scale":[NSNumber numberWithFloat:0],@"end_scale":[NSNumber numberWithFloat:max],@"scale_space":[NSNumber numberWithFloat:max/5]};
            NSString *js = [NSString stringWithFormat:@"drawColumn('%@','%@')",[Tool objectToString:stocks],[Tool objectToString:configDict]];
            [webView stringByEvaluatingJavaScriptFromString:js];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate

#pragma mark 发送网络请求
-(void) sendRequest:(int)stockType{
    //清除原数据
    self.data = nil;
    self.scrollView.hidden=YES;
    self.messageView.hidden = YES;
    //加载过程提示
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.labelText = @"加载中...";
    self.progressHUD.labelFont = [UIFont systemFontOfSize:12];
    self.progressHUD.dimBackground = YES;
    self.progressHUD.opacity=1.0;
    self.progressHUD.delegate=self;
    [self.view addSubview:self.progressHUD];
    [self.progressHUD show:YES];

    DDLogCInfo(@"******  Request URL is:%@  ******",kStockReportURL);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kStockReportURL]];
    self.request.timeOutSeconds = kASIHttpRequestTimeoutSeconds;
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithInt:kSharedApp.finalFactoryId] forKey:@"factoryId"];
    [self.request setPostValue:[NSNumber numberWithInt:stockType] forKey:@"type"];
    if (stockType==0) {
        self.chartTitle = @"原材料库存";
    }else{
        self.chartTitle = @"成品库存";
    }
    [self.request setDelegate:self];
    [self.request setDidFailSelector:@selector(requestFailed:)];
    [self.request setDidFinishSelector:@selector(requestSuccess:)];
    [self.request startAsynchronous];
}

#pragma mark 网络请求
-(void) requestFailed:(ASIHTTPRequest *)request{
    [self.progressHUD hide:YES];
    self.messageView.hidden = NO;
    self.messageView.labelMsg.text=@"请求出错了。。。";
}

-(void)requestSuccess:(ASIHTTPRequest *)request{
    [self.progressHUD hide:YES];
    NSDictionary *dict = [Tool stringToDictionary:request.responseString];
    int responseCode = [[dict objectForKey:@"error"] intValue];
    if (responseCode==kErrorCode0) {
        self.data = [dict objectForKey:@"data"];
        NSArray *materials = [self.data objectForKey:@"materials"];
        if (self.data&&(NSNull *)self.data!=[NSNull null]&&materials.count>0) {
            [self.bottomWebiew reload];
            self.scrollView.hidden = NO;
        }else{
            self.messageView.hidden = NO;
            self.messageView.labelMsg.text=@"没有满足条件的数据";
        }
    }else if(responseCode==kErrorCodeExpired){
        LoginViewController *loginViewController = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        kSharedApp.window.rootViewController = loginViewController;
    }else{
        self.messageView.hidden = NO;
        self.messageView.labelMsg.text=@"未知错误。。。";
    }
}

#pragma mark end webviewDelegate
- (IBAction)showNav:(id)sender {
    [self.sidePanelController showLeftPanelAnimated:YES];
}

- (IBAction)showSearchCondition:(id)sender {
    [self.sidePanelController showRightPanelAnimated:YES];
}

#pragma mark 观察条件变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"searchCondition"]) {
        if ([change objectForKey:@"old"]) {
            DDLogCVerbose(@"old is %@",[change objectForKey:@"old"]);
            DDLogCVerbose(@"条件发生变化");
            SearchCondition *condition = [change objectForKey:@"new"];
            [self sendRequest:condition.inventoryType];
        }
    }
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[self.progressHUD removeFromSuperview];
	self.progressHUD = nil;
}
@end
