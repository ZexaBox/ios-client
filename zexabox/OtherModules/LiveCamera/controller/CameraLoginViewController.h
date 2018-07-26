//
//  CameraLoginViewController.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/2.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraLoginViewController : UIViewController

@property (nonatomic,copy) void (^callback)(NSString *accout,NSString *pwd);
@end
