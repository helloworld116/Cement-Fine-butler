//
//  InventoryColumnViewController.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-7.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "InventoryColumnViewController.h"

@interface InventoryColumnViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *topContainerView;
@property (strong, nonatomic) IBOutlet UIWebView *bottomWebiew;

@property (retain,nonatomic) NSString *chartTitle;
@end

@implementation InventoryColumnViewController

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
    //最开始异步请求数据
    self.title = @"库存报表";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showNav:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchCondition:)];
    
    [(UIScrollView *)[[self.bottomWebiew subviews] objectAtIndex:0] setBounces:NO];//禁用上下拖拽
    self.bottomWebiew.delegate = self;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Column2D" ofType:@"html"];
    [self.bottomWebiew loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    UIScrollView *sc = (UIScrollView *)[[self.bottomWebiew subviews] objectAtIndex:0];
    sc.contentSize = CGSizeMake(self.bottomWebiew.frame.size.width, self.bottomWebiew.frame.size.height);
    sc.showsHorizontalScrollIndicator = NO;
    //    self.bottomWebiew.frame = CGRectMake(self.bottomWebiew.frame.origin.x, self.bottomWebiew.frame.origin.y, self.bottomWebiew.frame.size.width*2, self.bottomWebiew.frame.size.height);
    
    self.rightVC = [kSharedApp.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
    NSArray *stockType = @[@{@"_id":[NSNumber numberWithInt:0],@"name":@"原材料库存"},@{@"_id":[NSNumber numberWithInt:1],@"name":@"成品库存"}];
    self.rightVC.conditions = @[@{@"库存类型":stockType}];

    self.leftVC = [self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"];
    NSArray *reportType = @[@"产量报表",@"库存报表"];
    self.leftVC.conditions = @[@{@"实时报表":reportType}];
    
    self.URL = kStockReportURL;
    [self sendRequest];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTopContainerView:nil];
    [self setBottomWebiew:nil];
    [self setScrollView:nil];
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
    if (self.data) {
        NSArray *stockArray = [self.data objectForKey:@"materials"];
        if(stockArray.count>0){
            NSMutableArray *stocksForSort = [NSMutableArray array];
            NSMutableArray *stocks = [NSMutableArray array];
            for (int i=0;i<stockArray.count;i++) {
                NSDictionary *stock = [stockArray objectAtIndex:i];
                double value = [[stock objectForKey:@"stock"] doubleValue];
                NSString *name = [stock objectForKey:@"name"];
                NSString *color = [kColorList objectAtIndex:i];
                NSDictionary *reportDict = @{@"name":name,@"value":[NSNumber numberWithDouble:value],@"color":color};
                [stocks addObject:reportDict];
                [stocksForSort addObject:[NSNumber numberWithDouble:value]];
            }
            NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
            NSArray *sortedNumbers = [stocksForSort sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            double max = [[sortedNumbers objectAtIndex:0] doubleValue];
            max = [Tool max:max];
            NSDictionary *configDict = @{@"title":self.chartTitle,@"tagName":@"库存(吨)",@"height":[NSNumber numberWithFloat:self.bottomWebiew.frame.size.height],@"width":[NSNumber numberWithFloat:self.bottomWebiew.frame.size.width],@"start_scale":[NSNumber numberWithFloat:0],@"end_scale":[NSNumber numberWithFloat:max],@"scale_space":[NSNumber numberWithFloat:max/5]};
            NSString *js = [NSString stringWithFormat:@"drawColumn('%@','%@')",[Tool objectToString:stocks],[Tool objectToString:configDict]];
            [webView stringByEvaluatingJavaScriptFromString:js];
        }else{
            self.messageView.frame = self.view.frame;
            self.messageView.labelMsg.text = @"没有满足条件的数据！！！";
            self.messageView.hidden = NO;
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)err{
    
}
#pragma mark end webviewDelegate

- (void)showNav:(id)sender {
    [self.sidePanelController showLeftPanelAnimated:YES];
}

- (void)showSearchCondition:(id)sender {
    [self.sidePanelController showRightPanelAnimated:YES];
}

//#pragma mark 观察条件变化
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"searchCondition"]) {
//        SearchCondition *searchCondition = [change objectForKey:@"new"];
//        self.condition = @{@"inventoryType":[NSNumber numberWithInt:searchCondition.inventoryType]};
//        [self sendRequest];
//    }
//}

#pragma mark 自定义公共VC
-(void)responseCode0WithData{
    [self.bottomWebiew reload];
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
    int inventoryType = self.condition.inventoryType;
    [self.request setPostValue:[NSNumber numberWithInt:inventoryType] forKey:@"type"];
    if (inventoryType==0) {
        self.chartTitle = @"原材料库存";
    }else{
        self.chartTitle = @"成品库存";
    }
}
-(void)clear{
    self.scrollView.hidden = YES;
}
@end
