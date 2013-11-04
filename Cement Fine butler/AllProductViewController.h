//
//  AllProductViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-11-4.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"

@interface AllProductViewController : UITableViewController
@property(nonatomic,assign) NSObject<PassValueDelegate> *delegate;
@property (nonatomic) long productId;
@end
