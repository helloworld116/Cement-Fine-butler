//
//  HistroyTrendsViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-21.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistroyTrendsViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (retain,nonatomic) NSArray *preViewControllerCondition;
@property (retain,nonatomic) NSDictionary *preSelectedDict;
//- (IBAction)back:(id)sender;

- (void)showSearch:(id)sender;
@end
