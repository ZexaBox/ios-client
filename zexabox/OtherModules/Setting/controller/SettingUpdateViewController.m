//
//  SettingUpdateViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "SettingUpdateViewController.h"

@interface SettingUpdateViewController ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@end

@implementation SettingUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
