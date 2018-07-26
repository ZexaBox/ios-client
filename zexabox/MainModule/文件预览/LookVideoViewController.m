//
//  LookVideoViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/6/6.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "LookVideoViewController.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import "MRVLCPlayer.h"
#import "NSString+iOSVersion.h"
@interface LookVideoViewController ()

@property (nonatomic,strong) MRVLCPlayer *player;
@end

@implementation LookVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.labelTitle.text = [@"文件预览" language];
    NSString *url;
//    if(self.iscloud){
        url = BaseCloudURL;
//    }else{
//        url = BaseImageURL;
//    }
    NSString *req_url = [NSString stringWithFormat:@"%@%@",url,self.model.url];
    NSLog(@"文件预览url = %@",req_url);
    
    self.player = [[MRVLCPlayer alloc] init];
    NSInteger temp_height = 64;
    if([[NSString GetCurrentDeviceModel] isEqualToString:@"iPhone X"]){
        temp_height = 84;
    }
    self.player.frame = CGRectMake(0, temp_height, SCREEN_WIDTH, SCREEN_HEIGHT - temp_height);
    self.player.mediaURL = [NSURL URLWithString:req_url];
    [self.player showInView:self.view];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.player dismiss];
}


@end
