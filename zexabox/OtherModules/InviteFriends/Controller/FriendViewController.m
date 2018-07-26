//
//  FriendViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "FriendViewController.h"
#import "AlertViewController.h"
#import "NSString+CheckString.h"
#import "URLRequest.h"
@interface FriendViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelFriend;
@property (weak, nonatomic) IBOutlet UIButton *btnSure;
@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelTitle.text = [@"邀请好友" language];
    [self.labelFriend mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom).offset(20);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
    }];
    self.labelFriend.text = [@"可通过搜索手机号添加好友" language];
    [self.btnSure setTitle:[@"确认邀请" language] forState:UIControlStateNormal];
}
- (IBAction)sure_action:(id)sender {
    
    if(![self.txtPhone.text isPhoneNum]){
        [FaceAlertTool svpShowErrorWithMsg:@"请输入正确的手机号码"];
        return;

    }];
}




@end
