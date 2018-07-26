//
//  PersonDetailHeadCell.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "PersonDetailHeadCell.h"

@implementation PersonDetailHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.btnHeadImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.btnHeadImageView.layer.masksToBounds = YES;
    self.btnHeadImageView.layer.cornerRadius = 42;
    self.labelMod.text = [@"点击修改头像" language];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)choose_head:(UIButton *)sender {
    if(self.callback){
        self.callback(sender);
    }
}

@end
