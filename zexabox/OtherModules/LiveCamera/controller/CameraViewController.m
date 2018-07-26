//
//  CameraViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/2.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "CameraViewController.h"
#import "CanConectCameraTableViewVC.h"
@interface CameraViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelTitle.text = [@"实时摄像头" language];
    [self.btnAdd setTitle:[@"添加摄像头" language] forState:UIControlStateNormal];
}
- (IBAction)add_action:(id)sender {
    [self.navigationController pushViewController:[CanConectCameraTableViewVC new] animated:YES];
}
@end
