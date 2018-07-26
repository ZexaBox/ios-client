//
//  VedioCell.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/29.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PngModel.h"
@interface VedioCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnSelected;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
/** 播放按钮 */
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (nonatomic,strong) PngModel *model;
@end
