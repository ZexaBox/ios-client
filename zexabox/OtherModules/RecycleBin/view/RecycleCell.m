//
//  RecycleCell.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/7.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "RecycleCell.h"

@implementation RecycleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.labelClear.text = [@"30天后清除" language];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(RecycleModel *)model{
    _model = model;
    self.labelName.text = model.name;
    self.labelInfo.text = [NSString stringWithFormat:@"%@ %@",[self getTaskSize:model.size],model.time];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseImageURL,model.thumbnail];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"热门图片"]];
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
