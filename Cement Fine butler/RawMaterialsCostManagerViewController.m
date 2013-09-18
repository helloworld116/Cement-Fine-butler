//
//  RawMaterialsCostManagerViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-17.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "RawMaterialsCostManagerViewController.h"

@interface RawMaterialsCostManagerViewController ()

@end

@implementation RawMaterialsCostManagerViewController

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
    [super viewDidLoad]; [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"原材料成本管理";
    //
    [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];//禁用上下拖拽
    self.webView.delegate = self;
    self.webView.scalesPageToFit = IS_RETINA;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Pie2D" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    UIScrollView *sc = (UIScrollView *)[[self.webView subviews] objectAtIndex:0];
//    sc.contentSize = CGSizeMake(self.webView.frame.size.width, self.webView.frame.size.height);
    sc.showsHorizontalScrollIndicator = NO;
    sc.showsVerticalScrollIndicator = NO;
    //    self.bottomWebiew.frame = CGRectMake(self.bottomWebiew.frame.origin.x, self.bottomWebiew.frame.origin.y, self.bottomWebiew.frame.size.width*2, self.bottomWebiew.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [self setScrollView:nil];
    [self setWebView:nil];
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
    //    NSString *data = @"[{ids:1,name:\"UC浏览器\",value:40.0,color:\"#4572a7\"},{ids:2,name:\"QQ浏览器\",value:37.1,color:\"#aa4643\"},{ids:3,name:\"欧朋浏览器\",value:13.8,color:\"#89a54e\"},{ids:4,name:\"百度浏览器\",value:1.6,color:\"#80699b\"},{ids:5,name:\"海豚浏览器\",value:1.4,color:\"#92a8cd\"},{ids:6,name:\"天天浏览器\",value:1.2,color:\"#db843d\"},{ids:7,name:\"其他\",value:4.9,color:\"#a47d7c\"}]";
    //    function drawLineChart(todayPrice,dates,advicePrices,realPrices)
    //    NSString *todayPrice = nil;
    //    if (![self.currentProduct objectForKey:@"advicePrice"]) {
    //        todayPrice = [NSString stringWithFormat:@"%.1f",[[self.currentProduct objectForKey:@"advicePrice"] doubleValue]];//今日推荐售价
    //    }
    //    NSArray *prices = [self.currentProduct objectForKey:@"chardata"];
    //    NSMutableString *advicePrice = [NSMutableString string];
    //    NSMutableString *realPrice = [NSMutableString string];
    //    NSMutableString *dates = [NSMutableString string];
    //    NSDictionary *dict = nil;
    //    for (int i=0; i<prices.count; i++) {
    //        dict = [prices objectAtIndex:i];
    //        [advicePrice appendFormat:@"%.1f",[[dict objectForKey:@"advicePrice"] doubleValue]];
    //        [realPrice appendFormat:@"%.1f",[[dict objectForKey:@"price"] doubleValue]];
    //        [dates appendString:[Tool timeIntervalToString:[[dict objectForKey:@"time"] doubleValue] dateformat:kDateFormatDay]];
    //        if (i!=prices.count-1) {
    //            [advicePrice appendString:@","];
    //            [realPrice appendString:@","];
    //            [dates appendString:@","];
    //        }
    //    }
    //
    //    NSString *js = [@"drawLineChart(" stringByAppendingFormat:@"'%@','%@','%@','%@'%@",todayPrice,dates,advicePrice,realPrice,@")"];
    NSString *data = @"[{'name':'熟料','value':56.95,'color':'#a5c2d5'},{'name':'粉煤灰','value':27.05,'color':'#cbab4f'},{'name':'矿渣','value':14.55,'color':'#76a871'},{'name':'石膏','value':1.45,'color':'#9f7961'}]";
    NSString *columnConfig= [NSString stringWithFormat:@"{'title':'2013-09-01至2013-09-30直接材料成本','height':%f,'width':%f}",self.webView.frame.size.height+25,self.webView.frame.size.width];
    //    NSString *js = [[ stringByAppendingString:data] stringByAppendingFormat:@""];
    NSString *js = [NSString stringWithFormat:@"drawColumn(\"%@\",\"%@\")",data,columnConfig];
    DDLogVerbose(@"dates is %@",js);
    [webView stringByEvaluatingJavaScriptFromString:js];
    UIScrollView *sc = (UIScrollView *)[[webView subviews] objectAtIndex:0];
    sc.contentSize = CGSizeMake(webView.frame.size.width, webView.frame.size.height-25);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate

@end
