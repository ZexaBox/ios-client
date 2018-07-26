//
//  ShareCollectionViewCell.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/30.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ShareCollectionViewCell.h"

@implementation ShareCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /** 画一个三角形 */
    self.shaplayer = [CAShapeLayer layer];
    //定义画图的path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGFloat width = ([UIScreen mainScreen].bounds.size.width-70) / 3.0;
    //path移动到开始画图的位置
    [path moveToPoint:CGPointMake(width,0)];
    [path addLineToPoint:CGPointMake(width - 28,0)];
    [path addLineToPoint:CGPointMake(width,28)];
    [path fill];
    
    //关闭path
    [path closePath];
    self.shaplayer.path = path.CGPath;
    [self.layer addSublayer:self.shaplayer];
    self.shaplayer.fillColor = [UIColor clearColor].CGColor;
}

- (void)setModel:(PngModel *)model{
    _model = model;
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseImageURL,model.thumbnail];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"热门图片"]];
    self.labelName.text = model.name;
}

@end
