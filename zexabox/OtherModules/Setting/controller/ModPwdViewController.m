//
//  ModPwdViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/8.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ModPwdViewController.h"
#import "NSString+CheckString.h"
#import "URLRequest.h"
#import "CountdownTool.h"
#import "NavigationController.h"
#import "LoginPwdViewController.h"
@interface ModPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnCode;
@property (nonatomic,strong) NSString *stringCode;
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@property (weak, nonatomic) IBOutlet UILabel *labelCode;
@property (weak, nonatomic) IBOutlet UILabel *labePwd;
@end

@implementation ModPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.labelTitle.text = [@"修改密码" language];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.btnRight setTitle:[@"保存" language] forState:UIControlStateNormal];
    [self.btnRight setTitleColor:MainTextColor forState:UIControlStateNormal];
    self.btnRight.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.btnRight addTarget:self action:@selector(right_action) forControlEvents:UIControlEventTouchUpInside];
    
    self.txtPhone.placeholder = [@"请输入手机号码" language];
    self.txtCode.placeholder = [@"请输入验证码" language];
    self.txtPwd.placeholder = [@"请输入新密码" language];
    [self.btnCode setTitle:[@"获取验证码" language] forState:UIControlStateNormal];
    self.labelPhone.text = [@"手机号" language];
    self.labelCode.text = [@"验证码" language];
    self.labePwd.text = [@"新密码" language];
}

- (void) right_action{
    if(![self.txtPhone.text isPhoneNum]){
        [FaceAlertTool svpShowErrorWithMsg:@"请输入正确的手机号码"];
        return;
    }
    if([self.txtCode.text isEqualToString:@""]){
        [FaceAlertTool svpShowErrorWithMsg:@"请输入的验证码"];
        return;
    }
    
    if(![self.txtPwd.text checkPassword]){
        [FaceAlertTool svpShowErrorWithMsg:@"请输入密码为6-20位字母数字组合"];
        return;
    }
    
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    
    [URLRequest requestJSON:POST urlString:url_resetPasswordBySms param:@{@"mCode":self.txtCode.text,@"mNumber":self.txtPhone.text,@"aPassword":self.txtPwd.text} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response){
            if([response[@"code"] integerValue] == 0){
                [FaceAlertTool createAlertWithTitle:@"修改成功" message:@"请重新登录" inViewController:self block:^{
                    [[UserInfoManager manager] writeToFile];
                    [UIApplication sharedApplication].keyWindow.rootViewController = [[NavigationController alloc] initWithRootViewController:[LoginPwdViewController new]];
                }];
            }else{
                [FaceAlertTool svpShowInfo:response[@"message"]];
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
}

- (IBAction)sms_action:(id)sender {
    
    if(![self.txtPhone.text isPhoneNum]){
        [FaceAlertTool svpShowErrorWithMsg:@"请输入正确的手机号码"];
        return;
    }
    
    [FaceAlertTool svpShowWithState:@"验证码发送中..."];
    
    /** 网络请求 */
    [URLRequest requestWithMethod:GET urlString:url_sendsms parameters:@{@"mNumber":self.txtPhone.text} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response != nil){
            [FaceAlertTool svpShowSuccessInfo:@"请求成功"];
            /** 倒计时 */
            [self timerStart];
            self.stringCode = [response[@"data"] valueForKey:@"mCode"];
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"服务器请求失败"];
        }
    }];
}

/** 倒计时 */
- (void) timerStart{
    
    self.btnCode.userInteractionEnabled = NO;
    /** 倒计时 */
    CountdownTool *down = [[CountdownTool alloc] init];
    [down timerStatrWithCountdown:60 Speed:1];
    down.callBackCountdown = ^(NSInteger countdown) {
        [self.btnCode setTitle:[NSString stringWithFormat:@"%ld",countdown] forState:UIControlStateNormal];
        if(countdown == 0){
            [self.btnCode setTitle:[@"获取验证码" language] forState:UIControlStateNormal];
            self.btnCode.userInteractionEnabled = YES;
        }
    };
}


@end
