//
//  PersonViewController.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/27.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "BaseTableViewController.h"

@interface PersonViewController : UIViewController

@property (nonatomic,copy) void (^callback)(NSString *title);
@end
