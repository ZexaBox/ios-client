//
//  MobileListTableViewCell.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/30.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobileListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *btnSelected;
@end
