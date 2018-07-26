//
//  RegistViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/26.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "RegistViewController.h"
#import "URLRequest.h"
#import "NSString+CheckString.h"
#import "CountdownTool.h"
#import "NSString+CheckString.h"
#import "UserReadViewController.h"
@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnRead;
@property (weak, nonatomic) IBOutlet UIButton *btnGetSMS;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtSMS;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnRegist;


@property (nonatomic,strong) NSString *stringCode;
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) setupUI{
    self.labelTitle.text = [@"注册" language];
    self.btnRead.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.txtPhone.placeholder = [@"请输入手机号码" language];
    self.txtSMS.placeholder = [@"请输入验证码" language];
    self.txtPwd.placeholder = [@"请输入密码" language];
    [self.btnRegist setTitle:[@"注册" language] forState:UIControlStateNormal];
    [self.btnRead setTitle:[@" 我已经阅读并同意用户协议" language] forState:UIControlStateNormal];
    [self.btnGetSMS setTitle:[@"获取验证码" language] forState:UIControlStateNormal];
}
- (IBAction)read_action:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)sms_action:(id)sender {
    
    if(![self.txtPhone.text isPhoneNum]) {
        [FaceAlertTool svpShowErrorWithMsg:@"请输入正确的手机号码"];
        return;
    }
    
  
}

/** 注册 */
- (IBAction)regist_action:(id)sender {
    
   
    
    /** 判断注册条件 */
    if(![self.txtPhone.text isPhoneNum]) {
        [FaceAlertTool svpShowErrorWithMsg:@"请输入正确的手机号码"];
        return;
    }
    
    if(![self.txtSMS.text isEqualToString:self.stringCode]){
        [FaceAlertTool svpShowErrorWithMsg:@"您输入的验证码不正确"];
        return;
    }
    
    if(![self.txtPwd.text checkPassword]){
        [FaceAlertTool svpShowErrorWithMsg:@"请输入密码为6-20位字母数字组合"];
        return;
    }
    
    if(self.btnRead.selected == NO){
        [FaceAlertTool svpShowErrorWithMsg:@"请先阅读并同意用户协议"];
        return;
    }
    
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    
    [URLRequest requestJSON:POST urlString:url_register param:@{@"mNumber":self.txtPhone.text,@"mCode":self.stringCode,@"aPassword":self.txtPwd.text} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response != nil){
            [FaceAlertTool svpShowSuccessInfo:@"注册成功"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IS_BIND_DEVICE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
}

- (void) timeStart{
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

- (IBAction)user_read_action:(id)sender {
    
    [self.navigationController pushViewController:[UserReadViewController new] animated:YES];
}

@end
