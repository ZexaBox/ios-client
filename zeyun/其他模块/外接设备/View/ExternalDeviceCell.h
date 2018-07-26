//
//  ExternalDeviceCell.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/2.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExternalModel.h"
@interface ExternalDeviceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelSize;
@property (weak, nonatomic) IBOutlet UIButton *btnSelected;
@property (nonatomic,copy) void (^callback)(BOOL select, ExternalModel *model);

@property (nonatomic,strong) ExternalModel *model;
@end
