//
//  PngReusableView.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "PngReusableView.h"

@interface PngReusableView()

@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic,strong) UILabel *labeLeft;
@property (nonatomic,strong) UILabel *labelRight;
@end

@implementation PngReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setupUI];
//        self.backgroundColor = ZLRGBAColor(239, 239, 239, 1.0);
        UIView *temp = [[UIView alloc] init];
        [self addSubview:temp];
        temp.backgroundColor = ZLRGBAColor(239, 239, 239, 1.0);
        [temp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.right.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    return self;
}

- (void) setupUI{
    self.leftImageView = [self imageViewWithName:@""];
    self.rightImageView = [self imageViewWithName:@""];
    self.rightImageView.backgroundColor = [UIColor blueColor];
    self.leftImageView.backgroundColor = [UIColor redColor];
    self.labeLeft = [self labelWithTitle:@"我的相册" font:16 color:MainTextColor];
    self.labelRight = [self labelWithTitle:@"最近上传" font:16 color:MainTextColor];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = ZLRGBAColor(239, 239, 239, 1.0);
    [self addSubview:line];
    
    UIView *centView = [[UIView alloc] init];
    [self addSubview:centView];
    
    [centView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.width.equalTo(@10);
        make.centerX.equalTo(self);
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@15);
        make.height.equalTo(@139);
        make.right.equalTo(centView.mas_left);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(15));
        make.right.equalTo(@(-15));
        make.left.equalTo(centView.mas_right);
        make.height.equalTo(@139);
    }];
    
    [self.labeLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftImageView.mas_bottom).offset(10);
        make.left.equalTo(@15);
    }];
    [self.labelRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labeLeft);
        make.left.equalTo(self.rightImageView);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.labelRight.mas_bottom).offset(24);
        make.height.equalTo(@1);
    }];
    
}
@end
