//
//  PngCell.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "PngCell.h"
#import <UIImageView+WebCache.h>
@implementation PngCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(PngModel *)model{
    _model = model;
    NSString *url;
//    if(self.isCloud){
//        url = BaseCloudURL;
//    }else{
        url = BaseImageURL;
//    }
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url,model.thumbnail]] placeholderImage:[UIImage imageNamed:@"热门图片"]];
    self.labelName.text = model.name;
}
@end
