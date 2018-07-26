//
//  PersonInfoCell.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UITextField *txtInfo;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

@end
