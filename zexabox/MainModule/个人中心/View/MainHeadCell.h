//
//  MainHeadCell.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/27.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainHeadCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelCenter;
@property (nonatomic,copy) void (^callbackRight)(UIButton *btn);
@property (nonatomic,copy) void (^callbackLeft)(void);
@end
