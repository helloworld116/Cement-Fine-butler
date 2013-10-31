//
//  FixcostCell.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-31.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "FixcostCell.h"

@implementation FixcostCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 30)];
        self.lblName.textAlignment=UITextAlignmentCenter;
        self.lblName.font = [UIFont systemFontOfSize:15];
        self.lblName.backgroundColor = [UIColor clearColor];
        
        self.lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(110, 15, 100, 30)];
        self.lblPrice.textAlignment=UITextAlignmentCenter;
        self.lblPrice.font = [UIFont systemFontOfSize:15];
        self.lblPrice.backgroundColor = [UIColor clearColor];
        
        self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(205, 15, 95, 30)];
        self.lblDate.textAlignment = UITextAlignmentCenter;
        self.lblDate.font = [UIFont systemFontOfSize:15];
        self.lblDate.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.lblName];
        [self addSubview:self.lblPrice];
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
