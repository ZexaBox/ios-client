//
//  ShareDecodeView.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ShareDecodeView.h"

@implementation ShareDecodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    self.labelContent = [self labelWithTitle:[@"正在为您加密传输" language] font:14 color:[UIColor whiteColor]];
    self.labelContent.textAlignment = NSTextAlignmentCenter;
    [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@(-20));
        make.centerY.equalTo(self);
    }];
}

@end
