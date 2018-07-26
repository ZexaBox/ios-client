//
//  FoundPwdViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/26.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "FoundPwdViewController.h"
#import "NSString+CheckString.h"
#import "URLRequest.h"
#import "CountdownTool.h"
@interface FoundPwdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnGetSMS;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (nonatomic,strong) NSString *stringCode;
@end

@implementation FoundPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void) setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.labelTitle.text = [@"找回密码" language];
    self.txtPhone.placeholder = [@"请输入手机号码" language];
    self.txtCode.placeholder = [@"请输入验证码" language];
    self.txtPwd.placeholder = [@"请输入密码" language];
    [self.btnSubmit setTitle:[@"确认" language] forState:UIControlStateNormal];
    [self.btnGetSMS setTitle:[@"获取验证码" language] forState:UIControlStateNormal];
}

/** 获取验证码 */
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
            if([response[@"code"] integerValue] == 0){
                [FaceAlertTool svpShowSuccessInfo:@"请求成功"];
                /** 倒计时 */
                [self timerStart];
                self.stringCode = [response[@"data"] valueForKey:@"mCode"];
            }else{
                [FaceAlertTool svpShowErrorWithMsg:response[@"message"]];
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"服务器请求失败"];
        }
    }];
}

/** 倒计时 */
- (void) timerStart{
    
    self.btnGetSMS.userInteractionEnabled = NO;
    /** 倒计时 */
    CountdownTool *down = [[CountdownTool alloc] init];
    [down timerStatrWithCountdown:60 Speed:1];
    down.callBackCountdown = ^(NSInteger countdown) {
        [self.btnGetSMS setTitle:[NSString stringWithFormat:@"%ld",countdown] forState:UIControlStateNormal];
        if(countdown == 0){
            [self.btnGetSMS setTitle:[@"获取验证码" language] forState:UIControlStateNormal];
            self.btnGetSMS.userInteractionEnabled = YES;
        }
    };
}

- (IBAction)sure_action:(id)sender {
    if(![self.txtPhone.text isPhoneNum]){
        [FaceAlertTool svpShowErrorWithMsg:@"请输入正确的手机号码"];
        return;
    }
    if([self.txtCode.text isEqualToString:@""]){
        [FaceAlertTool svpShowErrorWithMsg:@"请输入验证码"];
        return;
    }
    
    if(![self.txtPwd.text checkPassword]){
        [FaceAlertTool svpShowErrorWithMsg:@"请输入密码为6-20位字母数字组合"];
        return;
    }
    
    if(![self.txtCode.text isEqualToString:self.stringCode]){
        [FaceAlertTool svpShowErrorWithMsg:@"您输入的验证码不正确"];
        return;
    }
   
    }];
}
@end
