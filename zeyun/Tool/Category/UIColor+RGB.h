//
//  UIColor+RGB.h
//  MeasureApp
//
//  Created by 极联开发 on 16/8/23.
//  Copyright © 2016年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RGB)

+(UIColor *) hexStringToColor: (NSString *) stringToConvert withAlpha:(CGFloat)alpha;

+(UIColor *) hexStringToColor: (NSString *) stringToConvert;

+ (UIColor *)rgbStringToColorRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b  withAlpha:(CGFloat)alpha;

+(UIImage*) createImageWithColor:(UIColor*) color;

@end
