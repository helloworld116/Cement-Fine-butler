//
//  UIColor+Random.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-4.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "UIColor+Random.h"

@implementation UIColor (Random)
+(UIColor *)randomColor{
    static BOOL seed = NO;
    if (!seed) {
        seed = YES;
        srandom(time(NULL));
    }
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];//alpha为1.0,颜色完全不透明
}

+(NSString *)randomColorString{
    static BOOL seed = NO;
    if (!seed) {
        seed = YES;
        srandom(time(NULL));
    }
    CGFloat rFloat = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat gFloat = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat bFloat = (CGFloat)random()/(CGFloat)RAND_MAX;
    int r = (int)(255.0 * rFloat);
    int g = (int)(255.0 * gFloat);
    int b = (int)(255.0 * bFloat);
    return [NSString stringWithFormat:@"#%02x%02x%02x",r,g,b];
}
@end
