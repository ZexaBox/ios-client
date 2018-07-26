//
//  CommentBtn.m
//  HengQin
//
//  Created by 邹琳 on 2018/2/5.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "CommentBtn.h"
#import <Masonry.h>
@interface CommentBtn()


@end

@implementation CommentBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}

- (void) setupUI{
    [self addSubview:self.MyImageView];
    [self addSubview:self.labelName];
    
    [self.MyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self.labelName.mas_top);
    }];
    
    [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(25));
    }];
}

- (UIImageView *)MyImageView{
    if(!_MyImageView){
        _MyImageView = [[UIImageView alloc] init];
        _MyImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _MyImageView;
}

- (UILabel *)labelName{
    if(!_labelName){
        _labelName = [[UILabel alloc] init];
        _labelName.font = [UIFont systemFontOfSize:10];
        _labelName.textAlignment = NSTextAlignmentCenter;
    }
    return _labelName;
}

- (void)setMynormalImage:(UIImage *)mynormalImage{
    _mynormalImage = mynormalImage;
    self.MyImageView.image = mynormalImage;
}

- (void)setComSelected:(BOOL)comSelected{
    _comSelected = comSelected;
    if(comSelected){
        self.MyImageView.image = self.myselectImage;
        self.labelName.textColor = MainColor;
    }else{
        self.MyImageView.image = self.mynormalImage;
        self.labelName.textColor = [UIColor hexStringToColor:@"#939393"];
    }
}
@end
