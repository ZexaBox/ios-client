//
//  FileCommonController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "FileCommonController.h"
#import "NSString+iOSVersion.h"
#import "NSString+Date.h"
#import "URLRequest.h"
#import "ChineseToPinyin.h"
@interface FileCommonController ()<UIPopoverPresentationControllerDelegate,AlertViewControllerDelegate>


@property (nonatomic,strong) PngTableViewController *alertVC;
/** 按上传时间排序 */
@property (nonatomic,assign) BOOL p_updateTime;
/** 按名称排序 */
@property (nonatomic,assign) BOOL p_nameorder;
@end

@implementation FileCommonController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 子类继承时声明方法容易被覆盖 */
    [self SETUPUI];
}

  


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.alertVC dismissViewControllerAnimated:NO completion:nil];
}



- (NSMutableArray *)arrayData{
    if(!_arrayData){
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}

- (NSMutableArray *)arrayDown{
    if(!_arrayDown){
        _arrayDown = [NSMutableArray array];
    }
    return _arrayDown;
}
@end
