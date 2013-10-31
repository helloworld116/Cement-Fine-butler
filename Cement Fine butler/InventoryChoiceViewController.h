//
//  InventoryChoiceViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-30.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryPassValueDelegate.h"


@interface InventoryChoiceViewController : UITableViewController
@property (nonatomic) int type;
@property (nonatomic) int inventoryId;
@property(nonatomic,assign) NSObject<InventoryPassValueDelegate> *delegate;
@end
