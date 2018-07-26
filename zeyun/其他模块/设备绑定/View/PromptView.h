//
//  PromptView.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/26.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromptView : UIView

@property (nonatomic,strong) UIImageView *imageView;
/** 展示的图片 */
@property (nonatomic,strong) NSString *stringImage;

/** title */
@property (nonatomic,strong) NSString *title;

/** 提示 */
@property (nonatomic,strong) NSString *desc;


@property (nonatomic,strong) NSString *rightTitle;

@property (nonatomic,strong) NSString *leftTitle;

@property (nonatomic,copy) void (^callback)(BOOL isleft);
@end
