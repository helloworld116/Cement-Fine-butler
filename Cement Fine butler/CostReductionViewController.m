//
//  CostReductionViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-19.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "CostReductionViewController.h"

@interface CostReductionViewController ()

@property (nonatomic,retain) UIWebView *webView;
@end

@implementation CostReductionViewController

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
    self.title = @"成本还原";
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 30)];
    [backBtn setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return_click_icon"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

    CGRect webViewRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight);
    self.webView = [[UIWebView alloc] initWithFrame:webViewRect];
    self.webView.delegate = self;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Pie2D" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    UIScrollView *sc = (UIScrollView *)[[self.webView subviews] objectAtIndex:0];
    sc.showsHorizontalScrollIndicator = NO;
    sc.showsVerticalScrollIndicator = NO;
    sc.bounces = NO;//禁用上下拖拽
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
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i=0; i<self.data.count; i++) {
        NSDictionary *material = [self.data objectAtIndex:i];
        NSString *color = [kColorList objectAtIndex:i];
        NSString *name = [NSString stringWithFormat:@"%@ %@元/吨",[Tool stringToString:[material objectForKey:@"name"]],[material objectForKey:@"unitCost"]];
        NSString *value = [NSString stringWithFormat:@"%.2f",[[material objectForKey:@"unitCost"] doubleValue]];
        NSDictionary *data = @{@"name":name,@"value":value,@"color":color};
        //去除垃圾数据，name为空或者value为0的数据
        if (![Tool isNullOrNil:name]&&[[material objectForKey:@"unitCost"] doubleValue]!=0) {
            [dataArray addObject:data];
        }
    }
    NSString *pieData = [Tool objectToString:dataArray];
    NSString *title = [self.chartTitle stringByAppendingString:@"原材料成本"];
    NSDictionary *configDict = @{@"title":title,@"height":[NSNumber numberWithFloat:self.webView.frame.size.height],@"width":[NSNumber numberWithFloat:self.webView.frame.size.width-60]};
    NSString *js = [NSString stringWithFormat:@"drawPie2D('%@','%@')",pieData,[Tool objectToString:configDict]];
    DDLogVerbose(@"dates is %@",js);
    [webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate
@end
