//
//  OtherLinkView.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/27.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "OtherLinkView.h"

@interface OtherLinkView()

@property (nonatomic,strong) UILabel *labelTitle;
@property (nonatomic,strong) UIButton *other;
@end

@implementation OtherLinkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    self.labelTitle = [self labelWithTitle:[@"当前局域网没有可用设备，请选择" language] font:14 color:[UIColor hexStringToColor:@"#383c3f"]];
    self.labelTitle.textAlignment = NSTextAlignmentCenter;
    self.other = [self buttonWithTitle:[@"其他连接方式" language] font:14 color:MainColor];
    [self.other addTarget:self action:@selector(other_click) forControlEvents:UIControlEventTouchUpInside];
    
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@49);
        make.left.right.equalTo(self);
    }];
    
    [self.other mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labelTitle.mas_bottom).offset(11);
        make.centerX.equalTo(self);
    }];
}

- (void) other_click{
    if(self.callback){
        self.callback();
    }
}
@end
