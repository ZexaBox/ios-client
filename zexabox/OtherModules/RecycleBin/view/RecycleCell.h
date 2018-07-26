//
//  RecycleCell.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/7.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecycleModel.h"
@interface RecycleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnSelected;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelClear;

@property (nonatomic,strong) RecycleModel *model;
@end
