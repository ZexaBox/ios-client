//
//  CountdownTool.m
//  UBaby
//
//  Created by bolo-mac mini2 on 2017/8/9.
//  Copyright © 2017年 fengei. All rights reserved.
//

#import "CountdownTool.h"

@interface CountdownTool()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger time;

@end

@implementation CountdownTool

- (void)timerStatrWithCountdown:(NSInteger)countdown Speed:(CGFloat)speed{
    self.time = countdown;
//    self.timer.preferredFramesPerSecond = speed;
    self.timer = [NSTimer timerWithTimeInterval:speed target:self selector:@selector(setCountdownTime) userInfo:nil repeats:YES];
    //将定时器添加到单个动画循环
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)setCountdownTime {
    self.time--;
    if (self.time < 0) {
//        self.timer.paused = YES;
        [self stopTimer];
        return;
    }
    if (self.callBackCountdown) {
        self.callBackCountdown(self.time);
    }
}

- (void)setTime:(NSInteger)time {
    _time = time;
//    self.timer.paused = NO;
    [self.timer fireDate];
}
- (void) stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}
//MARK:--------------------Getter--------------------//

//- (CADisplayLink *)timer {
//    if (!_timer) {
//        _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(setCountdownTime)];
//        _timer.paused = YES;
////        _timer.preferredFramesPerSecond = 1;
//        [_timer setPreferredFramesPerSecond:1];
//        [_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
//    }
//    return _timer;
//}

@end
