
//
//  IntegerCell.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "IntegerCell.h"

@implementation IntegerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(UserIntegerModel *)model{
    _model = model;
    self.labelName.text = model.message;
    self.labelInteger.text = [NSString stringWithFormat:@"%ld",model.value];
}

@end
