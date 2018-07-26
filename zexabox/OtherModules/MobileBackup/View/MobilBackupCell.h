//
//  MobilBackupCell.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/2.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobilBackupCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageview;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UISwitch *myswitch;

@property (nonatomic,copy) void (^callback)(MobilBackupCell *cell,BOOL on);
@end
