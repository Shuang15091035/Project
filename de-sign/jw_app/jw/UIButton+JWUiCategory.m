//
//  UIButton+JWUiCategory.m
//  June Winter
//
//  Created by GavinLo on 15/1/5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "UIButton+JWUiCategory.h"
#import "JWResourceBundle.h"
#import "UIImage+JWImageUtils.h"
#import "NSString+JWCoreCategory.h"
#import "JWLayout.h"
#import "UIView+JWUiLayout.h"
#import <jw/JCFlags.h>
#import <jw/JCMath.h>

@implementation UIButton (JWUiCategory)

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    self = [super init];
    if (self != nil) {
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    self = [super init];
    if (self != nil) {
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:selectedImage forState:UIControlStateSelected];
    }
    return self;
}

- (NSString *)text {
    return self.currentTitle;
}

- (void)setText:(NSString *)text {
    [self setTitle:text forState:UIControlStateNormal];
    if ([self.superview isKindOfClass:[JWLayout class]] && (self.hasLayoutParams && self.layoutParams.enabled)) {
        [self.superview setNeedsLayout];
    }
}

- (UIColor *)textColor {
    return self.currentTitleColor;
}

- (void)setTextColor:(UIColor *)textColor {
    [self setTitleColor:textColor forState:UIControlStateNormal];
    if ([self.superview isKindOfClass:[JWLayout class]] && (self.hasLayoutParams && self.layoutParams.enabled)) {
        [self.superview setNeedsLayout];
    }
}

- (CGFloat)buttonTextSize {
    return self.titleLabel.labelTextSize;
}

- (void)setButtonTextSize:(CGFloat)buttonTextSize {
    self.titleLabel.labelTextSize = buttonTextSize;
}

- (JWTextStyle)buttonTextStyle {
    return self.titleLabel.labelTextStyle;
}

- (void)setButtonTextStyle:(JWTextStyle)buttonTextStyle {
    self.titleLabel.labelTextStyle = buttonTextStyle;
}

- (void)setBackgroundDrawable:(NSString *)drawable
{
    [self setBackgroundDrawable:drawable withOptions:nil];
}

- (void)setBackgroundDrawable:(NSString *)drawable withOptions:(JWImageOptions *)options
{
    BOOL isNinePatch = NO;
    NSString* suffix = [drawable pathExtension];
    if([drawable contains:@".9."])
    {
        drawable = [drawable substringToIndex:(drawable.length - suffix.length - 3)];
        isNinePatch = YES;
    }
    else
    {
        drawable = [drawable substringToIndex:(drawable.length - suffix.length - 1)];
    }
    NSString* nameNormal = isNinePatch ? [NSString stringWithFormat:@"%@_n.9.%@", drawable, suffix] : [NSString stringWithFormat:@"%@_n.%@", drawable, suffix];
    UIImage* imageNormal = [UIImage imageByResourceDrawable:nameNormal withOptions:options];
//    if(imageNormal == nil)
//        imageNormal = [UIImage imageByResourceDrawable:name withOptions:options];
    [self setBackgroundImage:imageNormal forState:UIControlStateNormal];
    
    NSString* namePress = isNinePatch ? [NSString stringWithFormat:@"%@_p.9.%@", drawable, suffix] : [NSString stringWithFormat:@"%@_p.%@", drawable, suffix];
    UIImage* imagePress = [UIImage imageByResourceDrawable:namePress withOptions:options];
    [self setBackgroundImage:imagePress forState:UIControlStateHighlighted];
}

- (CGSize)contentSizeWithOptions:(JWUiFitOptions)options {
    CGRect frame = self.frame;
    CGFloat newWidth = frame.size.width;
    CGFloat newHeight = frame.size.height;
    CGSize bgSize = CGSizeZero;
    CGSize fgSize = CGSizeZero;
    if (self.currentBackgroundImage != nil) {
        bgSize = self.currentBackgroundImage.size;
    }
    if (self.currentImage != nil) {
        fgSize = self.currentImage.size;
    }
    if (self.titleLabel != nil) {
        CGSize textSize = [self.titleLabel measureText];
        fgSize.width += textSize.width;
    }
    if (JCFlagsTest(options, JWUiFitOptionWidth)) {
        newWidth = bgSize.width > fgSize.width ? bgSize.width : fgSize.width;
    }
    if (JCFlagsTest(options, JWUiFitOptionHeight)) {
        newHeight = bgSize.height > fgSize.height ? bgSize.height : fgSize.height;
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
