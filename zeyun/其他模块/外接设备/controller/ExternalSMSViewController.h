//
//  ExternalSMSViewController.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/2.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExternalSMSViewController : UIViewController

@property (nonatomic,strong) NSString *stringCode;
@property (nonatomic,copy) void (^callback)(NSString *phone);
@end
