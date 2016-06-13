//
//  UIImageView+JWUiCategory.m
//  June Winter
//
//  Created by GavinLo on 15/1/6.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "UIImageView+JWUiCategory.h"
#import <jw/JCFlags.h>
#import <jw/JCMath.h>
#import "JWLayout.h"
#import "UIView+JWUiLayout.h"
#import <objc/runtime.h>

@implementation UIImageView (JWUiCategory)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod([self class], @selector(setImage:)), class_getInstanceMethod([self class], @selector(setImageOrigin:)));
        method_exchangeImplementations(class_getInstanceMethod([self class], @selector(setImageByLayout:)), class_getInstanceMethod([self class], @selector(setImage:)));
    });
}

- (void) setImageOrigin:(UIImage *)image
{
    // exchange setImage implementation
}

- (void)setImageByLayout:(UIImage *)image
{
    [self setImageOrigin:image];
    if ([self.superview isKindOfClass:[JWLayout class]] && (self.hasLayoutParams && self.layoutParams.enabled)) {
        [self.superview setNeedsLayout];
    }
}

- (void)fitImageWithOptions:(JWUiFitOptions)options {
    CGRect frame = self.frame;
    CGFloat newWidth = frame.size.width;
    CGFloat newHeight = frame.size.height;
    UIImage* image = self.image;

    if (JCFlagsTest(options, JWUiFitOptionWidth)) {
        if (image != nil) {
            newWidth = image.size.width;
        }
    }
    if (JCFlagsTest(options, JWUiFitOptionHeight)) {
        if (image != nil) {
            newHeight = image.size.height;
        }
    }
    
    // NOTE 防止多次调用layoutSubviews
    if (!JCEqualsfe(newWidth, frame.size.width, 1.0f) || !JCEqualsfe(newHeight, frame.size.height, 1.0f)) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, newWidth, newHeight);
    }
}

@end
