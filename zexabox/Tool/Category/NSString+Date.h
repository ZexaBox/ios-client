//
//  NSString+Date.h
//  UBaby
//
//  Created by Bolo on 17/3/9.
//  Copyright © 2017年 fengei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)

//获取当前的时间
+ (NSString *)getCurrentTime;

//将字符串转成NSDate类型
- (NSDate *)dateFromString;

//传入今天的时间，返回明天的时间
+ (NSString *)GetTomorrowDay:(NSDate *)aDate count:(NSInteger)count;

- (NSString *)changeForMatter;//改变时间格式


+(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate;

@end
