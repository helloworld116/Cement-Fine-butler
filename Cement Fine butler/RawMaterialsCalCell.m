//
//  RawMaterialsCalCell.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-10-14.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "RawMaterialsCalCell.h"

@implementation RawMaterialsCalCell

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

//- (BOOL)isLocked{
//    return self.isLocked;
//}
//
//-(void)setIsLocked:(BOOL)locked{
//    self.isLocked = locked;
//    if (locked) {
//        self.imgLockState.image = [UIImage imageNamed:@"lock-small"];
//    }else{
//        self.imgLockState.image = [UIImage imageNamed:@"unlock-small"];
//    }
//}
@end
