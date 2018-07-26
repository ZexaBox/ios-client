//
//  CloudUploadVedioViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/11.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "CloudUploadVedioViewController.h"
#import "URLRequest.h"
#import <MJRefresh.h>
#import "VedioCell.h"
#import "AlertViewController.h"
#import "ExternalSMSViewController.h"
@interface CloudUploadVedioViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) NSMutableArray *arrayFinishData;
@property (nonatomic,strong) NSString *stringCode;
@end

@implementation CloudUploadVedioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.labelTitle.text = [@"选择上传视频" language];
    if([self.filetype isEqualToString:@"video"]){
        self.labelTitle.text = [@"选择上传视频" language];
    }else if([self.filetype isEqualToString:@"text"]){
        self.labelTitle.text = [@"选择上传文档" language];
    }else{
        self.labelTitle.text = [@"选择上传音乐" language];
    }
    /** 添加上拉刷新 */
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [self.btnRight setTitle:[@"完成" language] forState:UIControlStateNormal];
    self.btnRight.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.btnRight setTitleColor:MainTextColor forState:UIControlStateNormal];
    [self.btnRight addTarget:self action:@selector(right_action) forControlEvents:UIControlEventTouchUpInside];
    [self requestData];
}

- (void) right_action{

}

- (void) upload_Png{
    if(self.arrayFinishData.count == 0){
        [FaceAlertTool svpShowSuccessInfo:@"上传成功"];
        if(self.callbackreload) self.callbackreload();
        [self.collectionView reloadData];
        return;
    }
    [FaceAlertTool svpShowWithState:[NSString stringWithFormat:@"%@%ld%@",[@"正在上传" language],self.arrayFinishData.count,[@"个文件" language]]];
    PngModel *model = self.arrayFinishData[0];
    [URLRequest requestJSON:POST urlString:url_cloud_upload param:@{@"id":model.id} finish:^(id response, NSError *error) {
        [self.arrayFinishData removeObjectAtIndex:0];
        [self upload_Png];
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                NSLog(@"上传文件到云%@",response);
            }
        }else{
            NSLog(@"上传文件到云出错误了=%@",error);
        }
    }];
}

/** 请求视频数据 */
- (void)requestData{
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    if(self.filetype == nil) self.filetype = @"video";
    [URLRequest requestWithMethod:GET urlString:url_nas_list parameters:@{@"filetype":self.filetype} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        [self.collectionView.mj_footer endRefreshing];
        if(response){
            if([response[@"code"] integerValue] == 0){
                NSArray *array = [[DicToModel dicToModel] modelGetData:response[@"data"] model:[PngModel class]];
                [self.arrayData addObjectsFromArray:array];
                [self.collectionView reloadData];
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
}

/** 上传文件到共享空间 */
- (void) requestToshare{
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    NSMutableArray *array = [NSMutableArray array];
    [self.arrayFinishData enumerateObjectsUsingBlock:^(PngModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject: obj.id];
    }];
    [URLRequest requestJSON:POST urlString:url_sharespace_add param:@{@"file_id":array} finish:^(id response, NSError *error) {
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                [self.arrayFinishData removeAllObjects];
                [self.collectionView reloadData];
                if(self.callbackreload){
                    self.callbackreload();
                }
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"请求服务器失败"];
        }
    }];
}

/** 导入文件到外接设备 */
- (void) external_import{
    NSMutableArray *arrayID = [NSMutableArray array];
    [self.arrayFinishData enumerateObjectsUsingBlock:^(PngModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrayID addObject:obj.id];
    }];
    [FaceAlertTool svpShowWithState:@"请稍后..."];
    NSString *string = @"/";
    if(self.externalModel) string = self.externalModel.path;
    [URLRequest requestJSON:POST urlString:url_external_import_file param:@{@"file_id":arrayID,@"path":string} finish:^(id response, NSError *error) {
        if(response){
            if([[response valueForKey:@"code"] integerValue] == 0){
                NSLog(@"上传外接设备%@",response);
                [self.arrayFinishData removeAllObjects];
                [self.collectionView reloadData];
                [FaceAlertTool svpShowSuccessInfo:@"导入成功"];
            }else{
                [FaceAlertTool svpShowErrorWithMsg:response[@"message"]];
            }
        }else{
            NSLog(@"上传文件到云出错误了=%@",error);
        }
    }];
}

- (void) import_action{
    [FaceAlertTool svpShowWithState:@"验证码发送中..."];
    
    /** 网络请求 */
    [URLRequest requestWithMethod:GET urlString:url_sendsms parameters:@{@"mNumber":[UserInfoManager manager].mobile} finish:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if(response != nil){
            if([[response valueForKey:@"code"] integerValue] == 0){
                NSString *code = [response[@"data"] valueForKey:@"mCode"];
                self.stringCode = code;
                ExternalSMSViewController *vc = [ExternalSMSViewController new];
                vc.stringCode = code;
                vc.callback = ^(NSString *code){
                    [self external_import];
                };
                [self alert:vc];
            }else{
                [FaceAlertTool svpShowErrorWithMsg:[response valueForKey:@"message"]];
            }
        }else{
            [FaceAlertTool svpShowErrorWithMsg:@"服务器请求失败"];
        }
    }];
    
}
//MARK:-----------UICollectionDelegate,dataSource-------------//
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrayData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VedioCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.btnSelected.hidden = NO;
    cell.model = self.arrayData[indexPath.row];
    if([self.filetype isEqualToString:@"video"]){
        cell.btnPlay.hidden = NO;
    }else{
        cell.btnPlay.hidden = YES;
    }
    if([self.filetype isEqualToString:@"audio"]){
        cell.headImageView.image = [UIImage imageNamed:@"music"];
    }
    if([self.filetype isEqualToString:@"text"]){
        cell.headImageView.image = [UIImage imageNamed:@"word"];
    }
    if([self.arrayFinishData containsObject:cell.model]){
        cell.btnSelected.selected = YES;
    }else{
        cell.btnSelected.selected = NO;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VedioCell *cell = (VedioCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.btnSelected.selected = !cell.btnSelected.selected;
    if(cell.btnSelected.selected){
        [self.arrayFinishData addObject:self.arrayData[indexPath.row]];
    }else{
        [self.arrayFinishData removeObject:self.arrayData[indexPath.row]];
    }
}
//MARK:-----------懒加载-------------//
- (UICollectionViewFlowLayout *)layout{
    if(!_layout){
        _layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = ([UIScreen mainScreen].bounds.size.width-70) / 3.0;
        _layout.itemSize = CGSizeMake(width, 130);
        _layout.minimumLineSpacing = 10;
        _layout.minimumInteritemSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.sectionInset = UIEdgeInsetsMake(0,10,0,10);
    }
    return _layout;
}
- (UICollectionView *)collectionView{
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"VedioCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (NSMutableArray *)arrayFinishData{
    if(!_arrayFinishData){
        _arrayFinishData = [NSMutableArray array];
    }
    return _arrayFinishData;
}

- (NSMutableArray *)arrayData{
    if(!_arrayData){
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}
@end
