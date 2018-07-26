//
//  ShareChooseBackUpView.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ShareChooseBackUpView.h"

@interface ShareChooseBackUpView()

@property (nonatomic,strong) UILabel *labelTitle;

@end

@implementation ShareChooseBackUpView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    self.labelTitle = [self labelWithTitle:[@"请选择备份至" language] font:15 color:[UIColor hexStringToColor:@"#383c3f"]];
    self.btnLeft = [[CommentBtn alloc] init];
    self.btnLeft.MyImageView.image = [UIImage imageNamed:@"转发设备"];
    self.btnLeft.labelName.text = [@"外接设备" language];
    self.btnRight = [[CommentBtn alloc] init];
    self.btnRight.MyImageView.image = [UIImage imageNamed:@"云"];
    self.btnRight.labelName.text = [@"云" language];
    self.btnRight.labelName.textColor = [UIColor hexStringToColor:@"#383c3f"];
    self.btnLeft.labelName.textColor = [UIColor hexStringToColor:@"#383c3f"];
    self.btnLeft.labelName.font = [UIFont systemFontOfSize:15];
    self.btnRight.labelName.font = [UIFont systemFontOfSize:15];
    
    
    [self.btnLeft addTarget:self action:@selector(left_action) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRight addTarget:self action:@selector(right_action) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = ZLRGBAColor(239, 239, 239, 1.0);
    [self addSubview:line];
    
    [self addSubview:self.btnLeft];
    [self addSubview:self.btnRight];
    
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@15);
        make.right.equalTo(@(-10));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(@1);
        make.top.equalTo(self.labelTitle.mas_bottom).offset(20);
        make.bottom.equalTo(self).offset(-20);
    }];
    
    [self.btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.labelTitle.mas_bottom).offset(15);
        make.height.equalTo(@70);
        make.right.equalTo(line.mas_left);
    }];
    
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right);
        make.top.equalTo(self.btnLeft);
        make.height.equalTo(@70);
        make.right.equalTo(self);
    }];
}

- (void) left_action{
    if(self.callbackisLeft){
        self.callbackisLeft(YES);
    }
}

- (void) right_action{
    if(self.callbackisLeft){
        self.callbackisLeft(NO);
    }
}

@end
