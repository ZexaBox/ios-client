//
//  UIViewController+Alert.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/27.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)


- (void)alert:(UIViewController *)controller{
    controller.view.frame = [UIScreen mainScreen].bounds;
    controller.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:controller.view];
    [[UIApplication sharedApplication].keyWindow.rootViewController addChildViewController:controller];
}
@end
