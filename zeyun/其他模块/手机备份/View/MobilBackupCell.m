//
//  MobilBackupCell.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/2.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "MobilBackupCell.h"

@implementation MobilBackupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)action_backup:(UISwitch *)sender {
    if(self.callback){
        self.callback(self, sender.on);
    }
}
@end
