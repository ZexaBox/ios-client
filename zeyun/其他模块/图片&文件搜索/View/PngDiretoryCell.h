//
//  PngDiretoryCell.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/10.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PngModel.h"
@interface PngDiretoryCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (nonatomic,strong) PngModel *model;
@end
