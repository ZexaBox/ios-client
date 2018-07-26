//
//  UIImage+Save.m
//  zeyun
//
//  Created by 邹琳 on 2018/5/10.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import "UIImage+Save.h"

@implementation UIImage (Save)


- (void) saveImage{
    
    if (self) {
        
        UIImageWriteToSavedPhotosAlbum(self, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        
    };
    
}
//保存完成后调用的方法
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存图片出错%@", error.localizedDescription);
    }
    else {
        NSLog(@"保存图片成功");
    }
}
@end
