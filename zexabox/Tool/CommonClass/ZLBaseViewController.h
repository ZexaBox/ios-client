//
//  ZLBaseViewController.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/27.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLBaseViewController : UIViewController

/** 如果需要将navi隐藏 隐藏此属性 */
@property (nonatomic,strong) UIView *naviView;

@property (nonatomic,strong) UILabel *labelTitle;
@property (nonatomic,strong) UIButton *btnLeft;
@property (nonatomic,strong) UIButton *btnRight;



- (void) pop_action;
@end
