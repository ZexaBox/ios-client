//
//  FaceAlertTool.h
//  Face
//
//  Created by zoulin on 16/3/1.
//  Copyright © 2016年 bigPaigu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVProgressHUD.h>
@interface FaceAlertTool : NSObject
typedef void(^Click)(void);
typedef void(^SureClick)(void);
typedef void(^CallBack)(NSString *title);
typedef void(^SheetAction)(NSInteger index);

+ (void)createAlertWithTitle : (NSString *)title message:(NSString *)message inViewController:(id)viewController block:(Click)block;

+ (void)createSelectAlertWithTitle : (NSString *)title message:(NSString *)message inViewController:(UIViewController *)viewController sure:(SureClick)sure;
+ (void)createSelectAlertWithTitle : (NSString *)title message:(NSString *)message sure:(Click)sure;
+ (void) createInputTextWithtitle:(NSString *) title inViewController:(id) viewController sure:(CallBack)sure;

+ (void) createSheetAlertWithTitle:(NSString *)title MessageArray:(NSArray *) messageArray  inViewController:(id) viewController titleColor:(UIColor *)color SheetAction:(SheetAction)sheetAction;

+ (void) svpShowErrorWithMsg:(NSString *)message;

+ (void) svpShowWithState:(NSString *)message;

+ (void) svpShowWitheErrorWithMsg:(NSString *)message;

+ (void) svpShowInfo:(NSString *)info;
+ (void) svpShowWitheWithState:(NSString *)message;
/** 成功黑色背景*/
+ (void) svpShowSuccessInfo:(NSString *)msg;
@end
