//
//  NSDate+TimeInterval.m
//  HengQin
//
//  Created by YH_O on 2016/12/11.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "NSDate+TimeInterval.h"

@implementation NSDate (TimeInterval)

- (NSDateComponents *)dateIntervalFromDate:(NSDate *)fromDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *dateCmps = [calendar components:calendarUnit fromDate:fromDate toDate:self options:0];
    return dateCmps;
}

+ (NSString *)getCurrentDateString {
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    return dateString;
}

+ (NSString *)getCurrentStr {
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    return dateString;
}

/** 获取时间戳 */
+ (NSString *) timestamp{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *string = [NSString stringWithFormat:@"%d",(int)currentDate.timeIntervalSince1970];
    return string;
}

+ (NSString *)getDateStrWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getDateWithTotalSeconds:(NSTimeInterval)totalSeconds {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:totalSeconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getSpecificDateWithTotalSeconds:(NSTimeInterval)totalSeconds {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:totalSeconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getSpecificDateWithTotalSecondsSort:(NSTimeInterval)totalSeconds {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:totalSeconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormatter stringFromDate:date];
}

+ (BOOL)currentDateGreaterThanOtherDate:(NSString *)dateStr formatter:(NSString *)formatter {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    
    NSString *currentStr = [NSDate getCurrentStr];
    NSArray *dates = [currentStr componentsSeparatedByString:@" "];
    NSString *otherStr = [NSString stringWithFormat:@"%@ %@",[dates firstObject], dateStr];
    NSDate *currentDate = [dateFormatter dateFromString:currentStr];
    NSDate *otherDate = [dateFormatter dateFromString:otherStr];
    
    NSComparisonResult result = [currentDate compare:otherDate];
    if (result == NSOrderedSame) {
        return NO;
    } else if (result == NSOrderedDescending) {
        return YES;
    } else {
        return NO;
    }
}



















@end
