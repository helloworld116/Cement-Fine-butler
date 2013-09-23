//
//  RawMaterialsCostManagerViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-17.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RawMaterialsCostManagerViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
- (IBAction)showSearch:(id)sender;
- (IBAction)moreAction:(id)sender;

@end
