//
//  PngCopyViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "PngCopyViewController.h"

@interface PngCopyViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnForeget;

@property (weak, nonatomic) IBOutlet UIButton *btnWPS;
@end

@implementation PngCopyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnForeget.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.btnWPS.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
