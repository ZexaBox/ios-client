//
//  CommentBtn.h
//  HengQin
//
//  Created by 邹琳 on 2018/2/5.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentBtn : UIButton

@property (nonatomic,strong) UIImageView *MyImageView;


/** 仅仅tab使用熟悉 */
@property (nonatomic,strong) UIImage *mynormalImage;
@property (nonatomic,strong) UIImage *myselectImage;
@property (nonatomic,assign) BOOL comSelected;

/** -------- */


@property (nonatomic,strong) UILabel *labelName;
@end
