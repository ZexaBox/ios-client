//
//  SettingBingMobileCell.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "SettingBingMobileCell.h"

@interface SettingBingMobileCell()
@end

@implementation SettingBingMobileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.btnSetColor.layer.borderColor = MainColor.CGColor;
    self.btnSetColor.layer.borderWidth = 1.0;
    [self.btnSetColor setTitle:[@"分配用户颜色" language] forState:UIControlStateNormal];
    /** 画一个三角形 */
    self.shaplayer = [CAShapeLayer layer];
    //定义画图的path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    //path移动到开始画图的位置
    [path moveToPoint:CGPointMake(0,0)];
    [path addLineToPoint:CGPointMake(0,28)];
    [path addLineToPoint:CGPointMake(28,0)];
    [path fill];
    
    //关闭path
    [path closePath];
    self.shaplayer.path = path.CGPath;
    [self.layer addSublayer:self.shaplayer];
    self.shaplayer.fillColor = [UIColor clearColor].CGColor;
}

- (void)setModel:(SharePersonModel *)model{
    _model = model;
    self.labelPhone.text = model.mNumber;
    self.labelMac.text = [NSString stringWithFormat:@"%@（mac地址）",model.mac];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)setting_action:(id)sender {
    if(self.callback){
        self.callback(self);
    }
}

@end
