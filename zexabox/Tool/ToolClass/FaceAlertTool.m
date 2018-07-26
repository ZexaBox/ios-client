//
//  FaceAlertTool.m
//  Face
//
//  Created by zoulin on 16/3/1.
//  Copyright © 2016年 bigPaigu. All rights reserved.
//

#import "FaceAlertTool.h"

@implementation FaceAlertTool
//创建弹窗
+ (void)createAlertWithTitle : (NSString *)title message:(NSString *)message inViewController:(UIViewController*)viewController block:(Click)block{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[title language] message:[message language] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureButton = [UIAlertAction actionWithTitle:[@"确定" language] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block();
        }
    }];
    [alert addAction:sureButton];
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (void)createSelectAlertWithTitle : (NSString *)title message:(NSString *)message inViewController:(UIViewController *)viewController sure:(Click)sure {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[title language] message:[message language] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:[@"确定" language] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sure) {
            sure();
        }
    }];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:[@"取消" language] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:sureBtn];
    [alert addAction:cancelBtn];
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (void)createSelectAlertWithTitle : (NSString *)title message:(NSString *)message sure:(Click)sure {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[title language] message:[message language] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:[@"确定" language] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sure) {
            sure();
        }
    }];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:[@"取消" language] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:sureBtn];
    [alert addAction:cancelBtn];
    if ([UIApplication sharedApplication].delegate.window.rootViewController.presentedViewController == nil) {
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:^{
            
        }];
    }
}

+ (void) createInputTextWithtitle:(NSString *) title inViewController:(id) viewController sure:(CallBack)sure
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[title language] message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //设置textField的样式的
    }];
    UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:[@"确定" language] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(sure!=nil && alert.textFields[0].text.length == 6 && ![alert.textFields[0].text isEqualToString:@""])
        {
            sure(alert.textFields[0].text);
        }
    }];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:[@"取消" language] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:sureBtn];
    [alert addAction:cancelBtn];
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (void) createSheetAlertWithTitle:(NSString *)title MessageArray:(NSArray *) messageArray  inViewController:(id) viewController titleColor:(UIColor *)color SheetAction:(SheetAction)sheetAction 
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[title language] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (messageArray.count > 0) {
        [viewController presentViewController:alert animated:YES completion:nil];
        [messageArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if (sheetAction) {
                    sheetAction(idx);
                }
            }];
//            [action setValue:color forKey:@"_titleTextColor"];
            
            [alert addAction:action];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[@"取消" language] style:UIAlertActionStyleCancel handler:nil];
//        [cancelAction setValue:color forKey:@"_titleTextColor"];
        [alert addAction:cancelAction];
        if ([UIApplication sharedApplication].delegate.window.rootViewController.presentedViewController == nil) {
            [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:^{
                
            }];
        }
    }
    
}

+ (void) svpShowSuccessInfo:(NSString *)msg{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    [SVProgressHUD showSuccessWithStatus:[msg language]];
}

+ (void) svpShowInfo:(NSString *)info{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    [SVProgressHUD showInfoWithStatus:[info language]];
}

+ (void) svpShowErrorWithMsg:(NSString *)message{
    NSString *msg = [message language];
    if([message containsString:@"服务器"]){
        msg = [@"失败" language];
    }
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    [SVProgressHUD showErrorWithStatus:msg];
}

+ (void) svpShowWitheErrorWithMsg:(NSString *)message{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    [SVProgressHUD showErrorWithStatus:[message language]];
}

+ (void) svpShowWithState:(NSString *)message{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMaximumDismissTimeInterval:30.0];
    [SVProgressHUD showWithStatus:[message language]];
}
+ (void) svpShowWitheWithState:(NSString *)message{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setMaximumDismissTimeInterval:30.0];
    [SVProgressHUD showWithStatus:[message language]];
}

@end
