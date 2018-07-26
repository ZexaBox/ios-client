//
//  PersonDetailHeadCell.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonDetailHeadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelMod;

@property (nonatomic,copy) void (^callback)(UIButton *button);
@end
