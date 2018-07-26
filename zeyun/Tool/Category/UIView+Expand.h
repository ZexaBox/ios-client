//
//  UIView+Expand.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/27.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Expand)


- (UILabel *) labelWithTitle:(NSString *)title font:(NSInteger) font color:(UIColor *)color;

- (UIButton *)buttonWithTitle:(NSString *)title font:(NSInteger)font color:(UIColor *)color;

- (UIImageView *) imageViewWithName:(NSString *)image;
@end
