//
//  PromptView.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/26.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "PromptView.h"

@interface PromptView()


@property (nonatomic,strong) UILabel *labeTitle;
@property (nonatomic,strong) UILabel *labelDesc;
@property (nonatomic,strong) UIButton *btnLeft;
@property (nonatomic,strong) UIButton *btnRight;

@end

@implementation PromptView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"警告"]];
    self.labelDesc = [[UILabel alloc] init];
    self.labeTitle = [[UILabel alloc] init];
    self.btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    /** 添加分割线 */
    UIView *Hview = [[UIView alloc] initWithFrame:CGRectZero];
    Hview.backgroundColor = [UIColor hexStringToColor:@"#d8d8d8"];
    UIView *Vview = [[UIView alloc] initWithFrame:CGRectZero];
    Vview.backgroundColor = [UIColor hexStringToColor:@"#d8d8d8"];
    
    [self addSubview:self.imageView];
    [self addSubview:self.labeTitle];
    [self addSubview:self.labelDesc];
    [self addSubview:Hview];
    [self addSubview:Vview];
    [self addSubview:self.btnRight];
    [self addSubview:self.btnLeft];
    
    //MARK:-----------setup-------------//
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.labeTitle.font = [UIFont systemFontOfSize:15];
    self.labelDesc.font = [UIFont systemFontOfSize:12];
    self.labelDesc.textColor = [UIColor hexStringToColor:@"#383c3f"];
    self.labeTitle.textColor = [UIColor hexStringToColor:@"#383c3f"];
    self.labeTitle.text = @"提示";
    self.labelDesc.text = @"提示详细";
    self.labeTitle.textAlignment = NSTextAlignmentCenter;
    self.labelDesc.textAlignment = NSTextAlignmentCenter;
    self.labelDesc.numberOfLines = 2;
    self.labelDesc.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.btnLeft setTitle:[@"拒绝" language] forState:UIControlStateNormal];
    self.btnLeft.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.btnLeft setTitleColor:[UIColor hexStringToColor:@"#a5a5a5"] forState:UIControlStateNormal];
    [self.btnRight setTitle:[@"允许" language] forState:UIControlStateNormal];
    self.btnRight.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.btnRight setTitleColor:[UIColor hexStringToColor:@"#50a5ff"] forState:UIControlStateNormal];
    
    [self.btnLeft addTarget:self action:@selector(left_action) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRight addTarget:self action:@selector(right_action) forControlEvents:UIControlEventTouchUpInside];
    
    //MARK:-----------layout-------------//
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.left.right.equalTo(@0);
        make.height.equalTo(@(42));
    }];
    
    [self.labeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(8);
        make.left.right.equalTo(@0);
    }];
    
    [self.labelDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labeTitle.mas_bottom).offset(5);
        make.left.right.equalTo(@0);
    }];
    
    [Hview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@(-45));
        make.height.equalTo(@1);
    }];
    [Vview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Hview);
        make.width.equalTo(@1);
        make.bottom.equalTo(@0);
        make.centerX.equalTo(self);
    }];
    
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.bottom.equalTo(self);
        make.height.equalTo(@45);
        make.left.equalTo(Vview.mas_right);
    }];

    [self.btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(Vview.mas_left);
        make.bottom.equalTo(self);
        make.height.equalTo(@45);
        make.left.equalTo(@0);
    }];

    
}

//MARK:----------- action-------------//
- (void) left_action{
    if(self.callback){
        self.callback(YES);
    }
}

- (void) right_action{
    if(self.callback){
        self.callback(NO);
    }
}


//MARK:-----------setter-------------//

- (void)setDesc:(NSString *)desc{
    _desc = desc;
    self.labelDesc.text = desc;
}

- (void)setRightTitle:(NSString *)rightTitle{
    _rightTitle = rightTitle;
    [self.btnRight setTitle:rightTitle forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.labeTitle.text = title;
}

- (void)setLeftTitle:(NSString *)leftTitle{
    _leftTitle = leftTitle;
    [self.btnLeft setTitle:leftTitle forState:UIControlStateNormal];
}

- (void)setStringImage:(NSString *)stringImage{
    _stringImage = stringImage;
    self.imageView.image = [UIImage imageNamed:stringImage];
}


@end
