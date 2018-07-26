//
//  SettingSwitchCell.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/2.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "SettingSwitchCell.h"

@implementation SettingSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.labelName.text = [@"仅wifi环境上传/下载" language];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)change_action:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@(!sender.on) forKey:WIFI_DOWNLOAD_UPLOAD];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /** 这个控制任务暂停 */
    [[NSNotificationCenter defaultCenter] postNotificationName:WIFI_DOWNLOAD_UPLOAD object:@(sender.on)];
}

@end
