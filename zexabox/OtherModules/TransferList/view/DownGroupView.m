//
//  DownGroupView.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "DownGroupView.h"

@implementation DownGroupView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    self.labelName = [self labelWithTitle:@"正在下载（2）" font:14 color:MainTextColor];
    [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-10);
        make.left.equalTo(@15);
    }];
}

@end
