//
//  CostDetailView.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-17.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "CostDetailView.h"

@implementation CostDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark begin webviewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
    
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
    
- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    if (self.data&&(NSNull *)self.data!=[NSNull null]) {
//        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
//        if (self.data&&(NSNull *)self.data!=[NSNull null]) {
//            NSArray *materials = [self.data objectForKey:@"materials"];
//            for (int i=0; i<materials.count; i++) {
//                NSDictionary *material = [materials objectAtIndex:i];
//                double unitCost = [Tool doubleValue:[material objectForKey:@"unitCost"]];
//                if (unitCost) {
//                    NSString *color = [kColorList objectAtIndex:i];
//                    //                    NSString *color = [UIColor randomColorString];
//                    //                    元/吨
//                    //                    NSString *name = [NSString stringWithFormat:@"%@ \n %@",[material objectForKey:@"name"],[material objectForKey:@"unitCost"]];
//                    NSString *name = [material objectForKey:@"name"];
//                    NSString *value = [NSString stringWithFormat:@"%.2f",unitCost];
//                    NSDictionary *data = @{@"name":name,@"value":value,@"color":color};
//                    [dataArray addObject:data];
//                }
//            }
//            NSString *pieData = [Tool objectToString:dataArray];
//            NSString *title = @"直接材料成本";
//            NSDictionary *configDict = @{@"title":title,@"height":[NSNumber numberWithFloat:self.webView.frame.size.height],@"width":[NSNumber numberWithFloat:self.webView.frame.size.width]};
//            NSString *js = [NSString stringWithFormat:@"drawDonut2D('%@','%@')",pieData,[Tool objectToString:configDict]];
//            DDLogVerbose(@"dates is %@",js);
//            [webView stringByEvaluatingJavaScriptFromString:js];
//        }
//    }
//    self.webView.hidden = NO;
}
    
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate

@end
