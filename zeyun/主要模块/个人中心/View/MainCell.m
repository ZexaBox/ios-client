//
//  MainCell.m
//  zeyun
//
//  Created by 邹琳 on 2018/4/27.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "MainCell.h"

@interface MainCell()

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@end
@implementation MainCell

- (void)setStringName:(NSString *)stringName{
    _stringName = stringName;
    self.labelName.text = stringName;
}

- (void)setStrinImage:(NSString *)strinImage{
    _strinImage = strinImage;
    self.myImageView.image = [UIImage imageNamed:strinImage];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
