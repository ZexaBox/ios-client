//
//  FileCommonController.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "ZLBaseViewController.h"
#import "ShareTabView.h"
#import "PngTableViewController.h"
#import "SearchViewController.h"
#import "PngFileDateViewController.h"
#import "PngCopyViewController.h"
#import "AlertViewController.h"
#import "PngModel.h"

typedef void(^selectBlock)(BOOL allSelect);
typedef void(^cancelBlock)(void);

@interface FileCommonController : ZLBaseViewController

@property (nonatomic,assign) BOOL isshow_choose;

@property (nonatomic,strong) ShareTabView *tab;

@property (nonatomic, strong) UIView *navSelectView;    //导航栏全选、取消选中界面

@property (nonatomic, strong) UIButton *selectBtn;      //全选按钮
@property (nonatomic, strong) UIButton *cancelBtn;      //取消按钮

@property (nonatomic, copy) selectBlock sBlock;     //选中按钮传值block
@property (nonatomic, copy) cancelBlock cBlock;     //取消按钮传值block


/** 设置右上角菜单 */
@property (nonatomic,strong) NSArray *arrayRightMenu;

/** 总数据 */
@property (nonatomic,strong) NSMutableArray *arrayData;

/** 需要下载的数据 */
@property (nonatomic,strong) NSMutableArray *arrayDown;

/** 搜索按钮 */
@property (nonatomic,strong) UIButton *p_search_btn;

/** 是否是共享空间继承此类 */
@property (nonatomic,assign) BOOL is_share_space;

/** 是否是云空间 */
@property (nonatomic,assign) BOOL is_cloud_space;

/** 下载、分享、删除、备份、点击 */
- (void) tab_action:(CommentBtn *)sender;

/** 右上角菜单点击 */
- (void) choose_action:(NSString *)title;

/** 搜索按钮点击 */
- (void) search_action;

/** 删除完成的回调 */
- (void) del_data_reload;

/** 刷新数据：给子类调用 */
- (void) data_refresh;

/** 删除文件、或者删除文件夹，删除文件夹时覆盖此方法。删除文件全部走这个方法 */
- (void) del_file;
@end
