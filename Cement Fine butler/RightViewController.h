//
//  RightViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-8-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kOrignX 60

@interface RightViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (retain,nonatomic) NSArray *conditions;
- (IBAction)search:(id)sender;
@end