//
//  ZLQRCodeController.h
//  MyTwoCodeTest
//
//  Created by fengei on 16/7/6.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLBaseViewController.h"
typedef void (^callBack)(NSString *res);
@interface ZLQRCodeController : ZLBaseViewController

+ (void) scanQRCodeImage:(UIViewController *) senderControler;
//获取生成的二维码图片
+(UIImage *) getQRCodeImageWithString:(NSString *) info imageWidth:(CGFloat) width;
@property (nonatomic,copy) callBack resBack;//扫面结果返回
+ (ZLQRCodeController *) shareZLQRCode;
@end
