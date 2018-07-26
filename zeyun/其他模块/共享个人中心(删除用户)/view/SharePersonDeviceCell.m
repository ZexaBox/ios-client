//
//  SharePersonDeviceCell.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/7.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "SharePersonDeviceCell.h"

@implementation SharePersonDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SharePersonModel *)model{
    _model = model;
    self.labelPhone.text = model.mNumber;
    self.labelMac.text = [NSString stringWithFormat:@"%@（mac地址）",model.mac];
}

- (IBAction)del_action:(id)sender {
    if(self.callbackdelDevice){
        self.callbackdelDevice(self);
    }
}
@end
