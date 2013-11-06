//
//  ChoiceCell.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-30.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "ChoiceCell.h"

@implementation ChoiceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.lblName = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 250, 30)];
        self.lblName.backgroundColor = [UIColor clearColor];
        self.imgChecked = [[UIImageView alloc] initWithFrame:CGRectMake(270, 7, 30, 30)];
        self.imgChecked.backgroundColor = [UIColor clearColor];
        self.imgChecked.image = [UIImage imageNamed:@"checked"];
        self.imgChecked.hidden = YES;
        [self addSubview:self.lblName];
        [self addSubview:self.imgChecked];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
