
//
//  JWLayoutParams.m
//  June Winter
//
//  Created by GavinLo on 14/12/19.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWLayoutParams.h"
#import <jw/JCPadding.h>
#import <jw/JCMargin.h>
#import "UIScreen+JWCoreCategory.h"

@interface JWLayoutParams () {
    UIView* mView;
    BOOL mEnabled;
    CGSize mSize;
    CGFloat mWeight;
    JCPadding mPadding;
    JCMargin mMargin;
    JWLayoutAlignment mAlign;
    UIView* mRightOfView;
    UIView* mBelowView;
    UIView* mLeftOfView;
    UIView* mAboveView;
    JWLayoutOrientation mOrientation;
}

@end

@implementation JWLayoutParams

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        mView = nil;
        mEnabled = YES;
        mSize.width = JWLayoutWrapContent;
        mSize.height = JWLayoutWrapContent;
        mWeight = 0.0f;
        mPadding = JCPaddingZero();
        mMargin = JCMarginZero();
        mAlign = JWLayoutAlignParentLeft | JWLayoutAlignParentTop;
        mRightOfView = nil;
        mBelowView = nil;
        mLeftOfView = nil;
        mAboveView = nil;
        mOrientation = JWLayoutOrientationNone;
    }
    return self;
}

- (UIView *)view {
    return mView;
}

- (void)setView:(UIView *)view {
    mView = view;
}

- (BOOL)enabled {
    return mEnabled;
}

- (void)setEnabled:(BOOL)enabled {
    if (enabled != mEnabled) {
        [mView.superview setNeedsLayout];
    }
    mEnabled = enabled;
}

- (CGFloat)width {
    // 根据朝向实时调整
    mSize.width = [[UIScreen mainScreen] getRelativeWidth:mSize.width];
    return mSize.width;
}

- (void)setWidth:(CGFloat)width {
    if (mSize.width != width && self.enabled) {
        [mView.superview setNeedsLayout];
    }
    mSize.width = width;
}

- (CGFloat)height {
    // 根据朝向实时调整
    mSize.height = [[UIScreen mainScreen] getRelativeHeight:mSize.height];
    return mSize.height;
}

- (void)setHeight:(CGFloat)height {
    if (mSize.height != height && self.enabled) {
        [mView.superview setNeedsLayout];
    }
    mSize.height = height;
}

- (CGFloat)weight {
    return mWeight;
}

- (void)setWeight:(CGFloat)weight {
    if (mWeight != weight && self.enabled) {
        [mView.superview setNeedsLayout];
    }
    mWeight = weight;
}

- (CGFloat)paddingLeft {
    // TODO 实现单位机制，可以相对于其他控件
    mPadding.left = [[UIScreen mainScreen] getRelativeWidth:mPadding.left];
    return mPadding.left;
}

- (void)setPaddingLeft:(CGFloat)paddingLeft {
    if (mPadding.left != paddingLeft && self.enabled) {
        [mView.superview setNeedsLayout];
    }
    mPadding.left = paddingLeft;
}

- (CGFloat)paddingTop {
    // TODO 实现单位机制，可以相对于其他控件
    mPadding.top = [[UIScreen mainScreen] getRelativeWidth:mPadding.top];
    return mPadding.top;
}

- (void)setPaddingTop:(CGFloat)paddingTop {
    if (mPadding.top != paddingTop && self.enabled) {
        [mView.superview setNeedsLayout];
    }
    mPadding.top = paddingTop;
}

- (CGFloat)paddingRight {
    // TODO 实现单位机制，可以相对于其他控件
    mPadding.right = [[UIScreen mainScreen] getRelativeWidth:mPadding.right];
    return mPadding.right;
}

- (void)setPaddingRight:(CGFloat)paddingRight {
    if (mPadding.right != paddingRight && self.enabled) {
        [mView.superview setNeedsLayout];
    }
    mPadding.right = paddingRight;
}

- (CGFloat)paddingBottom {
    // TODO 实现单位机制，可以相对于其他控件
    mPadding.bottom = [[UIScreen mainScreen] getRelativeWidth:mPadding.bottom];
    return mPadding.bottom;
}

- (void)setPaddingBottom:(CGFloat)paddingBottom {
    if (mPadding.bottom != paddingBottom && self.enabled) {
        [mView.superview setNeedsLayout];
    }
    mPadding.bottom = paddingBottom;
}

- (CGFloat)padding {
    // NOTE 没有意义
    @throw [NSException exceptionWithName:@"CannotGetPaddingException" reason:@"padding is unified settings" userInfo:nil];
    return 0.0f;
}

- (void)setPadding:(CGFloat)padding {
    self.paddingLeft = padding;
    self.paddingTop = padding;
    self.paddingRight = padding;
    self.paddingBottom = padding;
}

- (CGFloat)marginLeft {
    // 根据朝向实时调整
    mMargin.left = [[UIScreen mainScreen] getRelativeWidth:mMargin.left];
    return mMargin.left;
}

- (void)setMarginLeft:(CGFloat)marginLeft {
    if (mMargin.left != marginLeft && self.enabled) {
        [mView.superview setNeedsLayout];
    }
    mMargin.left = marginLeft;
}

- (CGFloat)marginTop {
    // 根据朝向实时调整
    mMargin.top = [[UIScreen mainScreen] getRelativeHeight:mMargin.top];
    return mMargin.top;
}

- (void)setMarginTop:(CGFloat)marginTop {
    if (mMargin.top != marginTop && self.enabled) {
        [mView.superview setNeedsLayout];
    }
    mMargin.top = marginTop;
}

- (CGFloat)marginRight {
    // 根据朝向实时调整
    mMargin.right = [[UIScreen mainScreen] getRelativeWidth:mMargin.right];
    return mMargin.right;
}

- (void)setMarginRight:(CGFloat)marginRight {
    if (mMargin.right != marginRight && self.enabled) {
        [mView.superview setNeedsLayout];
    }
    mMargin.right = marginRight;
}

- (CGFloat)marginBottom {
    // 根据朝向实时调整
    mMargin.bottom = [[UIScreen mainScreen] getRelativeHeight:mMargin.bottom];
    return mMargin.bottom;
}

- (void)setMarginBottom:(CGFloat)marginBottom {
    if (mMargin.bottom != marginBottom && self.enabled) {
        [mView.superview setNeedsLayout];
    }
    mMargin.bottom = marginBottom;
}

- (CGFloat)margin {
    // NOTE 没有意义
    @throw [NSException exceptionWithName:@"CannotGetMarginException" reason:@"margin is unified settings" userInfo:nil];
    return 0.0f;
}

- (void)setMargin:(CGFloat)margin {
    self.marginLeft = margin;
    self.marginTop = margin;
    self.marginRight = margin;
    self.marginBottom = margin;
}

- (JWLayoutAlignment)alignment {
    return mAlign;
}

- (void)setAlignment:(JWLayoutAlignment)alignment {
    if (mAlign != alignment && self.enabled) {
        [mView.superview setNeedsLayout];
    }
    mAlign = alignment;
}

- (UIView *)rightOf {
    return mRightOfView;
}

- (void)setRightOf:(UIView *)rightOf {
    if (mRightOfView != rightOf && self.enabled) {
        [mView.superview setNeedsLayout];
    }
    mRightOfView = rightOf;
}

- (UIView *)below {
    return mBelowView;
}

- (void)setBelow:(UIView *)below {
    if (mBelowView != below && self.enabled) {
        [mView.superview setNeedsLayout];
    }
    mBelowView = below;
}

- (UIView *)leftOf {
    return mLeftOfView;
}

- (void)setLeftOf:(UIView *)leftOf {
    if (mLeftOfView != leftOf && self.enabled) {
        [mView.superview setNeedsLayout];
    }
    mLeftOfView = leftOf;
}

- (UIView *)above {
    return mAboveView;
}

- (void)setAbove:(UIView *)above {
    if (mAboveView != above && self.enabled) {
        [mView.superview setNeedsLayout];
    }
    mAboveView = above;
}

- (JWLayoutOrientation)orientation {
    return mOrientation;
}

- (void)setOrientation:(JWLayoutOrientation)orientation {
    if (mOrientation != orientation && self.enabled) {
        [mView.superview setNeedsLayout];
    }
    mOrientation = orientation;
}

@end
