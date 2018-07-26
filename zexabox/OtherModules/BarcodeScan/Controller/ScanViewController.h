//
//  ScanViewController.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/27.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ZLBaseViewController.h"

@interface ScanViewController : ZLBaseViewController

@property (nonatomic,copy) void (^callback)(NSString *res);
@end
