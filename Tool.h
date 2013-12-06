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

+(int)max:(double)max;

+(int)min:(double)min;

+(BOOL)isNullOrNil:(id)object;

+(NSString *)setTimeInt:(NSTimeInterval)timeSeconds setTimeFormat:(NSString *)timeFormatStr setTimeZome:(NSString *)timeZoneStr;

+(int)getMaxValueInNumberValueArray:(NSArray *)array;

+(int)getMinValueInNumberValueArray:(NSArray *)array;

//+(long long)timeBeginIntervalByType:(int)type;
//
//+(long long)timeEndIntervalByType:(int)type;

+(NSDictionary *)getTimeInfo:(int)timeType;

//+(NSDictionary *)getTimeInfoFromUserDefault:(int)timeType;

+(NSString *)longTimeToTimeDesc:(long)time;

+(NSString *)stringToString:(NSString *)str;

+(long)longValue:(id)value;

+(int)intValue:(id)value;

+(double)doubleValue:(id)value;

+(float)floatValue:(id)value;

+(NSString *)equipmentType:(NSString *)code;

+(UIImage *)createImageWithColor:(UIColor *) color;
@end
