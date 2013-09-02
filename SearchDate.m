//
//  SearchDate.m
//  CustomerSystem
//
//  Created by wzg on 13-4-23.
//  Copyright (c) 2013年 denglei. All rights reserved.
//

#import "SearchDate.h"

@implementation SearchDate

-(id)initWithBeginDate:(NSString *)beginDate endDate:(NSString *)endDate{
    SearchDate *searchDate = [[SearchDate alloc] init];
    if (searchDate!=nil) {
        searchDate.benginDate = beginDate;
        searchDate.endDate = endDate;
    }
    return searchDate;
}
@end
