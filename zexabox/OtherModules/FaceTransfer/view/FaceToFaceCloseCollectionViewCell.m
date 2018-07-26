//
//  FaceToFaceCloseCollectionViewCell.m
//  zeyun
//
//  Created by 邹琳 on 2018/6/7.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "FaceToFaceCloseCollectionViewCell.h"

@implementation FaceToFaceCloseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(FaceToFaceModel *)model{
    _model = model;
    self.labelName.text = model.name;
}
@end
