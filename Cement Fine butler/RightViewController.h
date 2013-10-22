//
//  RightViewController.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-8-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeTableView.h"
#define kOrignX 60

@interface RightViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (nonatomic,retain) TimeTableView *timeTableView;
@property (nonatomic,retain) NSDictionary *currentSelectDict;//{kCondition_Time:2,kCondition_Lines:0,kCondition_Products:0,kCondition_StockType:0,kCondition_UnitCostType:0}
@property (retain,nonatomic) NSArray *conditions;
- (IBAction)search:(id)sender;
- (void)resetConditions:(NSArray *)conditions;
@end