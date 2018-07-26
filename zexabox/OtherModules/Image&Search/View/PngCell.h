//
//  PngCell.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PngModel.h"
@interface PngCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (nonatomic,assign) BOOL isCloud;
@property (nonatomic,strong) PngModel *model;
@end
