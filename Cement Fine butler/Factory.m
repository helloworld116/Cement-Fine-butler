//
//  Factory.m
//  Cement Fine butler
//
//  Created by 文正光 on 13-12-4.
//  Copyright (c) 2013年 河南丰博自动化有限公司. All rights reserved.
//

#import "Factory.h"

@implementation Factory
+(NSArray *)allLines{
    NSArray *lines = [kSharedApp.factory objectForKey:@"lines"];
    NSMutableArray *lineArray = [NSMutableArray arrayWithObject:@{@"name":@"全部",@"_id":[NSNumber numberWithInt:0]}];
    for (NSDictionary *line in lines) {
        NSString *name = [line objectForKey:@"name"];
        NSNumber *_id = [NSNumber numberWithLong:[[line objectForKey:@"id"] longValue]];
        NSDictionary *dict = @{@"_id":_id,@"name":name};
        [lineArray addObject:dict];
    }
    return lineArray;
}

+(NSArray *)allProducts{
    NSArray *products = [kSharedApp.factory objectForKey:@"products"];
    NSMutableArray *productArray = [NSMutableArray arrayWithObject:@{@"name":@"全部",@"_id":[NSNumber numberWithInt:0]}];
    for (NSDictionary *product in products) {
        NSString *name = [product objectForKey:@"name"];
        NSNumber *_id = [NSNumber numberWithLong:[[product objectForKey:@"id"] longValue]];
        NSDictionary *dict = @{@"_id":_id,@"name":name};
        [productArray addObject:dict];
    }
    return productArray;
}
@end
