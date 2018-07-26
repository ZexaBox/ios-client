//
//  PngDiretoryCell.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/10.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "PngDiretoryCell.h"

@implementation PngDiretoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(PngModel *)model{
    _model = model;
    self.labelName.text = model.name;
}

@end
