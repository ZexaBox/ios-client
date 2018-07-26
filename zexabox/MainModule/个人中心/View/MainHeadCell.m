//
//  MainHeadCell.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/27.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "MainHeadCell.h"
#import "NSString+iOSVersion.h"
@interface MainHeadCell()

@property (weak, nonatomic) IBOutlet UIButton *btnRight;
@property (weak, nonatomic) IBOutlet UIButton *btnleft;
@property (weak, nonatomic) IBOutlet UILabel *labelcenter;

@end

@implementation MainHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btnRight.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.btnleft.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSInteger temp_height = 46;
    if([[NSString GetCurrentDeviceModel] isEqualToString:@"iPhone X"]){
        temp_height = 70;
    }
    
    [self.labelCenter mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(temp_height));
        make.centerX.equalTo(self);
    }];
}
- (IBAction)left_action:(id)sender {
    if(self.callbackLeft){
        self.callbackLeft();
    }
}
- (IBAction)right_action:(UIButton *)sender {
    if(self.callbackRight){
        self.callbackRight(sender);
    }
}

@end
