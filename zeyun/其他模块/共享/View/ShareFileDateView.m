//
//  ShareFileDateView.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ShareFileDateView.h"

@interface ShareFileDateView()


@end

@implementation ShareFileDateView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    self.labelTitle = [self labelWithTitle:@"文件的有效期" font:15 color:[UIColor hexStringToColor:@"#383c3f"]];
    self.btnOneDay = [self buttonWithTitle:@"一天过期" font:13 color:[UIColor hexStringToColor:@"#383c3f"]];
    self.btnSevenDay = [self buttonWithTitle:@"七天过期" font:13 color:[UIColor hexStringToColor:@"#383c3f"]];
    self.btnLong = [self buttonWithTitle:@"永久有效" font:13 color:[UIColor hexStringToColor:@"#383c3f"]];
    self.btnCopy = [self buttonWithTitle:@"复制私密链接" font:14 color:[UIColor hexStringToColor:@"#383c3f"]];
    [self.btnCopy setImage:[UIImage imageNamed:@"复制文件夹"] forState:UIControlStateNormal];
    self.btnCopy.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = ZLRGBAColor(239, 239, 239, 1);
    
    [self setSelectImage:self.btnOneDay];
    [self setSelectImage:self.btnSevenDay];
    [self setSelectImage:self.btnLong];
    [self addSubview:line];

    
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@15);
    }];
    [self.btnOneDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labelTitle.mas_bottom).offset(20);
        make.left.equalTo(@10);
        make.height.equalTo(@15);
        make.width.equalTo(@100);
    }];
    [self.btnSevenDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnOneDay);
        make.left.equalTo(self.btnOneDay.mas_right);
        make.height.equalTo(@15);
        make.width.equalTo(@100);
    }];
    [self.btnLong mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnOneDay);
        make.left.equalTo(self.btnSevenDay.mas_right);
        make.height.equalTo(@15);
        make.width.equalTo(@100);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnOneDay.mas_bottom).offset(20);
        make.right.left.equalTo(self);
        make.height.equalTo(@1);
    }];
    [self.btnCopy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(1).offset(15);
        make.height.equalTo(@35);
        make.left.right.equalTo(self);
    }];
}

- (void) setSelectImage:(UIButton *)btn{
    [btn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn addTarget:self action:@selector(choose_action:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) choose_action:(UIButton *)sender{
    self.btnLong.selected = NO;
    self.btnOneDay.selected = NO;
    self.btnSevenDay.selected = NO;
    sender.selected = YES;
}
@end
