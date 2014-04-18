//
//  CostDetailView.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-2-17.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "CostDetailView.h"
@interface CostDetailView()<UIWebViewDelegate>

@property (nonatomic,strong) IBOutlet UILabel *lblFinancialPrice;
@property (nonatomic,strong) IBOutlet UILabel *lblCurrentPrice;
@property (nonatomic,strong) IBOutlet UILabel *lblPlanPrice;
@property (nonatomic,strong) IBOutlet UILabel *lblTBText;
@property (nonatomic,strong) IBOutlet UILabel *lblTBValue;
@property (nonatomic,strong) IBOutlet UILabel *lblHBText;
@property (nonatomic,strong) IBOutlet UILabel *lblHBValue;

@property (nonatomic,retain) NSDictionary *product;
@property (nonatomic,copy) NSString *date;
@end

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
    NSMutableArray *dataArray = [@[] mutableCopy];
    NSArray *materials = [self.product objectForKey:@"recoveryMaterials"];
    for (int i=0; i<materials.count; i++) {
        NSDictionary *material = [materials objectAtIndex:i];
        double unitCost = [Tool doubleValue:[material objectForKey:@"unitCost"]];
//        if (unitCost) {
            NSString *color = [kColorList objectAtIndex:i];
            NSString *name = [material objectForKey:@"name"];
            NSString *value = [NSString stringWithFormat:@"%.2f",unitCost];
            NSDictionary *data = @{@"name":name,@"value":value,@"color":color};
            [dataArray addObject:data];
//        }
    }
    NSString *pieData = [Tool objectToString:dataArray];
    NSDictionary *configDict = @{@"height":[NSNumber numberWithFloat:self.webView.frame.size.height],@"width":[NSNumber numberWithFloat:self.webView.frame.size.width],@"date":self.date};
    NSString *js = [NSString stringWithFormat:@"drawDonut2D('%@','%@')",pieData,[Tool objectToString:configDict]];
    DDLogVerbose(@"dates is %@",js);
    [webView stringByEvaluatingJavaScriptFromString:js];
    self.webView.hidden = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{

}
#pragma mark end webviewDelegate

-(void)setupValue:(NSDictionary *)product withDate:(NSString *)date{
    if (product) {
        self.product = product;
        self.date = date;
        self.webView.delegate = self;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Donut2D_2" ofType:@"html"];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
        UIScrollView *sc = (UIScrollView *)[[self.webView subviews] objectAtIndex:0];
        sc.showsHorizontalScrollIndicator = NO;
        sc.showsVerticalScrollIndicator = NO;
        sc.bounces = NO;//禁用上下拖拽
        
        double currentUnitCost = [Tool doubleValue:[product objectForKey:@"currentUnitCost"]];
        double planUnitCost = [Tool doubleValue:[product objectForKey:@"planUnitCost"]];
        double financeUnitCost = [Tool doubleValue:[product objectForKey:@"financeUnitCost"]];
        double costTongbiRate = [Tool doubleValue:[product objectForKey:@"costTongbiRate"]];
        double costHuanbiRate = [Tool doubleValue:[product objectForKey:@"costHuanbiRate"]];
        self.lblCurrentPrice.text = [Tool numberToStringWithFormatter:[NSNumber numberWithDouble:currentUnitCost]];
        self.lblFinancialPrice.text = [Tool numberToStringWithFormatter:[NSNumber numberWithDouble:financeUnitCost]];
        self.lblPlanPrice.text = [Tool numberToStringWithFormatter:[NSNumber numberWithDouble:planUnitCost]];
        if (costTongbiRate>0) {
            self.lblTBText.text = @"同比增长：";
            self.lblTBValue.text = [NSString stringWithFormat:@"%@%@",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:costTongbiRate]],@"%"];
        }else if (costTongbiRate==0){
            self.lblTBText.text = @"同比增长：";
            self.lblTBValue.text = @"---";
        }else if (costTongbiRate<0){
            self.lblTBText.text = @"同比减少：";
            self.lblTBValue.text = [NSString stringWithFormat:@"%@%@",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:(-costTongbiRate)]],@"%"];
        }
        if (costHuanbiRate>0) {
            self.lblHBText.text = @"环比增长：";
            self.lblHBValue.text = [NSString stringWithFormat:@"%@%@",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:costHuanbiRate]],@"%"];
        }else if (costHuanbiRate==0){
            self.lblHBText.text = @"环比增长：";
            self.lblHBValue.text = @"---";
        }else if (costHuanbiRate<0){
            self.lblHBText.text = @"环比减少：";
            self.lblHBValue.text = [NSString stringWithFormat:@"%@%@",[Tool numberToStringWithFormatter:[NSNumber numberWithDouble:(-costHuanbiRate)]],@"%"];
        }
    }
}
@end
