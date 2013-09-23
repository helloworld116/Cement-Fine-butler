//
//  HistroyTrendsViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-21.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "HistroyTrendsViewController.h"

@interface HistroyTrendsViewController ()

@end

@implementation HistroyTrendsViewController

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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"产量";
    [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];//禁用上下拖拽
    self.webView.delegate = self;
    self.webView.scalesPageToFit = IS_RETINA;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"LineBasic2D" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    UIScrollView *sc = (UIScrollView *)[[self.webView subviews] objectAtIndex:0];
    sc.contentSize = CGSizeMake(self.webView.frame.size.width, self.webView.frame.size.height);
    sc.showsHorizontalScrollIndicator = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //    NSString *columnConfig= [NSString stringWithFormat:@"{'title':'2013年产量','tagName':'产量(吨)','height':%f,'width':%f,'start_scale':%f,'end_scale':%f,'scale_space':%f}",self.bottomWebiew.frame.size.height,self.bottomWebiew.frame.size.width,0.0,40.0,8.0];
    ////    NSString *js = [[ stringByAppendingString:data] stringByAppendingFormat:@""];
    //    NSString *js = [NSString stringWithFormat:@"drawColumn(\"%@\",\"%@\")",data,columnConfig];
    //    DDLogVerbose(@"dates is %@",js);
    //    [webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showSearch:(id)sender {
    [self.sidePanelController showRightPanelAnimated:YES];
}
@end
