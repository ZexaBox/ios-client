//
//  MobilImageReusableView.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/30.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobilImageReusableView : UICollectionReusableView

@property (nonatomic,copy) void (^callback)(BOOL isopen);
@end
