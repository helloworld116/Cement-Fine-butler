//
//  RawMaterialsCalculateViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-15.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "RawMaterialsCalculateViewController.h"

@interface RawMaterialsCalculateViewController ()
@property (retain,nonatomic) UIWebView *webView;
@end

@implementation RawMaterialsCalculateViewController

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
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back-arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.title = @"计算结果详情";
    
//    self.data = @[
//      @{@"name":@"熟料",@"rate":@"75",@"financePrice":@"169",@"planPrice":@"169"},
//      @{@"name":@"石膏",@"rate":@"5",@"financePrice":@"18",@"planPrice":@"18"},
//      @{@"name":@"矿渣",@"rate":@"10",@"financePrice":@"56",@"planPrice":@"56"},
//      @{@"name":@"煤煤灰",@"rate":@"5",@"financePrice":@"60",@"planPrice":@"70"},
//      @{@"name":@"炉渣",@"rate":@"5",@"financePrice":@"20",@"planPrice":@"18"}
    
//      @{@"name":@"熟料",@"rate":@"1",@"financePrice":@"60",@"planPrice":@"70"},
//      @{@"name":@"石膏",@"rate":@"1",@"financePrice":@"60",@"planPrice":@"70"},
//      @{@"name":@"矿渣",@"rate":@"1",@"financePrice":@"60",@"planPrice":@"70"},
//      @{@"name":@"煤煤灰",@"rate":@"1",@"financePrice":@"60",@"planPrice":@"70"},
//      @{@"name":@"炉渣",@"rate":@"1",@"financePrice":@"60",@"planPrice":@"70"},
//      @{@"name":@"熟料",@"rate":@"1",@"financePrice":@"60",@"planPrice":@"70"},
//      @{@"name":@"石膏",@"rate":@"1",@"financePrice":@"60",@"planPrice":@"70"},
//      @{@"name":@"矿渣",@"rate":@"1",@"financePrice":@"60",@"planPrice":@"70"},
//      @{@"name":@"煤煤灰",@"rate":@"1",@"financePrice":@"60",@"planPrice":@"70"},
//      @{@"name":@"炉渣",@"rate":@"1",@"financePrice":@"60",@"planPrice":@"70"}
//      ];
    CGRect webViewRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight);
    self.webView = [[UIWebView alloc] initWithFrame:webViewRect];
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor clearColor];
    UIScrollView *sc = (UIScrollView *)[[self.webView subviews] objectAtIndex:0];
    sc.showsHorizontalScrollIndicator = NO;
    sc.showsVerticalScrollIndicator = NO;
    sc.bounces = NO;//禁用上下拖拽
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Calculate" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
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
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    double unitPrice=0,unitPlanPrice=0;
    for (int i=0; i<self.data.count; i++) {
        NSDictionary *dict = [self.data objectAtIndex:i];
        NSString *color = [kColorList objectAtIndex:i];
        NSString *name = [dict objectForKey:@"name"];
        double value = [[dict objectForKey:@"rate"] doubleValue];
        NSDictionary *chartDict = @{@"name":name,@"value":[NSNumber numberWithDouble:value],@"color":color};
        [dataArray addObject:chartDict];
        
        double financePrice = [[dict objectForKey:@"financePrice"] doubleValue];
        double planPrice = [[dict objectForKey:@"planPrice"] doubleValue];
        unitPrice+=(financePrice*value)/100;
        unitPlanPrice+=(planPrice*value)/100;
    }
    NSString *unitPriceString = [NSString stringWithFormat:@"%.2f",round(unitPrice*100)/100];
    NSString *unitPlanPriceString = [NSString stringWithFormat:@"%.2f",round(unitPlanPrice*100)/100];
    NSDictionary *configDict = @{@"unitPrice":unitPriceString,@"unitPlanPrice":unitPlanPriceString,@"unit":@"元/吨",@"title":@"",@"height":[NSNumber numberWithFloat:self.webView.frame.size.height],@"width":[NSNumber numberWithFloat:self.webView.frame.size.width]};
    NSString *js = [NSString stringWithFormat:@"drawDonut2D('%@','%@')",[Tool objectToString:dataArray],[Tool objectToString:configDict]];
    DDLogVerbose(@"dates is %@",js);
    [webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate
@end
