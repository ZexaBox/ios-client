//
//  PersonSexCell.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonSexCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnMan;
@property (weak, nonatomic) IBOutlet UIButton *btnWoman;
@property (weak, nonatomic) IBOutlet UILabel *labelSex;
@property (nonatomic,copy) void (^callback)(BOOL isman);
@end
