//
//  AppDelegate.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/26.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyboardManager.h>
#import "LoginViewController.h"
#import "MainCenterViewController.h"
#import "LoginPwdViewController.h"
#import "NavigationController.h"
#import "BindViewController.h"
#import "LuanchViewController.h"
#import "ScanViewController.h"
#import "DownloadListViewController.h"
#import "UIImage+Save.h"
#import "NSString+File.h"
#import <Bugly/Bugly.h>
#import <WXApi.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "InternationalControl.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [InternationalControl initUserLanguage];
    [InternationalControl setUserlanguage:@"zh-Hans"];
//    [InternationalControl setUserlanguage:@"en"];


    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    [self.window makeKeyAndVisible];

    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application beginBackgroundTaskWithExpirationHandler:^{
        for(int i = 0;i<10000;i++){
            NSLog(@"%@",@(i));
        }
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if([TencentOAuth HandleOpenURL:url]) return [TencentOAuth HandleOpenURL:url];
    if([WXApi handleOpenURL:url delegate:self]) return [WXApi handleOpenURL:url delegate:self];
    return YES;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    if([TencentOAuth HandleOpenURL:url]) return [TencentOAuth HandleOpenURL:url];
    if([WXApi handleOpenURL:url delegate:self]) return [WXApi handleOpenURL:url delegate:self];
    return YES;
}

@end
