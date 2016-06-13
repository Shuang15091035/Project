//
//  JWFrameLayout.m
//  June Winter
//
//  Created by GavinLo on 14/12/19.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWFrameLayout.h"
#import "UIView+JWUiLayout.h"
#import <jw/UIScreen+JWCoreCategory.h>

@implementation JWFrameLayout

- (void)layoutSubviews {
    if (!self.superview.hasLayoutParams) { // 如果父层不是layout框架中的控件，则首先处理自己
        [JWLayout handleWidthHeightForView:self];
    }
    for (UIView* child in self.subviews) {
        [JWLayout handleWidthHeightForView:child];
        [JWLayout handleAlignmentForView:child];
    }
}

@end
