//
//  TimeTableView.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-21.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) NSArray *conditon;
@property (nonatomic) NSUInteger currentSelectCellIndex;

-(id)initWithCondition:(NSArray *)condition andCurrentSelectCellIndex:(NSUInteger)currentSelectCellIndex;
@end
