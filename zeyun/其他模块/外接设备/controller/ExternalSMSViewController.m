//
//  ExternalSMSViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/2.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ExternalSMSViewController.h"

@interface ExternalSMSViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UILabel *labelNotice;
@property (weak, nonatomic) IBOutlet UILabel *labelSMS;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnSure;
@end

@implementation ExternalSMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelNotice.text = [@"权限提示" language];
    self.labelSMS.text = [@"请输入短信验证码" language];
    [self.btnCancel setTitle:[@"取消" language] forState:UIControlStateNormal];
    [self.btnSure setTitle:[@"确定" language] forState:UIControlStateNormal];
}
- (IBAction)cancel_action:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
- (IBAction)sure_action:(id)sender {
    if([self.txtPhone.text isEqualToString:@""])return;
    if(![self.txtPhone.text isEqualToString:self.stringCode]){
        [FaceAlertTool svpShowErrorWithMsg:@"您输入的验证码不正确"];
        return;
    }
    if(self.callback){
        self.callback(self.txtPhone.text);
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
}



@end
