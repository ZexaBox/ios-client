//
//  PersonSexCell.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "PersonSexCell.h"

@implementation PersonSexCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.labelSex.text = [@"称谓" language];
    [self.btnMan setTitle:[@" 先生" language] forState:UIControlStateNormal];
    [self.btnWoman setTitle:[@" 女士" language] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)man_click:(UIButton *)sender {
    self.btnWoman.selected = NO;
    sender.selected = YES;
    if(self.callback){
        self.callback(YES);
    }
}
- (IBAction)woman:(UIButton *)sender {
    self.btnMan.selected = NO;
    sender.selected = YES;
    if(self.callback){
        self.callback(NO);
    }
}

@end
