//
//  FaceToFaceViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/29.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "FaceToFaceViewController.h"
#import "MyMobileFileViewController.h"
#import "MobileListViewController.h"
#import "ReceiveFileViewController.h"
#import "SocketFileViewController.h"
#import "SocketReceiveFileViewController.h"
#import "FileListViewController.h"
#import "SendFilesViewController.h"
#import "FaceToFaceCloseViewController.h"
@interface FaceToFaceViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIButton *btnReceive;
@end

@implementation FaceToFaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelTitle.text = [@"面对面快传" language];
    
    [self.btnRight setTitle:[@"最近文件" language] forState:UIControlStateNormal];
    self.labelInfo.text = [@"文件传输，急速秒传" language];
    [self.btnSend setTitle:[@" 发文件" language] forState:UIControlStateNormal];
    [self.btnReceive setTitle:[@" 收文件" language] forState:UIControlStateNormal];
    self.btnRight.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.btnRight addTarget:self action:@selector(right_action) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRight setTitleColor:MainTextColor forState:UIControlStateNormal];
    [self.btnRight mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labelTitle);
        make.right.equalTo(@(-15));
        make.height.equalTo(@30);
    }];
    
}

- (void) right_action{
    FaceToFaceCloseViewController *vc = [FaceToFaceCloseViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)send_action:(UIButton *)sender {
    [self.navigationController pushViewController:[MyMobileFileViewController new] animated:YES];
}
- (IBAction)receive_action:(UIButton *)sender {
//    [self.navigationController pushViewController:[SocketReceiveFileViewController new] animated:YES];
    [self.navigationController pushViewController:[ReceiveFileViewController new] animated:YES];
}
@end
