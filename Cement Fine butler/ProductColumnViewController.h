//
//  ProductColumnViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-3.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductColumnViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *topContainerView;
@property (strong, nonatomic) IBOutlet UIWebView *bottomWebiew;
- (IBAction)showNav:(id)sender;

- (IBAction)showSearchCondition:(id)sender;
@end
