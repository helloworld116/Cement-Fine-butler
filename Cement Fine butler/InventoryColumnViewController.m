//
//  InventoryColumnViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-7.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "InventoryColumnViewController.h"
#import "LoadingView.h"

@interface InventoryColumnViewController ()
@property (nonatomic,retain) LoadingView *loadingView;
@property (retain, nonatomic) ASIFormDataRequest *request;
@property (retain, nonatomic) NSDictionary *data;
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
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.topItem.title = @"库存报表";
    //
    [(UIScrollView *)[[self.bottomWebiew subviews] objectAtIndex:0] setBounces:NO];//禁用上下拖拽
    self.bottomWebiew.delegate = self;
    self.bottomWebiew.scalesPageToFit = IS_RETINA;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Column2D" ofType:@"html"];
    [self.bottomWebiew loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    UIScrollView *sc = (UIScrollView *)[[self.bottomWebiew subviews] objectAtIndex:0];
    sc.contentSize = CGSizeMake(self.bottomWebiew.frame.size.width, self.bottomWebiew.frame.size.height);
    sc.showsHorizontalScrollIndicator = NO;
    //    self.bottomWebiew.frame = CGRectMake(self.bottomWebiew.frame.origin.x, self.bottomWebiew.frame.origin.y, self.bottomWebiew.frame.size.width*2, self.bottomWebiew.frame.size.height);
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
    //    NSString *data = @"[{'name':'IE','value':35.75,'color':'#a5c2d5'},{'name':'Chrome','value':29.84,'color':'#cbab4f'},{'name':'Firefox','value':24.88,'color':'#76a871'},{'name':'Safari','value':6.77,'color':'#9f7961'},{'name':'Opera','value':2.02,'color':'#a56f8f'}]";
    //    NSString *columnConfig= [NSString stringWithFormat:@"{'title':'2013年库存','tagName':'库存(吨)','height':%f,'width':%f,'start_scale':%f,'end_scale':%f,'scale_space':%f}",self.bottomWebiew.frame.size.height,self.bottomWebiew.frame.size.width,0.0,40.0,8.0];
    //    //    NSString *js = [[ stringByAppendingString:data] stringByAppendingFormat:@""];
    //    NSString *js = [NSString stringWithFormat:@"drawColumn(\"%@\",\"%@\")",data,columnConfig];
    //    DDLogVerbose(@"dates is %@",js);
    //    [webView stringByEvaluatingJavaScriptFromString:js];
    if (self.data) {
        NSArray *stockArray = [self.data objectForKey:@"materials"];
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
        NSDictionary *configDict = @{@"title":@"原材料库存",@"tagName":@"库存(吨)",@"height":[NSNumber numberWithFloat:self.bottomWebiew.frame.size.height],@"width":[NSNumber numberWithFloat:self.bottomWebiew.frame.size.width],@"start_scale":[NSNumber numberWithFloat:0],@"end_scale":[NSNumber numberWithFloat:max],@"scale_space":[NSNumber numberWithFloat:max/5]};
        NSString *js = [NSString stringWithFormat:@"drawColumn('%@','%@')",[Tool objectToString:stocks],[Tool objectToString:configDict]];
        [webView stringByEvaluatingJavaScriptFromString:js];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate

#pragma mark 发送网络请求
-(void) sendRequest:(int)stockType{
    self.loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight)];
    [self.view addSubview:self.loadingView];
    [self.loadingView startLoading];
    
    DDLogCInfo(@"******  Request URL is:%@  ******",kStockReportURL);
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kStockReportURL]];
    [self.request setUseCookiePersistence:YES];
    [self.request setPostValue:kSharedApp.accessToken forKey:@"accessToken"];
    [self.request setPostValue:[NSNumber numberWithInt:stockType] forKey:@"type"];
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
            [self sendRequest:condition.stockType];
        }
    }
}
@end
