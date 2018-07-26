//
//  LuanchViewController.m
//  LuanchVC
//
//  Created by 廖尧 on 2016/10/14.
//  Copyright © 2016年 廖尧. All rights reserved.
//

#import "LuanchViewController.h"
#import "LoginPwdViewController.h"
#import "NavigationController.h"
#define KScreen [UIScreen mainScreen].bounds.size

@interface LuanchViewController ()<UIScrollViewDelegate>
{
    int j;
}
@property (nonatomic,strong)UIScrollView *luanchScro;

@property (nonatomic,strong)UIView *luanchBcView;

@property (nonatomic, strong) NSMutableArray *imgArr;

@property (nonatomic,strong)UIPageControl *luanchPage;

@property (nonatomic,assign) BOOL isjump;//是否已经跳转

@end

@implementation LuanchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imgArr = [NSMutableArray array];
    [self.imgArr addObject:@"引导页1"];
    [self.imgArr addObject:@"引导页2"];
    [self.imgArr addObject:@"引导页3"];
    j= 0;
    //图片数组
    [self setGuidePage:self.imgArr.count];
    //    [self initTimer];
    
}

/**
 *  设置引导页
 *
 *  @param num 引导页数
 */
-(void)setGuidePage:(NSInteger)num{
    
    if (num > 0) {
        
        //底部View
        _luanchBcView = [[UIView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:_luanchBcView];
        
        _luanchScro = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _luanchScro.contentSize = CGSizeMake(_luanchScro.bounds.size.width * self.imgArr.count, _luanchScro.bounds.size.height);
        _luanchScro.bounces = NO;
        _luanchScro.pagingEnabled = YES;
        _luanchScro.showsHorizontalScrollIndicator = NO;
        // 隐藏垂直方向的滚动条
        _luanchScro.showsVerticalScrollIndicator = NO;
        _luanchScro.delegate = self;
        // 锁定方向，当确定一个方向之后就不能向另外一个方向滑动
        _luanchScro.directionalLockEnabled = YES;
        
        [_luanchBcView addSubview:_luanchScro];
        
        [self addPage:self.imgArr.count];
        
        //加入图片
        for (int i = 0; i < self.imgArr.count; i++)
        {
            
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_luanchScro.bounds.size.width * i, 0, _luanchScro.bounds.size.width, _luanchScro.bounds.size.height)];
            //网络请求的图片
            //        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imgArr[i]] placeholderImage:[UIImage imageNamed:@"banner"]];
            imageView.image = [UIImage imageNamed:self.imgArr[i]];
            
            imageView.userInteractionEnabled = YES;
            [_luanchScro addSubview:imageView];
            
            //        //跳过按钮
            
            if (i == (self.imgArr.count-1))
            {
                //进入按钮
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                
                
                [but setTitle:@"立即体验" forState:UIControlStateNormal];
                [but addTarget:self action:@selector(butAction) forControlEvents:UIControlEventTouchUpInside];
                but.titleLabel.font = [UIFont systemFontOfSize:15];
                [but setTitleColor:MainColor forState:UIControlStateNormal];
                [but setBackgroundColor:[UIColor whiteColor]];
                but.layer.cornerRadius = 20;
                but.layer.borderColor = MainColor.CGColor;
                but.layer.borderWidth = 1.0;
                [imageView addSubview:but];
                
                [but mas_makeConstraints:^(MASConstraintMaker *make)
                 {
                     make.centerX.equalTo(imageView);
                     make.bottom.equalTo(self.luanchPage.mas_top).offset(-10);
                     make.width.equalTo(@150);
                     make.height.equalTo(@40);
                 }];
                
                
                
                //            UIButton *jump = [UIButton buttonWithType:UIButtonTypeSystem];
                //
                //            jump.frame = CGRectMake(KScreen.width/375*300+KScreen.width*i-15, KScreen.height/667*20, 100*KScreen.width/375, 30*KScreen.height/667);
                //
                //            [jump setTitle:@"跳过" forState:UIControlStateNormal];
                //            [jump addTarget:self action:@selector(butAction) forControlEvents:UIControlEventTouchUpInside];
                //            jump.titleLabel.font = [UIFont systemFontOfSize:16];
                //            [jump setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                //            [_luanchScro addSubview:jump];
                
            }
            
        }
    }
    else{
        [self butAction];
    }
    
}

//加入page
- (void)addPage:(NSInteger)num
{
    //page视图
    _luanchPage = [UIPageControl new];
    
    //设置页数
    _luanchPage.numberOfPages = num;
    //当前page的颜色
    _luanchPage.currentPageIndicatorTintColor = MainColor;
    
    _luanchPage.pageIndicatorTintColor = [UIColor lightGrayColor];
    
    [_luanchBcView addSubview:_luanchPage];
    
    [_luanchPage mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX .equalTo(self.luanchBcView);
         make.bottom.equalTo(self.luanchBcView.mas_bottom).offset(-20);
         make.width.equalTo(@60);
         make.height.equalTo(@30);
     }];
}
#pragma mark - 定时器
//创建定时器
- (void)initTimer
{
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerChanged) userInfo:nil repeats:YES];
}
//定时器执行的方法
- (void)timerChanged
{
    if (j <= 2)
    {
        j++;
    }
    if (_luanchScro.contentOffset.x < 2 *_luanchScro.bounds.size.width)
    {
        // 改变scrollView的偏移量
        [_luanchScro setContentOffset:CGPointMake(j * _luanchScro.bounds.size.width, 0) animated:YES];
    }
}
#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取当前的点
    float currIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
    // 修改当前点
    
    if (currIndex <= 2) {
        _luanchPage.currentPage = currIndex;
    }
    else {
        if (self.isjump == NO) {
            self.isjump = YES;
            [self butAction];
            
        }
        
    }
    
}

- (void)butAction
{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[NavigationController alloc] initWithRootViewController:[LoginPwdViewController new]];
}



@end
