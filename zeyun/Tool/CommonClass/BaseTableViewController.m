//
//  BaseTableViewController.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/26.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = ZLRGBAColor(239, 239, 239, 1.0);
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(@0);
        make.top.equalTo(self.naviView.mas_bottom);
    }];
}


- (void) addHeadRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
}

- (void) addFootRefresh{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void) registWithNibName:(NSString *)name identifier:(NSString *)identifier{
    [self.tableView registerNib:[UINib nibWithNibName:name bundle:nil] forCellReuseIdentifier:identifier];
}

/** 下拉刷新数据 */
- (void) reloadData{
    
}

/** 上啦刷新数据 */
- (void) loadMoreData{
    
}

- (void) endReshfresh{
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
}


@end
