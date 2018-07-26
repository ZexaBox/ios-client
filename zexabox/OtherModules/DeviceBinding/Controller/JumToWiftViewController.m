//
//  JumToWiftViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/7.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "JumToWiftViewController.h"

@interface JumToWiftViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *lableNotice;
@property (weak, nonatomic) IBOutlet UILabel *labelDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnNo;
@property (weak, nonatomic) IBOutlet UIButton *btnYes;
@end

@implementation JumToWiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    self.lableNotice.text = [@"泽云APP正在尝试打开或关闭WLAN" language];
    self.labelDesc.text = [@"您也可以在“安全中心-权限隐私-应用权限管理”里进行设置" language];
    [self.btnNo setTitle:[@"拒绝" language] forState:UIControlStateNormal];
    [self.btnYes setTitle:[@"允许" language] forState:UIControlStateNormal];
    
}
- (IBAction)refuse:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
- (IBAction)allowed:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}



@end
