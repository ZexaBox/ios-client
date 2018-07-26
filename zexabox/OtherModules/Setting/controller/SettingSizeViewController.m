//
//  SettingSizeViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "SettingSizeViewController.h"
#import "URLRequest.h"

#define ZONE_SIZE @"ZONE_SIZE"

@interface SettingSizeViewController ()

@property (weak, nonatomic) IBOutlet UISlider *uislider;
/** 所占百分比 */
@property (weak, nonatomic) IBOutlet UILabel *labelCurrent;
/** 所占内存百分比 */
@property (weak, nonatomic) IBOutlet UILabel *labelSizeCurrent;
@property (weak, nonatomic) IBOutlet UILabel *labelSetting;
@end

@implementation SettingSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.labelTitle.text = [@"设置共享空间大小" language];
    [self.uislider setThumbImage:[UIImage imageNamed:@"调整按钮"] forState:UIControlStateNormal];
    self.labelSetting.text = [@"设置您的共享空间大小" language];
    [self.btnRight setTitle:[@"保存" language] forState:UIControlStateNormal];
    [self.btnRight setTitleColor:MainTextColor forState:UIControlStateNormal];
    [self.btnRight addTarget:self action:@selector(right_action) forControlEvents:UIControlEventTouchUpInside];
    self.btnRight.titleLabel.font = [UIFont systemFontOfSize:15];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:ZONE_SIZE] floatValue] == 0){
        [[NSUserDefaults standardUserDefaults] setObject:@(0.2) forKey:ZONE_SIZE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.uislider.value = [[[NSUserDefaults standardUserDefaults] objectForKey:ZONE_SIZE] floatValue];
    self.labelCurrent.text = [NSString stringWithFormat:@"%.1f%%",self.uislider.value * 100];
    self.labelSizeCurrent.text = [NSString stringWithFormat:@"%.1fG/5G %@",self.uislider.value * 5,self.labelCurrent.text];
}


- (void) right_action{
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    if(self.uislider.value < 0.2){
        [FaceAlertTool svpShowErrorWithMsg:@"设置共享空间大小不能小于20%"];
        return;
    }
    NSInteger count = 5 * 1024 * 1024;
    CGFloat cap =  count * 1024 * self.uislider.value;
    [URLRequest requestJSON:POST urlString:url_setting_capacity param:@{@"cap":@(cap)} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                [FaceAlertTool svpShowSuccessInfo:@"设置成功"];
                [[NSUserDefaults standardUserDefaults] setObject:@(self.uislider.value) forKey:ZONE_SIZE];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                [FaceAlertTool svpShowErrorWithMsg:response[@"message"]];
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
}

- (IBAction)size_change_action:(UISlider *)sender {
    self.labelCurrent.text = [NSString stringWithFormat:@"%.1f%%",sender.value * 100];
    self.labelSizeCurrent.text = [NSString stringWithFormat:@"%.1fG/5G %@",sender.value * 5,self.labelCurrent.text];
}

@end
