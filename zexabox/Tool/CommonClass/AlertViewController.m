//
//  AlertViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/26.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "AlertViewController.h"

@interface AlertViewController ()

@property (nonatomic,strong) UIButton *btnDownloadAnimation;
@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.alertType == search_device){
        [self search_device];
    }
    
    if(self.alertType == alert_decode){
        [self share_decodeView];
    }
    
    if(self.alertType == alert_share_backup){
        [self share_backUP];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void) search_device{
    PromptView *alert = [[PromptView alloc] initWithFrame:CGRectZero];
    alert.backgroundColor = [UIColor whiteColor];
    alert.layer.cornerRadius = 10;
    alert.layer.masksToBounds = YES;
    if(self.hiddenImage){
        alert.imageView.hidden = self.hiddenImage;
        alert.title = self.stringTitle;
        alert.desc = self.desc;
        alert.rightTitle = self.rightTitle;
        alert.leftTitle = self.leftTitle;
    }
    [self.view addSubview:alert];
    
    alert.callback = ^(BOOL isleft) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        if([self.delegate respondsToSelector:@selector(alertshareDeleteVC:isleftClick:)]){
            [self.delegate alertshareDeleteVC:self isleftClick:isleft];
        }
    };
    
    [alert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
        make.height.equalTo(@185);
        make.width.equalTo(@291);
    }];
    
    alert.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.3 animations:^{
        alert.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void) share_decodeView{
    ShareDecodeView *alert = [[ShareDecodeView alloc] initWithFrame:CGRectZero];
    alert.layer.cornerRadius = 20;
    alert.backgroundColor = [UIColor hexStringToColor:@"#000000"];
    if(self.alert_decodeTitle) alert.labelContent.text = self.alert_decodeTitle;
    
    [self.view addSubview:alert];
    
    [alert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@90);
        make.right.equalTo(@(-90));
        make.height.equalTo(@40);
        make.centerY.equalTo(self.view);
    }];
    
    /** 如果是下载的话展示下载动画按钮 */
    if(!self.alert_decodeTitle){
        [self.view addSubview:self.btnDownloadAnimation];
        [self.btnDownloadAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-20));
            make.bottom.equalTo(@(-60));
            make.width.height.equalTo(@(50));
        }];
        [self addaniamtion];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.btnDownloadAnimation.imageView.layer removeAllAnimations];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    });
}

- (void) share_backUP{
    ShareChooseBackUpView *alert = [[ShareChooseBackUpView alloc] initWithFrame:CGRectZero];
    alert.backgroundColor = [UIColor whiteColor];
    alert.layer.cornerRadius = 15;
    if(self.is_cloud_backup){
        alert.btnRight.labelName.text = [@"个人空间" language];
        alert.btnRight.MyImageView.image = [UIImage imageNamed:@"云-1"];
    }
    [self.view addSubview:alert];
    
    alert.callbackisLeft = ^(BOOL isleft) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        if([self.delegate respondsToSelector:@selector(alertshareBackupVC:isleftClick:)]){
            [self.delegate alertshareBackupVC:self isleftClick:isleft];
        }
    };
    
    [alert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.right.equalTo(@(-40));
        make.height.equalTo(@(130));
        make.centerY.equalTo(self.view);
    }];
}

//MARK:-----------给下载按钮添加动画-------------//
- (void) addaniamtion{
    CABasicAnimation* caBasePosition = [CABasicAnimation animation];
    caBasePosition.duration = 0.5;
    caBasePosition.keyPath = @"position";
    caBasePosition.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.btnDownloadAnimation.imageView.center.x, 15)];
    caBasePosition.toValue = [NSValue valueWithCGPoint:CGPointMake(self.btnDownloadAnimation.imageView.center.x, 30)];
    caBasePosition.removedOnCompletion = NO;
    caBasePosition.repeatCount = 100;
    caBasePosition.fillMode = kCAFillModeForwards;
    [self.btnDownloadAnimation.imageView.layer addAnimation:caBasePosition forKey:nil];
}

- (UIButton *)btnDownloadAnimation{
    if(!_btnDownloadAnimation){
        _btnDownloadAnimation = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDownloadAnimation setImage:[UIImage imageNamed:@"download_animation"] forState:UIControlStateNormal];
        _btnDownloadAnimation.layer.cornerRadius = 25;
        _btnDownloadAnimation.layer.borderWidth = 2.0;
        _btnDownloadAnimation.layer.borderColor = MainColor.CGColor;
        _btnDownloadAnimation.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _btnDownloadAnimation.backgroundColor = [UIColor clearColor];
    }
    return _btnDownloadAnimation;
}

@end
