//
//  UIView+JWUiLayout.m
//  June Winter
//
//  Created by GavinLo on 14/12/19.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "UIView+JWUiLayout.h"
#import "JWCategoryVariables.h"
#import "JWLayout.h"
#import "UIView+JWUiLayout.h"
#import "UIDevice+JWCoreCategory.h"

@implementation UIView (JWUiLayout)

- (BOOL)hasLayoutParams {
    JWLayoutParams* lp = [JWCategoryVariables getExtraFromTarget:self byClass:[JWLayoutParams class]];
    return lp != nil;
}

- (JWLayoutParams *)layoutParams {
    JWLayoutParams* lp = [JWCategoryVariables hackTarget:self byClass:[JWLayoutParams class]];
    lp.view = self;
    return lp;
}

- (CGFloat)outerWidth {
    CGRect frame = self.frame;
    JWLayoutParams* lp = self.layoutParams;
    CGFloat outerWidth = lp.marginLeft + frame.size.width + lp.marginRight;
    return outerWidth;
}

- (void)setOuterWidth:(CGFloat)outerWidth {
    // TODO
}

- (CGFloat)outerHeight {
    CGRect frame = self.frame;
    JWLayoutParams* lp = self.layoutParams;
    CGFloat outerHeight = lp.marginTop + frame.size.height + lp.marginBottom;
    return outerHeight;
}

- (void)setOuterHeight:(CGFloat)outerHeight {
    // TODO
}

- (CGFloat)innerWidth {
    CGRect frame = self.frame;
    JWLayoutParams* lp = self.layoutParams;
    CGFloat innerWidth = frame.size.width - lp.paddingLeft - lp.paddingRight;
    return innerWidth;
}

- (void)setInnerWidth:(CGFloat)innerWidth {
    // TODO
}

- (CGFloat)innerHeight {
    CGRect frame = self.frame;
    JWLayoutParams* lp = self.layoutParams;
    CGFloat innerHeight = frame.size.height - lp.paddingTop + lp.paddingBottom;
    return innerHeight;
}

- (void)setInnerHeight:(CGFloat)innerHeight {
    // TODO
}

- (BOOL)visible
{
    return !self.isHidden;
}

- (void)setVisible:(BOOL)visible {
    self.hidden = !visible;
    if ([self.superview isKindOfClass:[JWLayout class]] && (self.hasLayoutParams && self.layoutParams.enabled)) {
        [self.superview setNeedsLayout];
    }
}

@end
