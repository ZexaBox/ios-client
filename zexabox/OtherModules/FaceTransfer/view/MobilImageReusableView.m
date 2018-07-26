//
//  MobilImageReusableView.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/30.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "MobilImageReusableView.h"
@interface MobilImageReusableView()

@property (nonatomic,strong) UIButton *btnGoup;
@end
@implementation MobilImageReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    self.btnGoup = [self buttonWithTitle:[NSString stringWithFormat:@"    %@",[@"手机相册" language]] font:16 color:MainTextColor];
    [self.btnGoup setImage:[UIImage imageNamed:@"下一页"] forState:UIControlStateNormal];
    [self.btnGoup setImage:[UIImage imageNamed:@"tableview_next"] forState:UIControlStateSelected];
    self.btnGoup.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.btnGoup addTarget:self action:@selector(group_click_action:) forControlEvents:UIControlEventTouchUpInside];
    self.btnGoup.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.backgroundColor = [UIColor whiteColor];
    [self.btnGoup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@0);
        make.centerY.equalTo(self);
    }];
}

- (void) group_click_action:(UIButton *)sender{
    if(self.callback){
        self.callback(sender.selected);
    }
    sender.selected = !sender.selected;
}
@end
