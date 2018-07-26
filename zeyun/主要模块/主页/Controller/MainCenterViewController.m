//
//  MainCenterViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/26.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "MainCenterViewController.h"
#import "CommentBtn.h"
#import "MainCell.h"
#import "MainHeadCell.h"
#import "UploadViewController.h"
#import "PersonViewController.h"
#import "UIViewController+Push.h"
#import "SettingViewController.h"
#import "NSString+iOSVersion.h"
#import "URLRequest.h"
#import "ImagePickerViewController.h"
#import "BindViewController.h"
#import <QBImagePickerController.h>
#import "CloudUploadVedioViewController.h"
#import "CloudUploadImageViewController.h"
#import "ZLPhotoManager.h"
#import "CloudFileListViewController.h"
#import "NXAButton.h"

@interface MainCenterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPopoverPresentationControllerDelegate,QBImagePickerControllerDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topVIew;
@property (weak, nonatomic) IBOutlet UIView *centerView;

@property (nonatomic,strong) CommentBtn *btnClound;
@property (nonatomic,strong) CommentBtn *btnCenter;

@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSArray *arrayTitle;
@property (nonatomic,strong) NSArray *arrayImg;

@property (nonatomic,strong) NSArray *arrayTitle1;
@property (nonatomic,strong) NSArray *arrayImg1;

@property (nonatomic,strong) UploadViewController *uploadVC;

/** 是否是个人中心 */
@property (nonatomic,assign) BOOL iscenter;

@property (nonatomic,strong) NSMutableArray *arrayVideoBackup;
@property (nonatomic,strong) NSMutableArray *arrayImageBackup;

@property (nonatomic,strong) ZLPhotoManager *photoManager;

//重构界面
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MainCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 设置数据源 */
    [self setupData];
    
    /** 设置UI */
    [self setupUI];
    
    if (@available(iOS 11.0, *)) { self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; } else { self.automaticallyAdjustsScrollViewInsets = NO; }
    

    
    self.arrayVideoBackup = [NSMutableArray array];
    self.arrayImageBackup = [NSMutableArray array];
    self.photoManager = [[ZLPhotoManager alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backup_action:) name:@"USER_BACKUP_FILE" object:nil];
    /** 设备绑定 */
    if([[UserInfoManager manager].status isEqualToString:@"0"]){
        [self.navigationController pushViewController:[BindViewController new] animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}


- (void)setupUI{
    [self.topVIew mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@49);
        make.height.equalTo(@1);
        make.left.right.equalTo(self.view);
    }];
    
    self.btnClound = [[CommentBtn alloc] initWithFrame:CGRectZero];
    self.btnCenter = [[CommentBtn alloc] initWithFrame:CGRectZero];
    self.btnClound.labelName.font = [UIFont systemFontOfSize:14];
    self.btnCenter.labelName.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.btnClound];
    [self.view addSubview:self.btnCenter];
//    [self.view addSubview:self.collectionView];
    
    [self.btnCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topVIew.mas_bottom).offset(6);
        make.left.equalTo(self.view);
        make.height.equalTo(@43);
        make.right.equalTo(self.centerView);
    }];
    
    [self.btnClound mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topVIew.mas_bottom).offset(6);
        make.right.equalTo(self.view);
        make.height.equalTo(@43);
        make.left.equalTo(self.centerView);
    }];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@(-21));
//        make.left.equalTo(@(-2));
//        make.right.equalTo(@(2));
//        make.bottom.equalTo(self.topVIew.mas_top);
//    }];

    [self.btnClound addTarget:self action:@selector(clound_action:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCenter addTarget:self action:@selector(center_action:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnClound.MyImageView.image = [UIImage imageNamed:@"首页-云未选中"];
    self.btnCenter.MyImageView.image = [UIImage imageNamed:@"个人中心-选中"];
    self.btnCenter.labelName.text = [@"个人中心" language];
    self.btnClound.labelName.text = [@"云" language];
    self.btnCenter.labelName.textColor = MainColor;
    self.btnClound.labelName.textColor = [UIColor hexStringToColor:@"#939393"];
    
}

/** 设置数据源 */
- (void) setupData{
    self.iscenter = YES;
    self.arrayImg = @[@"",@"图片",@"视频",@"文档",@"音乐",@"空间共享",@"实时摄像头",@"面对面快传",@"手机备份",@"外接设备"];
    self.arrayTitle = @[@"",[@"图片" language],[@"视频" language],[@"文档" language],[@"音乐" language],[@"空间共享" language],[@"实时摄像头" language],[@"面对面快传" language],[@"手机备份" language],[@"外接设备" language]];
    
    self.arrayImg1 = @[@"",@"图片",@"视频",@"文档",@"音乐"];
    self.arrayTitle1 = @[@"",[@"图片" language],[@"视频" language],[@"文档" language],[@"音乐" language]];
    
}

//MARK:-----------action-------------//


- (void)btnAction:(NXAButton *)sender{
    
    if(self.iscenter){
        [self pushWithIdentifer:self.arrayTitle[sender.tag - 100 + 1]];
    }else{
        CloudFileListViewController *vc = [CloudFileListViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        vc.stringFileType = self.arrayTitle1[sender.tag - 100 - self.arrayImg.count + 2 ];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) clound_action:(CommentBtn *)sender{
    [self clearBtn];
    self.iscenter = NO;
    sender.MyImageView.image = [UIImage imageNamed:@"首页-云选中"];
    sender.labelName.textColor = MainColor;
//    self.arrayImg = @[@"",@"图片",@"视频",@"文档",@"音乐"];
//    self.arrayTitle = @[@"",[@"图片" language],[@"视频" language],[@"文档" language],[@"音乐" language]];

//    [self.collectionView reloadData];
    self.centerLabel.text = [@"云" language];
    
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    }];
    
}

- (void) center_action:(CommentBtn *)sender{
    [self clearBtn];
    self.iscenter = YES;
//    self.arrayImg = @[@"",@"图片",@"视频",@"文档",@"音乐",@"空间共享",@"实时摄像头",@"面对面快传",@"手机备份",@"外接设备"];
//    self.arrayTitle = @[@"",[@"图片" language],[@"视频" language],[@"文档" language],[@"音乐" language],[@"空间共享" language],[@"实时摄像头" language],[@"面对面快传" language],[@"手机备份" language],[@"外接设备" language]];
//    [self.collectionView reloadData];
    sender.MyImageView.image = [UIImage imageNamed:@"个人中心-选中"];
    sender.labelName.textColor = MainColor;
    
    self.centerLabel.text = [@"个人中心" language];
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

- (void) clearBtn{
    self.btnClound.MyImageView.image = [UIImage imageNamed:@"首页-云未选中"];
    self.btnCenter.MyImageView.image = [UIImage imageNamed:@"个人中心-未选中"];
    self.btnCenter.labelName.textColor = [UIColor hexStringToColor:@"#939393"];
    self.btnClound.labelName.textColor = [UIColor hexStringToColor:@"#939393"];
}

/** 加号按钮点击 */
- (void) right_action:(UIButton *)button{
    UploadViewController *vc = [UploadViewController new];
    CGFloat height = self.iscenter ? 80 : 160;
    vc.view.frame = CGRectMake(0, 0, 151, height);
    vc.modalPresentationStyle = UIModalPresentationPopover;//配置推送类型
    vc.preferredContentSize = vc.view.bounds.size;//设置弹出视图大小必须好推送类型相同
    UIPopoverPresentationController *pover = vc.popoverPresentationController;
    pover.barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [pover setSourceView:button];//设置目标视图，这两个是必须设置的。
    pover.delegate = self;
    [self presentViewController:vc animated:YES completion:^{
        if(self.iscenter){
            vc.arrayImg = @[@"上传图片",@"上传视频"];
            vc.arrayData = @[[@"上传图片" language],[@"上传视频" language]];
        }else{
            vc.arrayImg = @[@"上传图片",@"上传视频",@"上传文档",@"上传音乐"];
            vc.arrayData = @[[@"上传图片" language],[@"上传视频" language],[@"上传文档" language],[@"上传音乐" language]];
        }
    }];//弹出视图
    vc.callback = ^(NSString *title, NSInteger row) {
        [self upload_action:title];
    };
    self.uploadVC = vc;
}



- (void) upload_action:(NSString *)title{
    
}

//MARK:-----------qbimagepicker delegate-------------//
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets{
    [FaceAlertTool svpShowInfo:@"文件已经添加至上传列表"];
    if(imagePickerController.mediaType == QBImagePickerMediaTypeVideo){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHOOSE_IMAGE_FINISH" object:@{@"video":assets}];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        /** 0 表示默认将图片默认传入到我的相册 */
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHOOSE_IMAGE_FINISH" object:@{@"0":assets}];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//MARK:-----------popviewvc delegate-------------//
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}
/** 个人中心点击 */
- (void)left_action{
    [self.uploadVC dismissViewControllerAnimated:NO completion:nil];
    PersonViewController *vc = [PersonViewController new];
    vc.callback = ^(NSString *title) {
        [self pushWithIdentifer:title];
    };
    vc.view.frame = self.view.bounds;
    vc.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
}



//MARK:-----------UICollectionDelegate,dataSource-------------//
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrayImg.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        MainHeadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell2" forIndexPath:indexPath];
        cell.labelCenter.text = self.iscenter ? [@"个人中心" language]:[@"云" language];
        cell.callbackRight = ^(UIButton *btn){  [self right_action:btn]; };
        cell.callbackLeft = ^{ [self left_action]; };
        return cell;
    }
    MainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.strinImage = self.arrayImg[indexPath.row];
    cell.stringName = self.arrayTitle[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0) return;
    if(self.iscenter){
        [self pushWithIdentifer:self.arrayTitle[indexPath.row]];
    }else{
        CloudFileListViewController *vc = [CloudFileListViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        vc.stringFileType = self.arrayTitle[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return CGSizeMake(SCREEN_WIDTH, 230);
    }
    return CGSizeMake(106, 96);
}

//MARK:-----------懒加载-------------//
- (UICollectionViewFlowLayout *)layout{
    if(!_layout){
        _layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = 106;
        CGFloat magin = (SCREEN_WIDTH- width * 3) / 2.0;
        _layout.itemSize = CGSizeMake(width, 96);
        _layout.minimumLineSpacing = 30;
        _layout.minimumInteritemSpacing = magin;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    }
    return _layout;
}
- (UICollectionView *)collectionView{
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
         [_collectionView registerNib:[UINib nibWithNibName:@"MainCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"MainHeadCell" bundle:nil] forCellWithReuseIdentifier:@"cell2"];
    }
    
    return _collectionView;
}

@end
