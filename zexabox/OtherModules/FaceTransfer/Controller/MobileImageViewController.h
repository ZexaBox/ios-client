//
//  MobileImageViewController.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/30.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ZLBaseViewController.h"

@interface MobileImageViewController : UIViewController

@property (nonatomic,copy) void (^callback)(BOOL isadd,NSDictionary *dic);
@end
