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

//12800经过运算后得到13000
+(double)max:(double)max{
    double newMax=max;
    long multiple = 1;
    while(newMax/10>1){
        newMax/=10;
        multiple*=10;
    }
//    newMax = [[[NSString stringWithFormat:@"%.1f", newMax] substringToIndex:3] doubleValue];
    newMax = [[[NSString stringWithFormat:@"%f",newMax] substringToIndex:3] doubleValue];
    if (newMax*multiple!=max) {
        if (newMax>1.0) {
            newMax+=0.1;
        }
        newMax*=multiple;
    }else{
        newMax = max;
    }
    return newMax;
}

//12800经过运算后得到10000
+(double)min:(double)min{
    double newMin=min;
    long multiple = 1;
    while(newMin/10>1){
        newMin/=10;
        multiple*=10;
    }
    newMin = [[[NSString stringWithFormat:@"%f",newMin] substringToIndex:3] doubleValue];
    if (newMin*multiple!=min) {
        if (newMin>1.0) {
            newMin-=0.1;
        }
        newMin*=multiple;
    }else{
        newMin = min;
    }
    return newMin;
}

+(BOOL)isNullOrNil:(id)object{
    return !object||(NSNull *)object==[NSNull null];
}

/**
 格式化时间
 timeSeconds 为0时表示当前时间,可以传入你定义的时间戳
 timeFormatStr为空返回当当时间戳,不为空返回你写的时间格式(yyyy-MM-dd HH:ii:ss)
 setTimeZome ([NSTimeZone systemTimeZone]获得当前时区字符串)
 用法：
 NSString *a =[self setTimeInt:1317914496 setTimeFormat:@"yy.MM.dd HH:mm:ss" setTimeZome:nil];
 NSString *b =[self setTimeInt:0 setTimeFormat:@"yy.MM.dd HH:mm:ss" setTimeZome:nil];
 NSString *c =[self setTimeInt:0 setTimeFormat:nil setTimeZome:nil];
 NSString *d =[self setTimeInt:0 setTimeFormat:@"yy.MM.dd HH:mm:ss" setTimeZome:@"GMT"];
 */
+(NSString *)setTimeInt:(NSTimeInterval)timeSeconds setTimeFormat:(NSString *)timeFormatStr setTimeZome:(NSString *)timeZoneStr{
    NSString *date_string;
    NSDate *time_str;
    if( timeSeconds>0){
        time_str =[NSDate dateWithTimeIntervalSince1970:timeSeconds];
    }else{
        time_str=[[NSDate alloc] init];
    }
    if( timeFormatStr==nil){
        date_string =[NSString stringWithFormat:@"%ld",(long)[time_str timeIntervalSince1970]];
    }else{
        NSDateFormatter *date_format_str =[[NSDateFormatter alloc] init];
        [date_format_str setDateFormat:timeFormatStr];
        if( timeZoneStr!=nil){
            [date_format_str setTimeZone:[NSTimeZone timeZoneWithName:timeZoneStr]];
        }
        date_string =[date_format_str stringFromDate:time_str];
    }
    return date_string;
}

+(double)getMaxValueInNumberValueArray:(NSArray *)array{
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
    NSArray *sortedNumbers = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    double max = [[sortedNumbers objectAtIndex:0] doubleValue];
    max = [self max:max];
    return max;
}

+(double)getMinValueInNumberValueArray:(NSArray *)array{
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
    NSArray *sortedNumbers = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    double min = [[sortedNumbers objectAtIndex:(array.count-1)] doubleValue];
    min = [self min:min];
    return min;
}


//0本年，1本季，2本月，3本日，4自定义时间段
+(long long)timeBeginIntervalByType:(int)type year:(int)year month:(int)month day:(int)day{
    if (type!=4) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
        day = [components day];
        month = [components month];
        year = [components year];
    }
    switch (type) {
        //年
        case 0:
            day=1;
            month=1;
            break;
        //季度
        case 1:
            day=1;
            if (month<=3) {
                month=1;
            }else if(month<=6){
                month=4;
            }else if(month<=9){
                month=7;
            }else if(month<=12){
                month=10;
            }
            break;
        //月
        case 2:
            day=1;
            break;
    }
    NSString *dateString = [NSString stringWithFormat:@"%d-%d-%d 00:00:00",year,month,day];
    NSDate *date = [self stringToDate:@"yyyy-MM-dd HH:mm:s" dateString:dateString];
    return (long long)[date timeIntervalSince1970]*1000;

}

+(long long)timeEndIntervalByType:(int)type year:(int)year month:(int)month day:(int)day{
    if (type!=4) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
        day = [components day];
        month = [components month];
        year = [components year];
    }
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    switch (type) {
        case 0:
            [comps setMonth:12];
            month=12;
            break;
        case 1:
            if (month<=3) {
                [comps setMonth:3];
                month=3;
            }else if(month<=6){
                [comps setMonth:6];
                month=6;
            }else if(month<=9){
                [comps setMonth:9];
                month=9;
            }else if(month<=12){
                [comps setMonth:12];
                month=12;
            }
            break;
        case 2:
            [comps setMonth:month];
            break;
    }
  
    NSDate *date = [gregorian dateFromComponents:comps];
    NSRange daysRange = [gregorian rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    if (type==0||type==1||type==2) {
        day=daysRange.length;
    }
    NSString *dateString = [NSString stringWithFormat:@"%d-%d-%d 23:59:59",year,month,day];
    NSDate *odate = [self stringToDate:@"yyyy-MM-dd HH:mm:s" dateString:dateString];
    return (long long)[odate timeIntervalSince1970]*1000;
}

+(NSDate *)stringToDate:(NSString *)formatter dateString:(NSString *)dateString{
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:dateString];
}

+(NSDictionary *)getTimeInfo:(int)timeType{
    NSString *timeDesc;
    int day,month,year;
    int beginDay=0,beginMonth=0,beginYear=0;
    int endDay=0,endMonth=0,endYear=0;
    if (timeType!=4) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
        day = [components day];
        month = [components month];
        year = [components year];
    }else{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *startDate = [userDefaults objectForKey:@"startDate"];
        beginDay = [[startDate objectForKey:@"day"] intValue];
        beginMonth = [[startDate objectForKey:@"month"] intValue];
        beginYear = [[startDate objectForKey:@"year"] intValue];
        
        NSDictionary *endDate = [userDefaults objectForKey:@"endDate"];
        endDay = [[endDate objectForKey:@"day"] intValue];
        endMonth = [[endDate objectForKey:@"month"] intValue];
        endYear = [[endDate objectForKey:@"year"] intValue];
    }
    switch (timeType) {
        case 0:
            timeDesc = [NSString stringWithFormat:@"%d年",year];
            break;
        case 1:
            if (month<=3) {
                month=1;
            }else if(month<=6){
                month=2;
            }else if(month<=9){
                month=3;
            }else if(month<=12){
                month=4;
            }
            timeDesc = [NSString stringWithFormat:@"%d年%d季度",year,month];
            break;
        case 2:
            timeDesc = [NSString stringWithFormat:@"%d年%d月份",year,month];
            break;
        case 3:
            timeDesc = [NSString stringWithFormat:@"%d年%d月%d日",year,month,day];
            break;
        case 4:
            timeDesc = [NSString stringWithFormat:@"%d年%d月%d日至%d年%d月%d日",beginYear,beginMonth,beginDay,endYear,endMonth,endDay];
            break;
    }
    long long startTime = [self timeBeginIntervalByType:timeType year:beginYear month:beginMonth day:beginDay];
    long long endTime = [self timeEndIntervalByType:timeType year:endYear month:endMonth day:endDay];
    return @{@"timeDesc":timeDesc,@"startTime":[NSNumber numberWithLongLong:startTime],@"endTime":[NSNumber numberWithLongLong:endTime]};
}

//+(NSDictionary *)getTimeInfoFromUserDefault:(int)timeType{
//    NSString *timeDesc;
//    int day=0,month=0,year=0;
//    int beginDay=0,beginMonth=0,beginYear=0;
//    int endDay=0,endMonth=0,endYear=0;
//    if (timeType!=4) {
//        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
//        day = [components day];
//        month = [components month];
//        year = [components year];
//    }else{
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        NSDictionary *startDate = [userDefaults objectForKey:@"startDate"];
//        beginDay = [[startDate objectForKey:@"day"] intValue];
//        beginMonth = [[startDate objectForKey:@"month"] intValue];
//        beginYear = [[startDate objectForKey:@"year"] intValue];
//        
//        NSDictionary *endDate = [userDefaults objectForKey:@"endDate"];
//        endDay = [[endDate objectForKey:@"day"] intValue];
//        endMonth = [[endDate objectForKey:@"month"] intValue];
//        endYear = [[endDate objectForKey:@"year"] intValue];
//    }
//    NSCalendar *gregorian = [[NSCalendar alloc]
//                             initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    [comps setYear:year];
//    switch (timeType) {
//        case 0:
//            timeDesc = [NSString stringWithFormat:@"%d年",year];
//            break;
//        case 1:
//            if (month<=3) {
//                month=1;
//            }else if(month<=6){
//                month=2;
//            }else if(month<=9){
//                month=3;
//            }else if(month<=12){
//                month=4;
//            }
//            timeDesc = [NSString stringWithFormat:@"%d年%d季度",year,month];
//            break;
//        case 2:
//            timeDesc = [NSString stringWithFormat:@"%d年%d月份",year,month];
//            break;
//        case 3:
//            timeDesc = [NSString stringWithFormat:@"%d年%d月%d日",year,month,day];
//            break;
//        case 4:
//            timeDesc = [NSString stringWithFormat:@"%d年%d月%d日至%d年%d月%d日",beginYear,beginMonth,beginDay,endYear,endMonth,endDay];
//            break;
//    }
//    return @{@"timeDesc":timeDesc,@"startTime":[NSString stringWithFormat:@"%d-%d-%d",beginYear,beginMonth,beginDay],@"endTime":[NSString stringWithFormat:@"%d-%d-%d",endYear,endMonth,endDay]};
//}

+(NSString *)longTimeToTimeDesc:(long)time{
    if (time!=0) {
        int day,hour,minute,second;
        day = time/(3600*24);
        hour = (time-day*3600*24)/3600;
        minute = (time-day*3600*24-hour*3600)/60;
        second = time-day*3600*24-hour*3600-minute*60;
        NSMutableString *timeDesc = [[NSMutableString alloc] init];
        if (day!=0) {
            [timeDesc appendFormat:@"%d天",day];
        }
        if (hour!=0) {
            [timeDesc appendFormat:@"%d小时",hour];
        }
        if (minute!=0) {
            [timeDesc appendFormat:@"%d分钟",minute];
        }
        if (second!=0) {
            [timeDesc appendFormat:@"%d秒",second];
        }
        return timeDesc;
    }else{
        return @"0";
    }
}

+(NSString *)stringToString:(NSString *)str{
    if ([[NSNull null] isEqual:str]||str==nil) {
        return @"";
    }else{
        return str;
    }
}

+(long)longValue:(id)value{
    if ([[NSNull null] isEqual:value]||value==nil){
        return 0;
    }else{
        return [value longValue];
    }
}

+(int)intValue:(id)value{
    if ([[NSNull null] isEqual:value]||value==nil){
        return 0;
    }else{
        return [value intValue];
    }
}

+(double)doubleValue:(id)value{
    if ([[NSNull null] isEqual:value]||value==nil){
        return 0;
    }else{
        return [value doubleValue];
    }
}

+(float)floatValue:(id)value{
    if ([[NSNull null] isEqual:value]||value==nil){
        return 0;
    }else{
        return [value floatValue];
    }
}

+(NSString *)equipmentType:(NSString *)code{
    NSString *type = nil;
    if ([@"010" isEqualToString:code]) {
        type = @"双托辊电子皮带秤";
    }else if ([@"020" isEqualToString:code]){
        type = @"定量给料机";
    }else if ([@"030" isEqualToString:code]){
        type = @"科里奥利粉体定量给料秤";
    }else if ([@"040" isEqualToString:code]){
        type = @"连续式失重秤";
    }
    return type;
}

+(UIImage *)createImageWithColor:(UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

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
@end
