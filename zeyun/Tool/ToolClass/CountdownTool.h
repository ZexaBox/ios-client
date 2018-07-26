//
//  CountdownTool.h
//  UBaby
//
//  Created by bolo-mac mini2 on 2017/8/9.
//  Copyright © 2017年 fengei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountdownTool : NSObject

@property (nonatomic, copy) void (^callBackCountdown)(NSInteger countdown);

/**
 倒计时方法

 @param countdown 倒计总时时间（秒）
 @param speed 调用速度（秒）
 */
- (void)timerStatrWithCountdown:(NSInteger)countdown Speed:(CGFloat)speed;
@end
