//
//  MessageCell.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-28.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setlblTitleText:(NSString *)title{
    CGSize size = [title sizeWithFont:self.lblTitle.font constrainedToSize:CGSizeMake(MAXFLOAT, self.lblTitle.frame.size.height)];
    [self.lblTitle setFrame:CGRectMake(self.lblTitle.frame.origin.x, self.lblTitle.frame.origin.y, size.width, self.lblTitle.frame.size.height)];
    self.lblTitle.text = title;
    [self.lblTime setFrame:CGRectMake(self.lblTitle.frame.origin.x+size.width+10, self.lblTime.frame.origin.y, kScreenWidth-(self.lblTitle.frame.origin.x+size.width+10), self.lblTime.frame.size.height)];
}

@end
