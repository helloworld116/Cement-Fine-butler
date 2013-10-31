//
//  InventoryOperateViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-30.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryPassValueDelegate.h"

@interface InventoryOperateViewController : UITableViewController<InventoryPassValueDelegate>
@property (nonatomic) int type;//0原材料库存，1半成品库存，2成品库存
@property (nonatomic,retain) NSDictionary *inventoryInfo;
@property(nonatomic,assign) NSObject<InventoryPassValueDelegate> *delegate;
@end

