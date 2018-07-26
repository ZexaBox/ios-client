//
//  ShareTabView.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ShareTabView.h"
#import "CommentBtn.h"
@interface ShareTabView()

@property (nonatomic,strong) UIStackView *stackView;
@end

@implementation ShareTabView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void) setupUI{
    self.stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    
    line.backgroundColor = ZLRGBAColor(239, 239, 239, 1.0);
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.backgroundColor = [UIColor whiteColor];
    self.stackView.distribution = UIStackViewDistributionFillEqually;
    self.stackView.alignment = UIStackViewAlignmentTop;
    [self addSubview:line];
    [self addSubview:self.stackView];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.right.equalTo(@0);
        make.height.equalTo(@1);
    }];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(5);
        make.left.right.equalTo(@0);
        make.height.equalTo(@49);
    }];
    
    NSArray *array = @[[@"下载" language],[@"分享" language],[@"备份" language],[@"删除" language]];
    NSArray *arrayNormal = @[@"下载-未选中",@"转发-未选中",@"备份-未选中",@"删除-未选中"];
    NSArray *arraySelected = @[@"下载-选中",@"转发-选中",@"备份-选中",@"删除-选中"];
    
    [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CommentBtn *btn = [[CommentBtn alloc] initWithFrame:CGRectZero];
        btn.labelName.text = obj;
        btn.mynormalImage = [UIImage imageNamed:arrayNormal[idx]];
        btn.myselectImage = [UIImage imageNamed:arraySelected[idx]];
        [self.stackView addArrangedSubview:btn];
        [btn addTarget:self action:@selector(click_action:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void) click_action:(CommentBtn *)btn{
    [self.stackView.subviews enumerateObjectsUsingBlock:^(__kindof CommentBtn * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.comSelected = NO;
    }];
    btn.comSelected = YES;
    if(self.callback){
        self.callback(btn);
    }
}

@end
