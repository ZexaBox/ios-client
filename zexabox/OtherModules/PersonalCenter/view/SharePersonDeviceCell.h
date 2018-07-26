//
//  SharePersonDeviceCell.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/7.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharePersonModel.h"
@interface SharePersonDeviceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@property (weak, nonatomic) IBOutlet UILabel *labelMac;
@property (weak, nonatomic) IBOutlet UIButton *btnMain;

@property (nonatomic,strong) SharePersonModel *model;

@property (nonatomic,copy) void (^callbackdelDevice)(SharePersonDeviceCell *cell);
@end
