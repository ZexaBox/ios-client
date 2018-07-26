//
//  AlertViewController.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/26.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromptView.h"
#import "ShareDecodeView.h"
#import "UIViewController+Alert.h"
#import "ShareChooseBackUpView.h"
#import "ShareFileDateView.h"
typedef NS_ENUM(NSInteger,ALERTTYPE) {
    search_device,
    alert_decode,
    alert_share_backup
};

@class AlertViewController;
@protocol AlertViewControllerDelegate<NSObject>

/** 备份选择 */
@optional
- (void) alertshareBackupVC:(AlertViewController *)alertVC isleftClick:(BOOL) isleftClick;

@optional
- (void) alertshareDeleteVC:(AlertViewController *)alertVC isleftClick:(BOOL) isleftClick;
@end

@interface AlertViewController : UIViewController

@property (nonatomic,assign)ALERTTYPE alertType;

/** PromptyView控制属性begin */
@property (nonatomic,assign) BOOL hiddenImage;
@property (nonatomic,strong) NSString *stringTitle;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *rightTitle;
@property (nonatomic,strong) NSString *leftTitle;
/** PromptyView控制属性ending */


/** 控制alert_decode属性 */
@property (nonatomic,strong) NSString *alert_decodeTitle;


@property (nonatomic,weak) id<AlertViewControllerDelegate> delegate;

/** 是否是云备份到个人空间 */
@property (nonatomic,assign) BOOL is_cloud_backup;
@end
