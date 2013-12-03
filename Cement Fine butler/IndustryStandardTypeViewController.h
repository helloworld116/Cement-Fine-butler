//
//  IndustryStandardTypeViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-3.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"

@interface IndustryStandardTypeViewController : UITableViewController
@property(nonatomic,assign) NSObject<PassValueDelegate> *delegate;
@property(nonatomic,assign) NSInteger typeId;//1标准成本、2煤业界均耗、3电业界均耗
@end
