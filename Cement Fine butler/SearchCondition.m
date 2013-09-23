
//
//  SearchCondition.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-9-23.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "SearchCondition.h"

@implementation SearchCondition
-(id)initWithInventoryType:(int)inventoryType timeType:(int)timeType lineID:(long)lineID productID:(long)productID{
    self = [super init];
    if (self) {
        self.inventoryType=inventoryType;
        self.timeType=timeType;
        self.lineID=lineID;
        self.productID=productID;
    }
    return self;
}
@end
