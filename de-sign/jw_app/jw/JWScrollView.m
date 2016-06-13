//
//  JWScrollView.m
//  June Winter
//
//  Created by GavinLo on 15/1/6.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWScrollView.h"
#import "UIView+JWUiLayout.h"
#import "JWLayout.h"

@implementation JWScrollView

- (void)layoutSubviews {
    if (!self.superview.hasLayoutParams) { // 如果父层不是layout框架中的控件，则首先处理自己
        [JWLayout handleWidthHeightForView:self];
    }
    CGSize contentSize = CGSizeZero;
    for (UIView* child in self.subviews) {
        [JWLayout handleWidthHeightForView:child];
        [JWLayout handleAlignmentForView:child];
        CGRect frame = child.frame;
        if (frame.size.width > contentSize.width) {
            contentSize.width = frame.size.width;
        }
        if (frame.size.height > contentSize.height) {
            contentSize.height = frame.size.height;
        }
    }
    self.contentSize = contentSize;
}

@end
