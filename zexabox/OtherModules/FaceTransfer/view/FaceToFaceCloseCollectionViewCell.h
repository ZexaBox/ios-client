//
//  FaceToFaceCloseCollectionViewCell.h
//  zeyun
//
//  Created by 邹琳 on 2018/6/7.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceToFaceModel.h"
@interface FaceToFaceCloseCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (nonatomic,strong) FaceToFaceModel *model;
@end
