//
//  LossReportViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-12.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "LossReportViewController.h"

@interface LossReportViewController ()
@property (retain,nonatomic) UIWebView *webView;
@end

@implementation LossReportViewController

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
//    CGRect webViewRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight);
//    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(pop)];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    CGRect webViewRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight);
    self.webView = [[UIWebView alloc] initWithFrame:webViewRect];
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor clearColor];
    UIScrollView *sc = (UIScrollView *)[[self.webView subviews] objectAtIndex:0];
    sc.showsHorizontalScrollIndicator = NO;
    sc.showsVerticalScrollIndicator = NO;
    sc.bounces = NO;//禁用上下拖拽
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Column2D" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
//    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark begin webviewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSMutableArray *productsForSort = [NSMutableArray array];
    NSMutableArray *products = [NSMutableArray array];
    for (int i=0;i<self.dataArray.count;i++) {
        NSDictionary *product = [self.dataArray objectAtIndex:i];
        double value = [[product objectForKey:@"value"] doubleValue];
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
//    NSString *title = [self.reportTitlePre stringByAppendingString:@"产量报表"];
    NSDictionary *configDict = @{@"title":[self.titlePre stringByAppendingString:self.title],@"tagName":@"损耗量(吨)",@"height":[NSNumber numberWithFloat:self.webView.frame.size.height],@"width":[NSNumber numberWithFloat:self.webView.frame.size.width],@"start_scale":[NSNumber numberWithFloat:0],@"end_scale":[NSNumber numberWithFloat:max],@"scale_space":[NSNumber numberWithFloat:max/5]};
    NSString *js = [NSString stringWithFormat:@"drawColumn('%@','%@')",[Tool objectToString:products],[Tool objectToString:configDict]];
    DDLogCVerbose(@"js is %@",js);
    [webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate
@end
