//
//  VedioCell.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/29.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "VedioCell.h"

@implementation VedioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(PngModel *)model{
    _model = model;
    self.labelName.text = model.name;
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseImageURL,model.thumbnail];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:url]];
}

@end
