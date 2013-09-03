//
//  Tool.m
//  CustomerSystem
//
//  Created by wzg on 13-4-22.
//  Copyright (c) 2013年 denglei. All rights reserved.
//

#import "Tool.h"

@implementation Tool

+ (void)cancelRequest:(ASIHTTPRequest *)request
{
    if (request != nil) {
        [request cancel];
        [request clearDelegatesAndCancel];
    }
}

+(NSString *)timeIntervalToString:(NSTimeInterval)interval dateformat:(NSString *)dateformat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateformat];
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]];
}

+ (NSString *)secondsToHour:(long) second{
    if (second==0) {
        return @"---";
    }else{
        return [NSString stringWithFormat:@"%.1f小时",second/3600.0];
    }
}

//2013第一季度得到起止日期
+ (SearchDate *)getSeachDateByYear:(NSUInteger)year quarter:(NSUInteger)quarter
{
    SearchDate *searchDate = [[SearchDate alloc] initWithBeginDate:@"" endDate:@""];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    [comps setQuarter:quarter];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:comps];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"Date%@", [dateFormatter stringFromDate:date]);
    return searchDate;
}

//2013年起止日期

+ (SearchDate *)getSeachDateByYear:(NSUInteger)year
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    SearchDate *searchDate = [[SearchDate alloc] initWithBeginDate:@"" endDate:@""];
    return searchDate;
}


+ (NSDictionary *)stringToDictionary:(NSString *)str{
    DDLogVerbose(@"response str is \n%@",str);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

+ (NSString *)objectToString:(NSObject *)object {
    // isValidJSONObject判断对象是否可以构建成json对象
    if ([NSJSONSerialization isValidJSONObject:object])
    {
        NSError *error;
        // 创造一个json从Data, NSJSONWritingPrettyPrinted指定的JSON数据产的空白，使输出更具可读性。
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSMutableString *responseString = [NSMutableString stringWithString:json];
        NSString *character = nil;
        for (int i = 0; i < responseString.length; i ++) {
            character = [responseString substringWithRange:NSMakeRange(i, 1)];
            if ([character isEqualToString:@"\n"])
                [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
        }
        return responseString;
    }
    return @"";
}

+ (double)objectToDouble:(id)d{
    if(d==[NSNull null]){
        return 0.f;
    }
    return [d doubleValue];
}
@end
