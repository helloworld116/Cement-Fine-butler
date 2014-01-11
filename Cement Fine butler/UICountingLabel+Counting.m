//
//  UICountingLabel+Counting.m
//  Cement Fine butler
//
//  Created by 文正光 on 14-1-11.
//  Copyright (c) 2014年 河南丰博自动化有限公司. All rights reserved.
//

#import "UICountingLabel+Counting.h"

@implementation UICountingLabel (Counting)
-(void)startFrom:(double)start end:(double)end{
    self.formatBlock = ^NSString* (float value)
    {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"###,##0.00"];
        return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:value]];
    };
    self.method = UILabelCountingMethodEaseOut;
    [self countFrom:0 to:end withDuration:1];
}
@end
