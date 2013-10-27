//
//  ElectricityCell.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-25.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "ElectricityCell.h"

@implementation ElectricityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier containingTableView:containingTableView leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons];
    if (self) {
        self.lblElectricityPrice = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 120, 30)];
        self.lblElectricityPrice.textAlignment=UITextAlignmentCenter;
        self.lblElectricityPrice.font = [UIFont systemFontOfSize:15];
        self.lblElectricityPrice.backgroundColor = [UIColor clearColor];
        
        self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(180, 15, 120, 30)];
        self.lblDate.textAlignment = UITextAlignmentCenter;
        self.lblDate.font = [UIFont systemFontOfSize:15];
        self.lblDate.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.lblElectricityPrice];
        [self.contentView addSubview:self.lblDate];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
