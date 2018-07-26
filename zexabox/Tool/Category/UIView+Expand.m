//
//  UIView+Expand.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/27.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "UIView+Expand.h"

@implementation UIView (Expand)


- (UILabel *)labelWithTitle:(NSString *)title font:(NSInteger)font color:(UIColor *)color{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    [self addSubview:label];
    return label;
}

- (UIButton *)buttonWithTitle:(NSString *)title font:(NSInteger)font color:(UIColor *)color{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [self addSubview:btn];
    return btn;
}

- (UIImageView *) imageViewWithName:(NSString *)image{
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    [self addSubview:imageview];
    return imageview;
}
@end
