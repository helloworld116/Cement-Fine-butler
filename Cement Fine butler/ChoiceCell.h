//
//  ChoiceCell.h
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-30.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoiceCell : UITableViewCell
@property (nonatomic,retain) UILabel *lblName;
@property (nonatomic,retain) UIImageView *imgChecked;
@property (nonatomic) int *inventoryId;
@end
