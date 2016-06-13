//
//  UISlider+JWUiCategory.m
//  jw_app
//
//  Created by mac zdszkj on 16/6/1.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "UISlider+JWUiCategory.h"
#import <jw/JCFlags.h>
#import <jw/JCMath.h>

@implementation UISlider (JWUiCategory)

- (CGSize)contentSizeWithOptions:(JWUiFitOptions)options {
    CGRect frame = self.frame;
    CGFloat newWidth = frame.size.width;
    CGFloat newHeight = frame.size.height;
    CGSize thumbSize = CGSizeZero;
    if (self.currentThumbImage != nil) {
        thumbSize = self.currentThumbImage.size;
    }
    if (JCFlagsTest(options, JWUiFitOptionWidth)) {
        newWidth = thumbSize.width;
    }
    if (JCFlagsTest(options, JWUiFitOptionHeight)) {
        newHeight = thumbSize.height;
    }
    return CGSizeMake(newWidth, newHeight);
}

- (void)fitContentWithOptions:(JWUiFitOptions)options {
    CGRect frame = self.frame;
    CGSize newSize = [self contentSizeWithOptions:options];
    // NOTE 防止多次调用layoutSubviews
    if (!JCEqualsfe(newSize.width, frame.size.width, 1.0f) || !JCEqualsfe(newSize.height, frame.size.height, 1.0f)) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, newSize.width, newSize.height);
    }
}

@end
