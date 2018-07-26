//
//  NSString+Language.m
//  zeyun
//
//  Created by 邹琳 on 2018/6/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "NSString+Language.h"

@implementation NSString (Language)

- (NSString *)language{
    return [InternationalControl getString:self];
}
@end
