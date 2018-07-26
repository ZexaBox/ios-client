//
//  ShareChooseBackUpView.h
//  zeyun
//
//  Created by 邹琳 on 2018/4/28.
//  Copyright © 2018年 邹琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentBtn.h"
@interface ShareChooseBackUpView : UIView
@property (nonatomic,strong) CommentBtn *btnLeft;
@property (nonatomic,strong) CommentBtn *btnRight;
@property (nonatomic,copy) void (^callbackisLeft)(BOOL isleft);
@end
