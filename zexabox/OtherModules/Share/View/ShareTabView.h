//
//  ShareTabView.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentBtn.h"
@interface ShareTabView : UIView

@property (nonatomic,copy) void (^callback)(CommentBtn *btn);
@end
