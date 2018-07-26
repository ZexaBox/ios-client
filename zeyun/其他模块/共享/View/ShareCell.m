//
//  ShareCell.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ShareCell.h"

@implementation ShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /** 画一个三角形 */
    self.shaplayer = [CAShapeLayer layer];
    //定义画图的path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    /** cell高度 - 图片高 */
    CGFloat miny = (60 - 43) / 2.0 + 1;
    //path移动到开始画图的位置
    [path moveToPoint:CGPointMake(CGRectGetMaxX(self.headImageView.frame),miny)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.headImageView.frame),miny + 14)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.headImageView.frame)-14,miny)];
    [path fill];
    
    //关闭path
    [path closePath];
    self.shaplayer.path = path.CGPath;
    self.shaplayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:self.shaplayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(PngModel *)model{
    _model = model;
    self.labelName.text = model.name;
    self.labelNameDetail.text = [NSString stringWithFormat:@"%@ %@",[self getTaskSize:model.size],model.time];
    NSString *url;
//    if(self.isCloud){
//        url = BaseCloudURL;
//    }else{
        url = BaseImageURL;
//    }
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url,model.thumbnail]] placeholderImage:[UIImage imageNamed:@"热门图片"]];
}

/** 获取任务大小 */
- (NSString *)getTaskSize:(NSInteger )length{
    if(length / 1024.0 > 1000){
        return [NSString stringWithFormat:@"%.2fMB",length / 1024.0 / 1024.0];
    }else{
        return [NSString stringWithFormat:@"%.2fKB",length / 1024.0];
    }
}
@end
