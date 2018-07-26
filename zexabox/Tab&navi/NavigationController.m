//
//  NavigationController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/26.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

//+ (void)initialize {
//    UINavigationBar *bar = [UINavigationBar appearance];
//    bar.barTintColor = ZLRGBAColor(250, 250, 253, 1.0);
//    bar.barStyle = UIBarStyleBlack;
//    bar.translucent = NO;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBar.tintColor = [UIColor hexStringToColor:@"#383c3f"];
//    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    self.navigationBar.hidden = YES;
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//
//    if (self.childViewControllers.count > 0) {
//
//        viewController.hidesBottomBarWhenPushed = YES;
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"箭头"] style:(UIBarButtonItemStylePlain) target:self action:@selector(popBack)];
////        self.interactivePopGestureRecognizer.delegate = viewController;
//    }
//
//    [super pushViewController:viewController animated:animated];
//}

//- (void)popBack {
//    [self popViewControllerAnimated:YES];
//}


@end
