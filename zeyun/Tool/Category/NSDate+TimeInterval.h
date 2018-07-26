//
//  NSDate+TimeInterval.h
//  HengQin
//
//  Created by YH_O on 2016/12/11.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TimeInterval)

/**
 某个日期与当前日期的间隔

 @param fromDate 指定的某一个时间

 @return 日期间隔各部分 (yyyy,MM,dd,HH,mm,ss)
 */
- (NSDateComponents *)dateIntervalFromDate:(NSDate *)fromDate;

+ (NSString *)getDateStrWithDate:(NSDate *)date;

+ (NSString *)getCurrentDateString;

+ (NSString *)getDateWithTotalSeconds:(NSTimeInterval)totalSeconds;

/** 获取时间戳 */
+ (NSString *) timestamp;

/**
 根据秒数，转换成为时间格式

 @param totalSeconds 总共的秒数

 @return 时间格式字符串
 */
+ (NSString *)getSpecificDateWithTotalSeconds:(NSTimeInterval)totalSeconds;
+ (NSString *)getSpecificDateWithTotalSecondsSort:(NSTimeInterval)totalSeconds;

/**
 比较当前的时间和另一个时间的大小

 @param date 比较的时间
 @param formatter 时间格式
 @return 是否大于比较的时间
 */
+ (BOOL)currentDateGreaterThanOtherDate:(NSString *)dateStr formatter:(NSString *)formatter;








@end
