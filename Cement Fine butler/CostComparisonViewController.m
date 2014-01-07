//
//  CostComparisonViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-19.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "CostComparisonViewController.h"
#define kLabelHeight 30//底部字段描述label高度
#define kLabelOrignX 10//label距离父容器左边距离


@interface CostComparisonViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) NSString *reportTitlePre;//报表标题前缀，指明时间段
@property (retain, nonatomic) TitleView *titleView;
@end

@implementation CostComparisonViewController

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
    self.titleView = [[TitleView alloc] init];
    self.navigationItem.titleView = self.titleView;
    if (self.type==1) {
       self.titleView.lblTitle.text = @"原材料环比成本";
    }else{
       self.titleView.lblTitle.text = @"原材料同比成本";
    }
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 30)];
    [backBtn setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return_click_icon"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

    self.webView.delegate = self;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Pie2D" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    UIScrollView *sc = (UIScrollView *)[[self.webView subviews] objectAtIndex:0];
    sc.showsHorizontalScrollIndicator = NO;
    sc.showsVerticalScrollIndicator = NO;
    sc.bounces = NO;//禁用上下拖拽
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.condition.timeType = self.timeType;
    self.URL = kMaterialCostURL;
    [self sendRequest];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setBottomViewOfSubView {
    for (UIView *subView in [self.bottomView subviews]) {
        [subView removeFromSuperview];
    }
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.##"];
    NSDictionary *overView = [self.data objectForKey:@"overView"];
    NSString *totalCost,*unitCost,*currentUnitCost,*budgetedUnitCost,*costHuanbiRate,*costTongbiRate;
    if (overView&&(NSNull *)overView!=[NSNull null]) {
        //成本环比增长率
        if (![Tool isNullOrNil:[overView objectForKey:@"costHuanbiRate"]]) {
            costHuanbiRate = [NSString stringWithFormat:@"%.2f%@",[[overView objectForKey:@"costHuanbiRate"] doubleValue]*100,@"%"];
        }else{
            costHuanbiRate = @"";
        }
        //成本同比增长率
        if (![Tool isNullOrNil:[overView objectForKey:@"costTongbiRate"]]) {
            costTongbiRate = [NSString stringWithFormat:@"%.2f%@",[[overView objectForKey:@"costTongbiRate"] doubleValue]*100,@"%"];
        }else{
            costTongbiRate = @"";
        }
        //当前单位成本
        if (![Tool isNullOrNil:[overView objectForKey:@"currentUnitCost"]]) {
            //            currentUnitCost = [NSString stringWithFormat:@"%.2f",[[overView objectForKey:@"currentUnitCost"] doubleValue]];
            currentUnitCost = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[Tool doubleValue:[overView objectForKey:@"currentUnitCost"]]]];
        }
        //计划单位成本
        if (![Tool isNullOrNil:[overView objectForKey:@"budgetedUnitCost"]]) {
            //            budgetedUnitCost = [NSString stringWithFormat:@"%.2f",[[overView objectForKey:@"budgetedUnitCost"] doubleValue]];
            budgetedUnitCost = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[Tool doubleValue:[overView objectForKey:@"budgetedUnitCost"]]]];
        }
        //财务单位成本
        if (![Tool isNullOrNil:[overView objectForKey:@"unitCost"]]) {
            //            unitCost = [NSString stringWithFormat:@"%.2f",[[overView objectForKey:@"unitCost"] doubleValue]];
            unitCost = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[Tool doubleValue:[overView objectForKey:@"unitCost"]]]];
        }
        //总成本
        if (![Tool isNullOrNil:[overView objectForKey:@"totalCost"]]) {
            //            totalCost = [NSString stringWithFormat:@"%.2f",[[overView objectForKey:@"totalCost"] doubleValue]];
            totalCost = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[Tool doubleValue:[overView objectForKey:@"totalCost"]]]];
        }
        NSString *preStr = @"<font size=20 color='red'>";
        NSString *sufStr = @"</font>";
        
        RTLabel *lblTotalCost = [[RTLabel alloc] initWithFrame:CGRectMake(kLabelOrignX, 0, kScreenWidth-2*kLabelOrignX, kLabelHeight)];
        NSString *strTotalCost = [@"总成本: " stringByAppendingFormat:@"%@%@%@%@",preStr,totalCost,sufStr,@"元"];
        [lblTotalCost setText:strTotalCost];
        [self.bottomView addSubview:lblTotalCost];
        
        RTLabel *lblFinanceUitCost = [[RTLabel alloc] initWithFrame:CGRectMake(kLabelOrignX, kLabelHeight, kScreenWidth-2*kLabelOrignX, kLabelHeight)];
        NSString *strFinanceUnitCost = [@"财务单位成本: " stringByAppendingFormat:@"%@%@%@%@",preStr,unitCost,sufStr,@"元/吨"];
        [lblFinanceUitCost setText:strFinanceUnitCost];
        [self.bottomView addSubview:lblFinanceUitCost];
        
        RTLabel *lblCurrentUitCost = [[RTLabel alloc] initWithFrame:CGRectMake(kLabelOrignX, kLabelHeight*2, kScreenWidth-2*kLabelOrignX, kLabelHeight)];
        NSString *strCurrentUnitCost = [@"当期单位成本: " stringByAppendingFormat:@"%@%@%@%@",preStr,currentUnitCost,sufStr,@"元/吨"];
        [lblCurrentUitCost setText:strCurrentUnitCost];
        [self.bottomView addSubview:lblCurrentUitCost];
        
        RTLabel *lblPlanUitCost = [[RTLabel alloc] initWithFrame:CGRectMake(kLabelOrignX, kLabelHeight*3, kScreenWidth-2*kLabelOrignX, kLabelHeight)];
        NSString *strPlanUnitCost = [@"计划单位成本: " stringByAppendingFormat:@"%@%@%@%@",preStr,budgetedUnitCost,sufStr,@"元/吨"];
        [lblPlanUitCost setText:strPlanUnitCost];
        [self.bottomView addSubview:lblPlanUitCost];
        
        RTLabel *lblTongbi = [[RTLabel alloc] initWithFrame:CGRectMake(kLabelOrignX, kLabelHeight*4, kScreenWidth-2*kLabelOrignX, kLabelHeight)];
        NSString *strTongbi = [@"同比增长: " stringByAppendingFormat:@"%@%@%@",preStr,costTongbiRate,sufStr];
        [lblTongbi setText:strTongbi];
        [self.bottomView addSubview:lblTongbi];
        
        RTLabel *lblHuanbi = [[RTLabel alloc] initWithFrame:CGRectMake(kLabelOrignX, kLabelHeight*5, kScreenWidth-2*kLabelOrignX, kLabelHeight)];
        NSString *strHuanbi = [@"环比增长: " stringByAppendingFormat:@"%@%@%@",preStr,costHuanbiRate,sufStr];
        [lblHuanbi setText:strHuanbi];
        [self.bottomView addSubview:lblHuanbi];
        
        CGFloat bottomViewHeight = self.bottomView.frame.size.height;
        //底部view需要的高度，距离上下都是10
        CGFloat bottomViewNeedHeight = kLabelHeight*self.bottomView.subviews.count;
        //减去10是为了减少在两者差距很小的情况下，避免可拖动
        if (bottomViewHeight<bottomViewNeedHeight) {
            self.scrollView.contentSize = CGSizeMake(kScreenWidth,bottomViewNeedHeight+self.bottomView.frame.origin.y);
        }
    }
    //    self.bottomView.backgroundColor = [Tool hexStringToColor:@"#f1f1f1"];
    self.bottomView.hidden=NO;
}

#pragma mark begin webviewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (self.data&&(NSNull *)self.data!=[NSNull null]) {
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        if (self.data&&(NSNull *)self.data!=[NSNull null]) {
            NSArray *materials = [self.data objectForKey:@"materials"];
            for (int i=0; i<materials.count; i++) {
                NSDictionary *material = [materials objectAtIndex:i];
                double unitCost = [Tool doubleValue:[material objectForKey:@"unitCost"]];
                if (unitCost) {
                    NSString *color = [kColorList objectAtIndex:i];
                    NSString *name = [material objectForKey:@"name"];
                    NSString *value = [NSString stringWithFormat:@"%.2f",unitCost];
                    NSDictionary *data = @{@"name":name,@"value":value,@"color":color};
                    [dataArray addObject:data];
                }
            }
            NSString *pieData = [Tool objectToString:dataArray];
            NSString *title = @"直接材料成本";
            NSDictionary *configDict = @{@"title":title,@"height":[NSNumber numberWithFloat:self.webView.frame.size.height],@"width":[NSNumber numberWithFloat:self.webView.frame.size.width]};
            NSString *js = [NSString stringWithFormat:@"drawPie2D('%@','%@')",pieData,[Tool objectToString:configDict]];
            DDLogVerbose(@"dates is %@",js);
            [webView stringByEvaluatingJavaScriptFromString:js];
        }
    }
    self.webView.hidden = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setWebView:nil];
    [self setBottomView:nil];
    [super viewDidUnload];
}

#pragma mark 自定义公共VC
-(void)responseCode0WithData{
    [self.webView reload];
    [self setBottomViewOfSubView];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.scrollView.hidden = NO;
    });
}

-(void)responseWithOtherCode{
    [super responseWithOtherCode];
}

-(void)setRequestParams{
    NSDictionary *timeInfo = [Tool getTimeInfo:self.condition.timeType];
    self.reportTitlePre = [timeInfo objectForKey:@"timeDesc"];
    NSString *comparison = nil;
    if (self.type==1) {
        comparison=@"环比";
    }else{
        comparison=@"同比";
    }
    self.titleView.lblTimeInfo.text = [self.reportTitlePre stringByAppendingString:comparison];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"startTime"] longLongValue]] forKey:@"startTime"];
    [self.request setPostValue:[NSNumber numberWithLongLong:[[timeInfo objectForKey:@"endTime"] longLongValue]] forKey:@"endTime"];;
    [self.request setPostValue:[NSNumber numberWithLong:self.condition.lineID] forKey:@"lineId"];
    [self.request setPostValue:[NSNumber numberWithLong:self.condition.productID] forKey:@"productId"];
    [self.request setPostValue:[NSNumber numberWithInt:self.type] forKey:@"period"];//0:当期   1:上期   2:同期
    
}
-(void)clear{
    self.scrollView.hidden = YES;
}
@end
