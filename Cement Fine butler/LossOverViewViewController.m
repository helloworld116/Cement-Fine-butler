//
//  LossOverViewViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-11.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "LossOverViewViewController.h"
#import "LossReportViewController.h"

#define kLossType @[@"原材料损耗",@"半成品损耗",@"成品损耗"]

@interface LossOverViewViewController ()
@property (retain,nonatomic) UIWebView *webView;
@property (retain,nonatomic) NSDictionary *responseData;
@end

@implementation LossOverViewViewController

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
    self.navigationItem.title = @"损耗总览";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch:)];
    
    NSString *testData = @"{\"error\":\"0\",\"message\":\"1\",\"data\":{\"overView\":{\"totalLoss\":2200.0,\"rawMaterialsLoss\":600.0,\"semifinishedProductLoss\":1000.0,\"endProductLoss\":600.0},\"rawMaterials\":[{\"name\":\"熟料\",\"value\":100.0},{\"name\":\"石膏\",\"value\":200.0}],\"semifinishedProduct\":[{\"name\":\"熟料粉\",\"value\":1000.0}],\"endProduct\":[{\"name\":\"P.O42.5\",\"value\":100.0},{\"name\":\"P.O52.5\",\"value\":500.0}]}}";
    self.responseData = [Tool stringToDictionary:testData];
    
//    CGRect webViewRect = CGRectMake(0, (kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight-kScreenWidth)/2, kScreenWidth, kScreenWidth);
    CGRect webViewRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavBarHeight-kTabBarHeight);
    self.webView = [[UIWebView alloc] initWithFrame:webViewRect];
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor clearColor];
//    self.webView.scalesPageToFit = IS_RETINA;
    UIScrollView *sc = (UIScrollView *)[[self.webView subviews] objectAtIndex:0];
    sc.showsHorizontalScrollIndicator = NO;
    sc.showsVerticalScrollIndicator = NO;
    sc.bounces = NO;//禁用上下拖拽
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Donut2D" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.webView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showSearch:(id)sender{
    [self.sidePanelController showRightPanelAnimated:YES];
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
        NSDictionary *data = [self.responseData objectForKey:@"data"];
        if (index==0) {
            //原材料损耗
            lossData = [data objectForKey:@"rawMaterials"];
        }else if (index==1){
            //半成品损耗
            lossData = [data objectForKey:@"semifinishedProduct"];
        }else if (index==2){
            //成品损耗
            lossData = [data objectForKey:@"endProduct"];
        }
        LossReportViewController *lossReportViewController = [[LossReportViewController alloc] init];
        lossReportViewController.dataArray = lossData;
        lossReportViewController.hidesBottomBarWhenPushed = YES;
//        [self.navigationController performSelector:@selector(pushViewController:animated:) withObject:@[@"lossReportViewController",[NSNumber numberWithBool:YES]] afterDelay:0.3f];
        [self.navigationController pushViewController:lossReportViewController animated:YES];
        return NO;
    }
    return YES;

}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSDictionary *data = [self.responseData objectForKey:@"data"];
    NSDictionary *overview = [data objectForKey:@"overView"];
    double totalLoss = [[overview objectForKey:@"totalLoss"] doubleValue];
    //原材料损耗
    double rawMaterialsLoss = [[overview objectForKey:@"rawMaterialsLoss"] doubleValue];
    NSDictionary *rawMaterialsDict = @{@"name":[kLossType objectAtIndex:0],@"value":[NSNumber numberWithDouble:rawMaterialsLoss],@"color":[kColorList objectAtIndex:0]};
    //半成品损耗
    double semifinishedProductLoss = [[overview objectForKey:@"semifinishedProductLoss"] doubleValue];
    NSDictionary *semifinishedProductDict = @{@"name":[kLossType objectAtIndex:1],@"value":[NSNumber numberWithDouble:semifinishedProductLoss],@"color":[kColorList objectAtIndex:1]};
    //成品损耗
    double endProductLoss = [[overview objectForKey:@"endProductLoss"] doubleValue];
    NSDictionary *endProductDict = @{@"name":[kLossType objectAtIndex:2],@"value":[NSNumber numberWithDouble:endProductLoss],@"color":[kColorList objectAtIndex:2]};
    NSArray *dataArray = @[rawMaterialsDict,semifinishedProductDict,endProductDict];
    NSDictionary *configDict = @{@"totalLoss":[NSNumber numberWithDouble:totalLoss],@"unit":@"吨",@"title":@"",@"height":[NSNumber numberWithFloat:self.webView.frame.size.height],@"width":[NSNumber numberWithFloat:self.webView.frame.size.width]};
    NSString *js = [NSString stringWithFormat:@"drawDonut2D('%@','%@')",[Tool objectToString:dataArray],[Tool objectToString:configDict]];
    DDLogVerbose(@"dates is %@",js);
    [webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate

@end
