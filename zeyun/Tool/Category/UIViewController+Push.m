//
//  UIViewController+Push.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "UIViewController+Push.h"
#import "ShareViewController.h"
#import "PngViewController.h"
#import "VedioViewController.h"
#import "MusicViewController.h"
#import "FaceToFaceViewController.h"
#import "MobileBackupViewController.h"
#import "CameraViewController.h"
#import "ExternalDeviceViewController.h"
#import "FriendViewController.h"
#import "DownloadListViewController.h"
#import "SettingViewController.h"
#import "PersonInfoViewController.h"
#import "IntegarManagerViewController.h"
#import "SharePersonViewController.h"
#import "RecycleViewController.h"
#import "BindViewController.h"
#import "MemberViewController.h"
@implementation UIViewController (Push)


- (void) pushWithIdentifer:(NSString *)identifer{
    if([identifer isEqualToString:[@"空间共享" language]]){
        [self.navigationController pushViewController:[ShareViewController new] animated:YES];
    }
    
    if([identifer isEqualToString:[@"图片" language]]){
        [self.navigationController pushViewController:[PngViewController new] animated:YES];
    }
    
    if([identifer isEqualToString:[@"视频" language]]){
        [self.navigationController pushViewController:[VedioViewController new] animated:YES];
    }
    
    if([identifer isEqualToString:[@"音乐" language]] || [identifer isEqualToString:[@"文档" language]]){
        MusicViewController *Vc = [[MusicViewController alloc] init];
        Vc.stringName = identifer;
        [self.navigationController pushViewController:Vc animated:YES];
    }
    
    if([identifer isEqualToString:[@"面对面快传" language]]){
        [self.navigationController pushViewController:[FaceToFaceViewController new] animated:YES];
    }
    
    if([identifer isEqualToString:[@"手机备份" language]]){
        [self.navigationController pushViewController:[MobileBackupViewController new] animated:YES];
    }
    
    if([identifer isEqualToString:[@"实时摄像头" language]]){
        [self.navigationController pushViewController:[CameraViewController new] animated:YES];
    }
    
    if([identifer isEqualToString:[@"外接设备" language]]){
        [self.navigationController pushViewController:[ExternalDeviceViewController new] animated:YES];
    }
    
    if([identifer isEqualToString:[@"传输列表" language]]){
        [self.navigationController pushViewController:[DownloadListViewController manager] animated:YES];
    }
    
    if([identifer isEqualToString:[@"邀请好友" language]]){
        [self.navigationController pushViewController:[FriendViewController new] animated:YES];
    }
    
    if([identifer isEqualToString:[@"设置" language]]){
        [self.navigationController pushViewController:[SettingViewController new] animated:YES];
    }
    
    if([identifer isEqualToString:[@"个人资料" language]]){
        [self.navigationController pushViewController:[PersonInfoViewController new] animated:YES];
    }
    
    if([identifer isEqualToString:[@"积分管理" language]]){
        [self.navigationController pushViewController:[IntegarManagerViewController new] animated:YES];
    }
    
    if([identifer isEqualToString:[@"成员管理" language]]){
        [self.navigationController pushViewController:[MemberViewController new] animated:YES];
    }
    
    if([identifer isEqualToString:[@"回收站" language]]){
        [self.navigationController pushViewController:[RecycleViewController new] animated:YES];
    }
    
    if([identifer isEqualToString:[@"设备管理" language]]){
        [self.navigationController pushViewController:[BindViewController new] animated:YES];
    }
}
@end
