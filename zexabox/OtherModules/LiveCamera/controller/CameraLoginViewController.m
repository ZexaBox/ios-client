//
//  CameraLoginViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/2.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "CameraLoginViewController.h"

@interface CameraLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtAccount;

@property (weak, nonatomic) IBOutlet UITextField *txtpwd;
@property (weak, nonatomic) IBOutlet UILabel *labelNotice;
@property (weak, nonatomic) IBOutlet UILabel *labelAccount;
@property (weak, nonatomic) IBOutlet UILabel *lablePwd;
@property (weak, nonatomic) IBOutlet UIButton *labelLogn;
@end

@implementation CameraLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelNotice.text = [@"账号验证" language];
    self.labelAccount.text = [@"账号" language];
    self.lablePwd.text = [@"密码" language];
    [self.labelLogn setTitle:[@"登录" language] forState:UIControlStateNormal];
}

- (IBAction)login_action:(id)sender {
    if([self.txtpwd.text isEqualToString:@""]){
        [FaceAlertTool svpShowErrorWithMsg:@"请输入密码"];
        return;
    }
    
    
    if([self.txtAccount.text isEqualToString:@""]){
        [FaceAlertTool svpShowErrorWithMsg:@"请输入账号"];
        return;
    }
    
    if(self.callback){
        self.callback(self.txtAccount.text, self.txtpwd.text);
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}


@end
