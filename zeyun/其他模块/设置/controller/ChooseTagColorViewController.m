//
//  ChooseTagColorViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ChooseTagColorViewController.h"

@interface ChooseTagColorViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@end

@implementation ChooseTagColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[[UIColor hexStringToColor:@"#f64b41"],[UIColor hexStringToColor:@"#0f97f2"],[UIColor hexStringToColor:@"#f7c536"],[UIColor hexStringToColor:@"#9b78f0"],[UIColor hexStringToColor:@"#fb9797"],[UIColor hexStringToColor:@"#15d878"]];
    
    self.labelName.text = [@"选择颜色" language];
    CGFloat width = (SCREEN_WIDTH - 37 * 2) / 3.0;
    [array enumerateObjectsUsingBlock:^(UIColor *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = obj;
        btn.tag = 500+idx;
        [btn addTarget:self action:@selector(choose_action:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:btn];
        NSInteger top = 15 + idx / 3 * 85;
        NSInteger left = (idx % 3) * width;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(left));
            make.top.equalTo(self.labelName.mas_bottom).offset(top);
            make.width.equalTo(@(width));
            make.height.equalTo(@85);
        }];
    }];
    
}

- (void) choose_action:(UIButton *)sender{
    if(self.callback){
        self.callback(sender.backgroundColor,sender.tag - 500);
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}


@end
