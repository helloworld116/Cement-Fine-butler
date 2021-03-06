//
//  ProductHistoryUpdateViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"

@interface ProductHistoryUpdateViewController : UITableViewController
@property (nonatomic,retain) NSDictionary *productHistoryInfo;
@property(nonatomic,assign) NSObject<PassValueDelegate> *delegate;
@end
