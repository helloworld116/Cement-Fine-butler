//
//  RawMaterialsCalculateViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-15.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "RawMaterialsCalculateViewController.h"

@interface RawMaterialsCalculateViewController ()
@property (retain,nonatomic) NSArray *data;
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
    self.data = @[
      @{@"name":@"熟料",@"rate":@"75",@"financePrice":@"169",@"planPrice":@"169"},
      @{@"name":@"石膏",@"rate":@"5",@"financePrice":@"18",@"planPrice":@"18"},
      @{@"name":@"矿渣",@"rate":@"10",@"financePrice":@"56",@"planPrice":@"56"},
      @{@"name":@"煤煤灰",@"rate":@"5",@"financePrice":@"60",@"planPrice":@"70"},
      @{@"name":@"炉渣",@"rate":@"5",@"financePrice":@"20",@"planPrice":@"18"}
      ];
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

#pragma mark begin webviewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if([[components objectAtIndex:0] isEqualToString:@"sector"]&&[[components objectAtIndex:1] isEqualToString:@"false"]){
        //        debugLog(@"the dict is %@",[self.costItems objectAtIndex:[[components objectAtIndex:2] intValue]]);
        int index = [[components objectAtIndex:2] intValue];
        //index的值与kLossType中损耗类型索引相同
        NSArray *lossData = nil;
//        NSDictionary *data = [self.responseData objectForKey:@"data"];
//        if (index==0) {
//            //原材料损耗
//            lossData = [data objectForKey:@"rawMaterials"];
//        }else if (index==1){
//            //半成品损耗
//            lossData = [data objectForKey:@"semifinishedProduct"];
//        }else if (index==2){
//            //成品损耗
//            lossData = [data objectForKey:@"endProduct"];
//        }
//        LossReportViewController *lossReportViewController = [[LossReportViewController alloc] init];
//        lossReportViewController.title = [kLossType objectAtIndex:index];
//        lossReportViewController.dataArray = lossData;
//        lossReportViewController.hidesBottomBarWhenPushed = YES;
//        //        [self.navigationController performSelector:@selector(pushViewController:animated:) withObject:@[@"lossReportViewController",[NSNumber numberWithBool:YES]] afterDelay:0.3f];
//        [self.navigationController pushViewController:lossReportViewController animated:YES];
        return NO;
    }
    return YES;
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (int i=0; i<self.data.count; i++) {
        NSDictionary *dict = [self.data objectAtIndex:i];
        NSString *color = [kColorList objectAtIndex:i];
        NSString *name = [dict objectForKey:@"name"];
        NSString *value = [dict objectForKey:@"rate"];
        NSString *financePrice = [dict objectForKey:@"financePrice"];
        NSString *planPrice = [dict objectForKey:@"planPrice"];
        NSDictionary *chartDict = @{@"name":name,@"value":value,@"color":color,@"financePrice":financePrice,@"planPrice":planPrice};
        [dataArray addObject:chartDict];
    }
    NSDictionary *configDict = @{@"unitPrice":[NSNumber numberWithDouble:137.25],@"unitPlanPrice":[NSNumber numberWithDouble:137.65],@"unit":@"元/吨",@"title":@"",@"height":[NSNumber numberWithFloat:self.webView.frame.size.height],@"width":[NSNumber numberWithFloat:self.webView.frame.size.width]};
    NSString *js = [NSString stringWithFormat:@"drawDonut2D('%@','%@')",[Tool objectToString:dataArray],[Tool objectToString:configDict]];
    DDLogVerbose(@"dates is %@",js);
    [webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate
@end
