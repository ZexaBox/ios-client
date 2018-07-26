//
//  ScanViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/27.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ScanViewController.h"
#import "ZLQRCodeController.h"
//#import "BindNoticeView.h"
@interface ScanViewController ()

@property (nonatomic,strong) ZLQRCodeController *scanVC;

@property (nonatomic,strong) UILabel *labelNotice;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void) setupUI{
    self.scanVC = [ZLQRCodeController shareZLQRCode];
    self.scanVC.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:self.scanVC.view];
    [self addChildViewController:self.scanVC];
    self.labelTitle.text = [@"设备绑定" language];
    
    __weak typeof(self) weakself = self;
    self.scanVC.resBack = ^(NSString *res) {
        NSLog(@"%@",res);
        if(weakself.callback){
            weakself.callback(res);
        }
    };
    
    self.labelTitle = [self.view labelWithTitle:@"" font:14 color:[UIColor whiteColor]];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"(" attributes:@{NSForegroundColorAttributeName:MainColor}];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:[@"将手机对准设备背面" language] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ）",[@"条形码" language]] attributes:@{NSForegroundColorAttributeName:MainColor}]];
    self.labelTitle.attributedText = string;
    self.labelTitle.textAlignment = NSTextAlignmentCenter;
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@111);
        make.left.right.equalTo(self.view);
    }];
}

@end
