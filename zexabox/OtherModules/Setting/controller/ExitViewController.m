//
//  ExitViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ExitViewController.h"
#import "URLRequest.h"
#import "LoginPwdViewController.h"
#import "NSString+iOSVersion.h"
#import "NavigationController.h"
@interface ExitViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnExit;
@end

@implementation ExitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.btnCancel setTitle:[@"注销账号" language] forState:UIControlStateNormal];
    [self.btnExit setTitle:[@"安全退出" language] forState:UIControlStateNormal];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (IBAction)safe_exit:(UIButton *)sender {
    [FaceAlertTool createSelectAlertWithTitle:@"提示" message:@"确定退出" inViewController:self sure:^{
        [UserInfoManager manager].account = @"";
        [UserInfoManager manager].avatar = @"";
        [UserInfoManager manager].token = @"";
        [[UserInfoManager manager] writeToFile];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[NavigationController alloc] initWithRootViewController:[LoginPwdViewController new]];
    }];
    
}

@end
