//
//  RawMaterialsCalViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-14.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RawMaterialsCalViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *directUnitCost;
@property (strong, nonatomic) IBOutlet UILabel *planUnitCost;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
