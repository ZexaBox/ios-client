//
//  BindCell.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/26.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BindModel.h"
@interface BindCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelStatus;

@property (nonatomic,strong) BindModel *model;

@end
