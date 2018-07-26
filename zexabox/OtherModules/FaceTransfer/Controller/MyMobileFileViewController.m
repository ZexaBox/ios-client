//
//  MyMobileFileViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/30.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "MyMobileFileViewController.h"
#import "MobileListViewController.h"
#import "MobileImageViewController.h"
#import "SendFilesViewController.h"
#import "SocketFileViewController.h"
@interface MyMobileFileViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *lineView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UIButton *fistButton;
@property (weak, nonatomic) IBOutlet UIButton *btnSure;
@property (nonatomic,assign) NSInteger choose_num;
@property (nonatomic,strong) NSMutableArray *arrayFinishData;
@property (weak, nonatomic) IBOutlet UILabel *labelClose;

@property (nonatomic,assign) BOOL isupdate;
@end

@implementation MyMobileFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelTitle.text = [@"本机文件" language];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    
    [self addotherVC];
}

- (void) setupUI{
    self.lineView = [[UIView alloc] initWithFrame:CGRectZero];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.scrollView];
    
    [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@43);
        make.top.equalTo(self.naviView.mas_bottom);
    }];
    [self.stackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitle:[obj.titleLabel.text language] forState:UIControlStateNormal];
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.btnSure.mas_top).offset(-3);
    }];
    self.lineView.bounds = CGRectMake(0, 0, 40, 3);
    self.lineView.backgroundColor = MainColor;
    
    self.arrayFinishData = [NSMutableArray array];
    self.labelClose.text = [@"请与对方保持距离" language];
    [self.btnSure setTitle:[NSString stringWithFormat:@"%@（0）",[@"确定" language]] forState:UIControlStateNormal];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if(!self.isupdate){
        self.isupdate = YES;
        self.lineView.center = CGPointMake(self.fistButton.center.x, CGRectGetMaxY(self.stackView.frame));
    }
}

- (void) addotherVC{
    
    NSArray *array = @[@"Camera",[@"图片" language],[@"文档" language],[@"应用" language],[@"其他" language]];
    
    [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isEqualToString:[@"图片" language]]){
            MobileImageViewController *vc = [MobileImageViewController new];
            __weak typeof(self) weakself = self;
            vc.callback = ^(BOOL isadd,NSDictionary *dic) {
                [weakself changeButtonTitle:isadd dic:dic];
            };
            [self addVcToScrollView:idx vc:vc];
            
        }else{
            MobileListViewController *list = [[MobileListViewController alloc] init];
            list.stringGroup = obj;
            __weak typeof(self) weakself = self;
            list.callback = ^(BOOL isadd,NSDictionary *dic) {
                [weakself changeButtonTitle:isadd dic:dic];
            };
            [self addVcToScrollView:idx vc:list];
        }
    }];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * array.count, 0);
}

- (void) changeButtonTitle:(BOOL) isadd dic:(NSDictionary *)dic{
    if(isadd) {
        self.choose_num += 1;
        [self.arrayFinishData addObject:dic];
    }else{
        self.choose_num -= 1;
        [self.arrayFinishData removeObject:dic];
    }
    
    [self.btnSure setTitle:[NSString stringWithFormat:@"%@（%ld）",[@"确定" language],self.choose_num] forState:UIControlStateNormal];
}

- (void) addVcToScrollView:(NSInteger)idx vc:(UIViewController *)vc{
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(idx * SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetWidth(self.scrollView.frame));
    [self.scrollView addSubview:vc.view];
}

- (IBAction)click_action:(UIButton *)sender {
    [self.stackView.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    sender.selected = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.center = CGPointMake(sender.center.x, CGRectGetMaxY(self.stackView.frame));
    }];
    
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * [self.stackView.subviews indexOfObject:sender], 0) animated:YES];
}
/** 发送文件 */
- (IBAction)send_file_action:(id)sender {
    if(self.choose_num == 0){
        [FaceAlertTool svpShowErrorWithMsg:@"请选择文件"];
        return;
    }
    SendFilesViewController *vc = [[SendFilesViewController alloc] init];
    vc.arrayPath = self.arrayFinishData;
//    SocketFileViewController *vc = [SocketFileViewController new];
//    vc.arraySendData = self.arrayFinishData;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
