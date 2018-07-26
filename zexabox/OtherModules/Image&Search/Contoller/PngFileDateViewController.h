//
//  PngFileDateViewController.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PngModel.h"
@interface PngFileDateViewController : UIViewController

/** 是否是共享空间 */
@property (nonatomic,assign) BOOL issharespace;
@property (nonatomic,strong) UIImage *share_image;
@property (nonatomic,strong) PngModel *model;
@end
