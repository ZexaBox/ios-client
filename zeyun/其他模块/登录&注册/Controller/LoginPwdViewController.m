//
//  LoginPwdViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/26.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "LoginPwdViewController.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "FoundPwdViewController.h"
#import "NSString+CheckString.h"
#import "URLRequest.h"
#import "NavigationController.h"
#import "MainCenterViewController.h"
#import "NSString+iOSVersion.h"
@interface LoginPwdViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnForget;
@property (weak, nonatomic) IBOutlet UIButton *btnRegist;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (weak, nonatomic) IBOutlet UIButton *btnCodeLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnForgetPwd;
@end

@implementation LoginPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self setupUI];
}

- (void) setupUI{
    self.btnForget.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.btnRegist.layer.borderWidth = 1.0;
    self.btnRegist.layer.borderColor = MainColor.CGColor;
    
    
    [self.btnLogin setTitle:[@"登录" language] forState:UIControlStateNormal];
    self.txtPhone.placeholder = [@"请输入手机号码/用户ID" language];
    self.txtPwd.placeholder = [@"请输入密码" language];
    [self.btnRegist setTitle:[@"注册" language] forState:UIControlStateNormal];
    [self.btnForget setTitle:[@"忘记密码" language] forState:UIControlStateNormal];
    [self.btnCodeLogin setTitle:[@"验证码登录" language] forState:UIControlStateNormal];
}
/** 验证码登录 */
- (IBAction)code_login_action:(id)sender {
    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
}

/** 注册 */
- (IBAction)regist_action:(id)sender {
    [self.navigationController pushViewController:[RegistViewController new] animated:YES];
}

/** 忘记密码 */
- (IBAction)forget_action:(id)sender {
    [self.navigationController pushViewController:[FoundPwdViewController new] animated:YES];
}

/** 登录 */
- (IBAction)login_action:(id)sender {
    
    if([self.txtPhone.text isEqualToString:@""]){
        [FaceAlertTool svpShowErrorWithMsg:@"请输入手机号码或用户ID"];
        return;
    }
    
    if([self.txtPwd.text isEqualToString:@""]){
        [FaceAlertTool svpShowErrorWithMsg:@"请输入密码"];
        return;
    }

    }];
}

@end
