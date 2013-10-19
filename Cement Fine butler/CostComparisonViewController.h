//
//  CostComparisonViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-19.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

//成本对比
@interface CostComparisonViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,assign) int type;//1表示上期，2表示同期
@property (nonatomic,retain) NSArray *condition;
@end
