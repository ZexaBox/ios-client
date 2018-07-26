//
//  ExternalDeviceCell.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/2.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ExternalDeviceCell.h"

@implementation ExternalDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ExternalModel *)model{
    _model = model;
    self.labelName.text = model.name;
    self.labelSize.text = [self getTaskSize:model.size];
    
    if([model.file_type isEqualToString:@"folder"]){
        self.headImageView.image = [UIImage imageNamed:@"新建文件夹"];
    }else if([model.file_type isEqualToString:@"image"]){
        self.headImageView.image = [UIImage imageNamed:@"热门图片"];
    }else if([model.file_type isEqualToString:@"text"]){
        self.headImageView.image = [UIImage imageNamed:@"word"];
    }else if([model.file_type isEqualToString:@"audio"]){
        self.headImageView.image = [UIImage imageNamed:@"music"];
    }else{
        self.headImageView.image = [UIImage imageNamed:@"视频"];
    }
}

/** 获取任务大小 */
- (NSString *)getTaskSize:(NSInteger )length{
    if(length / 1024.0 > 1000){
        return [NSString stringWithFormat:@"%.2fMB",length / 1024.0 / 1024.0];
    }else{
        return [NSString stringWithFormat:@"%.2fKB",length / 1024.0];
    }
}

- (IBAction)selectec_action:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(self.callback){
        self.callback(sender.selected,self.model);
    }
}

@end
