//
//  UIImage+reloadImage.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/8.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "UIImage+reloadImage.h"

@implementation UIImage (reloadImage)


- (UIImage *)scaleImage:(UIImage *)image{
    //确定压缩后的size
    CGFloat scaleWidth = image.size.width;
    CGFloat scaleHeight = image.size.height;
    CGSize scaleSize = CGSizeMake(scaleWidth, scaleHeight);
    //开启图形上下文
    UIGraphicsBeginImageContext(scaleSize);
    //绘制图片
    [image drawInRect:CGRectMake(0, 0, scaleWidth, scaleHeight)];
    //从图形上下文获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    return newImage;
}
@end
