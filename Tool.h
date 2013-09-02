//
//  Tool.h
//  CustomerSystem
//
//  Created by wzg on 13-4-22.
//  Copyright (c) 2013年 denglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchDate.h"

@interface Tool : NSObject

+ (void)cancelRequest:(ASIHTTPRequest *)request;

+ (SearchDate *)getSeachDateByYear:(NSUInteger)year quarter:(NSUInteger)quarter;

+ (SearchDate *)getSeachDateByYear:(NSUInteger)year;

+ (NSDictionary *)stringToDictionary:(NSString *) str;

+ (NSString *)timeIntervalToString:(NSTimeInterval) interval dateformat:(NSString *)dateformat;

+ (NSString *)secondsToHour:(long) second;

+ (NSString *)objectToString:(NSObject *)object;

+ (double)objectToDouble:(id)d;
@end
