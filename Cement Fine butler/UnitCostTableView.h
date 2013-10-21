//
//  UnitCostTableView.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-21.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConditionTableView.h"

@interface UnitCostTableView : ConditionTableView
-(id)initWithCondition:(NSArray *)condition andCurrentSelectCellIndex:(NSUInteger)currentSelectCellIndex;
@end
