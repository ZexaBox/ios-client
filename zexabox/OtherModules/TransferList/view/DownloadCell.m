//
//  DownloadCell.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "DownloadCell.h"

@implementation DownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.progressView.wrapperColor = MainColor;
    self.progressView.progressColor = MainColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btn_down:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)setIsHiddenUpload:(BOOL)isHiddenUpload{
    _isHiddenUpload = isHiddenUpload;
    self.btnDownState.hidden = isHiddenUpload;
    self.progressView.hidden = isHiddenUpload;
}

@end
