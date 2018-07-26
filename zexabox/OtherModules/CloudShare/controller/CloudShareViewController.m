//
//  CloudShareViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/7.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "CloudShareViewController.h"
#import "ShareFileDateView.h"
@interface CloudShareViewController ()

@end

@implementation CloudShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ShareFileDateView *alert = [[ShareFileDateView alloc] initWithFrame:CGRectZero];
    alert.backgroundColor = [UIColor whiteColor];
    alert.layer.cornerRadius = 15;
    [self.view addSubview:alert];
    
    [alert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.right.equalTo(@(-40));
        make.height.equalTo(@(150));
        make.centerY.equalTo(self.view);
    }];
    
    [alert.btnCopy addTarget:self action:@selector(copy_action) forControlEvents:UIControlEventTouchUpInside];
}

- (void) copy_action{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}


@end
