//
//  SettingBingMobileCell.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharePersonModel.h"
@interface SettingBingMobileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnSetColor;

@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@property (weak, nonatomic) IBOutlet UILabel *labelMac;
@property (nonatomic,strong) CAShapeLayer *shaplayer;
@property (nonatomic,strong) SharePersonModel *model;

@property (nonatomic,copy) void (^callback)(SettingBingMobileCell *cell);
@end
