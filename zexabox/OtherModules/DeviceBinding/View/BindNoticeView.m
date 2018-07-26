//
//  BindNoticeView.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/27.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "BindNoticeView.h"
@interface BindNoticeView()

@end

@implementation BindNoticeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    self.imageView = [self imageViewWithName:@"bind成功"];
    self.labelTitle = [self labelWithTitle:[@"绑定成功" language] font:18 color:[UIColor hexStringToColor:@"#383c3f"]];
    self.labelTitle.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@80);
        make.centerX.equalTo(self);
        make.height.with.equalTo(@80);
    }];
    
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(30);
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
    }];
}
@end
