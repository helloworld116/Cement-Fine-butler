//
//  InventoryCommonCell.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "InventoryCommonCell.h"

@implementation InventoryCommonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 30)];
        self.lblName.textAlignment=UITextAlignmentCenter;
        self.lblName.font = [UIFont systemFontOfSize:15];
        self.lblName.backgroundColor = [UIColor clearColor];
        
        self.lblInventory = [[UILabel alloc] initWithFrame:CGRectMake(110, 15, 100, 30)];
        self.lblInventory.textAlignment=UITextAlignmentCenter;
        self.lblInventory.font = [UIFont systemFontOfSize:15];
        self.lblInventory.backgroundColor = [UIColor clearColor];
        
        self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(210, 15, 100, 30)];
        self.lblDate.textAlignment = UITextAlignmentCenter;
        self.lblDate.font = [UIFont systemFontOfSize:15];
        self.lblDate.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.lblName];
        [self addSubview:self.lblInventory];
        [self addSubview:self.lblDate];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
