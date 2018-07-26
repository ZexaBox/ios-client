//
//  LoginViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/26.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "NSString+CheckString.h"
#import "URLRequest.h"
#import "CountdownTool.h"
#import "NavigationController.h"
#import "MainCenterViewController.h"
#import "NSString+iOSVersion.h"
#import "UserReadViewController.h"
@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnRegist;
@property (weak, nonatomic) IBOutlet UIButton *btnRead;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSMS;
@property (nonatomic,strong) NSString *stringCode;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void) setupUI{
    self.btnRegist.layer.borderWidth = 1.0;
    self.btnRegist.layer.borderColor = MainColor.CGColor;
    self.btnRead.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.labelTitle.text = [@"登录" language];
    
    [self.btnLogin setTitle:[@"登录" language] forState:UIControlStateNormal];
    self.txtPhone.placeholder = [@"请输入手机号码" language];
    self.txtCode.placeholder = [@"请输入验证码" language];
    [self.btnSMS setTitle:[@"获取验证码" language] forState:UIControlStateNormal];
    [self.btnRegist setTitle:[@"注册" language] forState:UIControlStateNormal];
    [self.btnRead setTitle:[@" 我已经阅读并同意用户协议" language] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)read_action:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (IBAction)regist_action:(UIButton *)sender {
//    [self presentViewController:[RegistViewController new] animated:YES completion:nil];
    [self.navigationController pushViewController:[RegistViewController new] animated:YES];
}
- (IBAction)sms_action:(id)sender {
    if(![self.txtPhone.text isPhoneNum]){
        [FaceAlertTool svpShowErrorWithMsg:@"请输入正确的手机号码"];
        return;
    }
    
    [FaceAlertTool svpShowWithState:@"验证码发送中..."];

}
- (IBAction)login_action:(id)sender {
    
    if(![self.txtPhone.text isPhoneNum]){
        [FaceAlertTool svpShowErrorWithMsg:@"请输入正确的手机号码"];
        return;
    }
    
    if([self.txtCode.text isEqualToString:@""]){
        [FaceAlertTool svpShowErrorWithMsg:@"请输入验证码"];
        return;
    }
    
    if(![self.txtCode.text isEqualToString:self.stringCode]){
        [FaceAlertTool svpShowErrorWithMsg:@"您输入的验证码不正确"];
        return;
    }
    
    if(self.btnRead.selected == NO){
        [FaceAlertTool svpShowErrorWithMsg:@"请先阅读并同意用户协议"];
        return;
    }
  ceAlertTool svpShowErrorWithMsg:@"服务器请求失败"];
        }
    }];
    
}

/** 倒计时 */
- (void) timerStart{
    
    self.btnSMS.userInteractionEnabled = NO;
    /** 倒计时 */
    CountdownTool *down = [[CountdownTool alloc] init];
    [down timerStatrWithCountdown:60 Speed:1];
    down.callBackCountdown = ^(NSInteger countdown) {
        [self.btnSMS setTitle:[NSString stringWithFormat:@"%ld",countdown] forState:UIControlStateNormal];
        if(countdown == 0){
            [self.btnSMS setTitle:[@"获取验证码" language] forState:UIControlStateNormal];
            self.btnSMS.userInteractionEnabled = YES;
        }
    };
}

- (IBAction)user_read_action:(id)sender {
    [self.navigationController pushViewController:[UserReadViewController new] animated:YES];
}
@end
