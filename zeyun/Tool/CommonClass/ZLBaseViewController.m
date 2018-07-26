//
//  ZLBaseViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/27.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ZLBaseViewController.h"
#import "NSString+iOSVersion.h"
@interface ZLBaseViewController ()

@end

@implementation ZLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = ZLRGBAColor(239, 239, 239, 1);
    [self setupUIS];
}

- (void) setupUIS{
    self.naviView = [[UIView alloc] initWithFrame:CGRectZero];
    self.naviView.backgroundColor = [UIColor hexStringToColor:@"#fbfbfd"];
    
    self.labelTitle = [[UILabel alloc] init];
    self.labelTitle.text = @"";
    self.labelTitle.font = [UIFont systemFontOfSize:18];
    self.labelTitle.textColor = [UIColor hexStringToColor:@"#383c3f"];
    self.labelTitle.textAlignment = NSTextAlignmentCenter;
    
    self.btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnLeft setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    [self.btnLeft addTarget:self action:@selector(pop_action) forControlEvents:UIControlEventTouchUpInside];
    self.btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnRight.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:self.naviView];
    [self.naviView addSubview:self.labelTitle];
    [self.naviView addSubview:self.btnLeft];
    [self.naviView addSubview:self.btnRight];
    
    NSInteger temp_height = 64;
    if([[NSString GetCurrentDeviceModel] isEqualToString:@"iPhone X"]){
        temp_height = 84;
    }
    
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(temp_height));
    }];
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-14));
        make.left.equalTo(@80);
        make.right.equalTo(@(-80));
    }];
    
    [self.btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.centerY.equalTo(self.labelTitle);
        make.height.equalTo(@(40));
        make.width.equalTo(@40);
    }];
    
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(0));
        make.centerY.equalTo(self.btnLeft);
        make.height.equalTo(@(50));
        make.width.equalTo(@(50));
    }];
}


//MARK:-----------action-------------//
- (void) pop_action{
    [self.navigationController popViewControllerAnimated:YES];
}






@end
