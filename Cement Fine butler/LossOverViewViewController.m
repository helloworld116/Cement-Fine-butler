//
//  LossOverViewViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-11.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "LossOverViewViewController.h"

@interface LossOverViewViewController ()
@property (retain,nonatomic) UIWebView *webView;
@property (retain,nonatomic) NSDictionary *data;
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
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = IS_RETINA;
    UIScrollView *sc = (UIScrollView *)[[self.webView subviews] objectAtIndex:0];
    sc.showsHorizontalScrollIndicator = NO;
    sc.showsVerticalScrollIndicator = NO;
    sc.bounces = NO;//禁用上下拖拽
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Donut2D" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    [self.view addSubview:self.webView];
    
    NSString *testData = @"{\"error\":\"0\",\"message\":\"1\",\"data\":{\"overView\":{\"totalLoss\":2200,\"rawMaterialsLoss\":600,\"semifinishedProductLoss\":1000,\"endProductLoss\":600},\"rawMaterials\":[{\"name\":\"熟料\",\"value\":100},{\"name\":\"石膏\",\"value\":200}],\"semifinishedProduct\":[{\"name\":\"熟料粉\",\"value\":1000}],\"endProduct\":[{\"name\":\"P.O42.5\",\"value\":100},{\"name\":\"P.O52.5\",\"value\":500}]}}";
    self.data = [Tool stringToDictionary:testData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark begin webviewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSDictionary *overview = [self.data objectForKey:@"overView"];
    double totalLoss = [[overview objectForKey:@"totalLoss"] doubleValue];
    
    double rawMaterialsLoss = [[overview objectForKey:@"rawMaterialsLoss"] doubleValue];
    NSDictionary *rawMaterialsDict = @{@"name":@"原材料损耗",@"value":[NSNumber numberWithDouble:rawMaterialsLoss],@"color":[kColorList objectAtIndex:0]};
    double semifinishedProductLoss = [[overview objectForKey:@"semifinishedProductLoss"] doubleValue];
    NSDictionary *semifinishedProductDict = @{@"name":@"半成品损耗",@"value":[NSNumber numberWithDouble:semifinishedProductLoss],@"color":[kColorList objectAtIndex:1]};
    double endProductLoss = [[overview objectForKey:@"endProductLoss"] doubleValue];
    NSDictionary *endProductDict = @{@"name":@"成品损耗",@"value":[NSNumber numberWithDouble:endProductLoss],@"color":[kColorList objectAtIndex:2]};
    NSArray *dataArray = @[rawMaterialsDict,semifinishedProductDict,endProductDict];
    NSDictionary *configDict = @{@"totalLoss":[NSNumber numberWithDouble:totalLoss],@"unit":@"吨",@"title":@"原材料损耗总览",@"height":[NSNumber numberWithFloat:self.webView.frame.size.height],@"width":[NSNumber numberWithFloat:self.webView.frame.size.width]};
    NSString *js = [NSString stringWithFormat:@"drawDonut2D('%@','%@')",[Tool objectToString:dataArray],[Tool objectToString:configDict]];
    DDLogVerbose(@"dates is %@",js);
    [webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate

@end
