//
//  ChooseTagColorViewController.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ZLBaseViewController.h"

@interface ChooseTagColorViewController : UIViewController


@property (nonatomic,copy) void (^callback)(UIColor *color,NSInteger idx);
@end
