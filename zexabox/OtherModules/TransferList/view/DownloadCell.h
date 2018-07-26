//
//  DownloadCell.h
//  zeyun
//
//  Created by 邹琳 on 2018/5/4.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCircularProgressView.h"
#import "PngModel.h"
@interface DownloadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet MRCircularProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelSize;
@property (weak, nonatomic) IBOutlet UILabel *labelSpeed;
@property (weak, nonatomic) IBOutlet UIButton *btnDownState;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;


@property (nonatomic,assign) BOOL isHiddenUpload;
@end
