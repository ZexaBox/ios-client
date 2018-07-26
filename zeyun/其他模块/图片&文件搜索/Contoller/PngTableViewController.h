//
//  PngTableViewController.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "BaseTableViewController.h"

@interface PngTableViewController : BaseTableViewController

@property (nonatomic,strong) NSArray *arraData;
@property (nonatomic,copy) void (^callback)(NSString *title);
@end
