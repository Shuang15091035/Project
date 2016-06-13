
//  UIView+JWUiCategory.m
//  June Winter
//
//  Created by GavinLo on 14-3-11.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "UIView+JWUiCategory.h"
#import <jw/JCMath.h>
#import <jw/JCFlags.h>
#import "JWIOS.h"
#import "UIDevice+JWCoreCategory.h"
#import <jw/NSException+JWCoreCategory.h>
#import <objc/runtime.h>

@implementation UIView (JWUiCategory)

//+ (void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        method_exchangeImplementations(class_getInstanceMethod([self class], @selector(frame)), class_getInstanceMethod([self class], @selector(frameOrigin)));
//        method_exchangeImplementations(class_getInstanceMethod([self class], @selector(frameByDeviceOrientation)), class_getInstanceMethod([self class], @selector(frame)));
//        method_exchangeImplementations(class_getInstanceMethod([self class], @selector(setFrame:)), class_getInstanceMethod([self class], @selector(setFrameOrigin:)));
//        method_exchangeImplementations(class_getInstanceMethod([self class], @selector(setFrameByDeviceOrientation:)), class_getInstanceMethod([self class], @selector(setFrame:)));
//    });
//}

- (CGPoint)frameOrigin {
    return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)frameOrigin {
    CGRect frame = self.frame;
    self.frame = CGRectMake(frameOrigin.x, frameOrigin.y, frame.size.width, frame.size.height);
}

- (CGSize)frameSize {
    return  self.frame.size;
}

- (void)setFrameSize:(CGSize)frameSize {
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frameSize.width, frameSize.height);
}

- (CGRect)frameInPixels {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect frame = self.frame;
    frame.size = CGSizeMake(frame.size.width * scale, frame.size.height * scale);
    return frame;
}

- (void)setFrameInPixels:(CGRect)frameByDevice {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect frame = frameByDevice;
    frame.size = CGSizeMake(frame.size.width / scale, frame.size.height / scale);
    self.frame = frame;
}

+ (CGSize)sizeByDeviceOrientation:(CGSize)size {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        return size;
    } else {
        CGSize newSize = CGSizeMake(size.width, size.height);
        UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if(UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            newSize = CGSizeMake(size.height, size.width);
        }
        return newSize;
    }
}

+ (CGRect)rectByDeviceOrientation:(CGRect)rect {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        return rect;
    } else {
        CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
        UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            newRect.size = CGSizeMake(rect.size.height, rect.size.width);
//            newRect = CGRectMake(rect.origin.y, rect.origin.x, rect.size.height, rect.size.width);
        }
        return newRect;
    }
}

- (CGRect)frameByDeviceOrientation {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        return self.frame;
    } else {
        CGRect frame = self.frame;
        UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            //frame.size = CGSizeMake(frame.size.height, frame.size.width);
//            frame = CGRectMake(frame.origin.y, frame.origin.x, frame.size.height, frame.size.width);
        }
        return frame;
    }
}

- (void)setFrameByDeviceOrientation:(CGRect)frameByDeviceOrientation {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        self.frame = frameByDeviceOrientation;
    } else {
        CGRect frame = frameByDeviceOrientation;
        UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if(UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            //frame.size = CGSizeMake(frame.size.height, frame.size.width);
//            frame = CGRectMake(frame.origin.y, frame.origin.x, frame.size.height, frame.size.width);
        }
        self.frame = frame;
    }
}

- (CGRect)frameByDeviceOrientationInPixels {
//    if([[UIDevice currentDevice] systemVersionGE:[UIDevice Version80]])
//        return self.frameInPixels;
//    else
    {
        CGRect frame = self.frameInPixels;
        UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            //frame.size = CGSizeMake(frame.size.height, frame.size.width);
        }
        return frame;
    }
}

- (void)setFrameByDeviceOrientationInPixels:(CGRect)frameByDeviceOrientationInPixels
{
//    if([[UIDevice currentDevice] systemVersionGE:[UIDevice Version80]])
//        self.frameInPixels = frameByDeviceOrientationInPixels;
//    else
    {
        CGRect frame = frameByDeviceOrientationInPixels;
        UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
            //frame.size = CGSizeMake(frame.size.height, frame.size.width);
        self.frameInPixels = frame;
    }
}

- (void)setLayersFrame:(CGRect)frame {
    CALayer* layer = self.layer;
//    layer.frame = frame;
    NSArray* sublayers = layer.sublayers;
    if (sublayers != nil) {
        for (CALayer* sublayer in sublayers) {
            sublayer.frame = frame;
        }
    }
}

- (BOOL)isVisible {
    return !self.hidden;
}

- (void)setVisible:(BOOL)visible {
    self.hidden = !visible;
}

- (BOOL)toggle {
    self.hidden = !self.hidden;
    return !self.hidden;
}

- (BOOL)hasView:(UIView *)view {
    NSArray<UIView*>* subviews = self.subviews;
    if (subviews != nil) {
        for (UIView* subview in subviews) {
            if (subview == view) {
                return YES;
            }
            if ([subview hasView:view]) {
                return YES;
            }
        }
    }
    return NO;
}

- (CGFloat)marginLeft {
    // TODO
    @throw [NSException notImplementExceptionWithMethod:@"UIView marginLeft"];
}

- (void)setMarginLeft:(CGFloat)marginLeft {
    if (marginLeft == 0.0f) {
        return;
    }
    CGRect frame = self.frame;
    CGFloat newX = marginLeft;
    // NOTE 防止多次调用layoutSubviews
    if (!JCEqualsfe(newX, frame.origin.x, 1.0f)) {
        self.frame = CGRectMake(newX, frame.origin.y, frame.size.width, frame.size.height);
    }
}

- (CGFloat)marginTop {
    // TODO
    @throw [NSException notImplementExceptionWithMethod:@"UIView marginTop"];
}

- (void)setMarginTop:(CGFloat)marginTop {
    if (marginTop == 0.0f) {
        return;
    }
    CGRect frame = self.frame;
    CGFloat newY = marginTop;
    // NOTE 防止多次调用layoutSubviews
    if (!JCEqualsfe(newY, frame.origin.y, 1.0f)) {
        self.frame = CGRectMake(frame.origin.x, newY, frame.size.width, frame.size.height);
    }
}

- (CGFloat)marginRight {
    // TODO
    @throw [NSException notImplementExceptionWithMethod:@"UIView marginRight"];
}

- (void)setMarginRight:(CGFloat)marginRight {
    if (marginRight == 0.0f) {
        return;
    }
    CGRect frame = self.frame;
    UIView* parent = self.superview;
    CGRect parentFrame = CGRectZero;
    if (parent != nil) {
        parentFrame = parent.frame;
    } else { // NOTE 没有parent，相对于屏幕
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        parentFrame = screenBounds;
    }
    CGFloat newX = (parentFrame.size.width - frame.size.width) - marginRight;
    // NOTE 防止多次调用layoutSubviews
    if (!JCEqualsfe(newX, frame.origin.x, 1.0f)) {
        self.frame = CGRectMake(newX, frame.origin.y, frame.size.width, frame.size.height);
    }
}

- (CGFloat)marginBottom {
    // TODO
    @throw [NSException notImplementExceptionWithMethod:@"UIView marginBottom"];
}

- (void)setMarginBottom:(CGFloat)marginBottom {
    if (marginBottom == 0.0f) {
        return;
    }
    CGRect frame = self.frame;
    UIView* parent = self.superview;
    CGRect parentFrame = CGRectZero;
    if (parent != nil) {
        parentFrame = parent.frame;
    } else { // NOTE 没有parent，相对于屏幕
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        parentFrame = screenBounds;
    }
    CGFloat newY = (parentFrame.size.height - frame.size.height) - marginBottom;
    // NOTE 防止多次调用layoutSubviews
    if (!JCEqualsfe(newY, frame.origin.y, 1.0f)) {
        self.frame = CGRectMake(frame.origin.x, newY, frame.size.width, frame.size.height);
    }
}

- (CGFloat)margin {
    // TODO
    @throw [NSException notImplementExceptionWithMethod:@"UIView margin"];
}

- (void)setMargin:(CGFloat)margin {
    self.marginLeft = margin;
    self.marginTop = margin;
    self.marginRight = margin;
    self.marginBottom = margin;
}

- (CGFloat)paddingLeft {
    // TODO
    @throw [NSException notImplementExceptionWithMethod:@"UIView paddingLeft"];
}

- (void)setPaddingLeft:(CGFloat)paddingLeft {
    if (paddingLeft == 0.0f) {
        return;
    }
    CGRect frame = self.frame;
    CGRect bounds = self.bounds;
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + paddingLeft, frame.size.height);
    CGRect newBounds = CGRectMake(bounds.origin.x + paddingLeft, bounds.origin.y, bounds.size.width, bounds.size.height);
    self.bounds = newBounds;
    self.frame = newFrame;
}

- (CGFloat)paddingTop {
    // TODO
    @throw [NSException notImplementExceptionWithMethod:@"UIView paddingTop"];
}

- (void)setPaddingTop:(CGFloat)paddingTop {
    if (paddingTop == 0.0f) {
        return;
    }
    CGRect frame = self.frame;
    CGRect bounds = self.bounds;
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + paddingTop);
    CGRect newBounds = CGRectMake(bounds.origin.x, bounds.origin.y + paddingTop, bounds.size.width, bounds.size.height);
    self.bounds = newBounds;
    self.frame = newFrame;
}

- (CGFloat)paddingRight {
    // TODO
    @throw [NSException notImplementExceptionWithMethod:@"UIView paddingRight"];
}

- (void)setPaddingRight:(CGFloat)paddingRight {
    if (paddingRight == 0.0f) {
        return;
    }
    CGRect frame = self.frame;
    CGRect bounds = self.bounds;
    CGRect newFrame = CGRectMake(frame.origin.x - paddingRight, frame.origin.y, frame.size.width + paddingRight, frame.size.height);
    CGRect newBounds = CGRectMake(bounds.origin.x - paddingRight, bounds.origin.y, bounds.size.width, bounds.size.height);
    self.bounds = newBounds;
    self.frame = newFrame;
}

- (CGFloat)paddingBottom {
    // TODO
    @throw [NSException notImplementExceptionWithMethod:@"UIView paddingBottom"];
}

- (void)setPaddingBottom:(CGFloat)paddingBottom {
    if (paddingBottom == 0.0f) {
        return;
    }
    CGRect frame = self.frame;
    CGRect bounds = self.bounds;
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y - paddingBottom, frame.size.width, frame.size.height + paddingBottom);
    CGRect newBounds = CGRectMake(bounds.origin.x, bounds.origin.y - paddingBottom, bounds.size.width, bounds.size.height);
    self.bounds = newBounds;
    self.frame = newFrame;
}

- (CGFloat)padding {
    // TODO
    @throw [NSException notImplementExceptionWithMethod:@"UIView padding"];
}

- (void)setPadding:(CGFloat)padding {
    self.paddingLeft = padding;
    self.paddingTop = padding;
    self.paddingRight = padding;
    self.paddingBottom = padding;
}

- (void)leftOf:(UIView *)view byMargin:(CGFloat)margin {
    if (view == nil) {
        return;
    }
    CGRect frame = self.frame;
    CGRect relFrame = view.frame;
    CGFloat newX = relFrame.origin.x - (frame.size.width + margin);
    // NOTE 防止多次调用layoutSubviews
    if (!JCEqualsfe(newX, frame.origin.x, 1.0f)) {
        self.frame = CGRectMake(newX, frame.origin.y, frame.size.width, frame.size.height);
    }
}

- (void)rightOf:(UIView *)view byMargin:(CGFloat)margin {
    if (view == nil) {
        return;
    }
    CGRect frame = self.frame;
    CGRect relFrame = view.frame;
    CGFloat newX = relFrame.origin.x + relFrame.size.width + margin;
    // NOTE 防止多次调用layoutSubviews
    if (!JCEqualsfe(newX, frame.origin.x, 1.0f)) {
        self.frame = CGRectMake(newX, frame.origin.y, frame.size.width, frame.size.height);
    }
}

- (void)fitSubviewsWithOptions:(JWUiFitOptions)options padding:(JCPadding)padding {
    NSArray<UIView*>* subviews = self.subviews;
    if (subviews == nil || subviews.count == 0) {
        self.frame = CGRectZero;
        return;
    }
    CGRect frame = self.frame;
    CGPoint minPoint = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
    CGPoint maxPoint = CGPointMake(CGFLOAT_MIN, CGFLOAT_MIN);
    for (UIView* subview in subviews) {
        CGRect subviewFrame = subview.frame;
        if (JCFlagsTest(options, JWUiFitOptionWidth)) {
            if (subviewFrame.origin.x < minPoint.x) {
                minPoint.x = subviewFrame.origin.x;
            }
            if (subviewFrame.origin.x + subviewFrame.size.width > maxPoint.x) {
                maxPoint.x = subviewFrame.origin.x + subviewFrame.size.width;
            }
        } else {
            minPoint.x = frame.origin.x;
            maxPoint.x = frame.origin.x + frame.size.width;
        }
        if (JCFlagsTest(options, JWUiFitOptionHeight)) {
            if (subviewFrame.origin.y < minPoint.y) {
                minPoint.y = subviewFrame.origin.y;
            }
            if (subviewFrame.origin.y + subviewFrame.size.height > maxPoint.y) {
                maxPoint.y = subviewFrame.origin.y + subviewFrame.size.height;
            }
        } else {
            minPoint.y = frame.origin.y;
            maxPoint.y = frame.origin.y + frame.size.height;
        }
    }
    CGPoint offset = CGPointMake(minPoint.x - frame.origin.x - padding.left, minPoint.y - frame.origin.y - padding.top);
    CGPoint subviewOffset = CGPointMake(-offset.x, -offset.y);
    if (subviewOffset.x != 0.0f || subviewOffset.y != 0.0f) {
        for (UIView* subview in subviews) {
            CGPoint subviewFrameOrigin = subview.frameOrigin;
            subview.frameOrigin = CGPointMake(subviewFrameOrigin.x + subviewOffset.x, subviewFrameOrigin.y + subviewOffset.y);
        }
    }
    CGSize size = CGSizeMake(padding.left + (maxPoint.x - minPoint.x) + padding.right, padding.top + (maxPoint.y - minPoint.y) + padding.bottom);
    self.frame = CGRectMake(frame.origin.x + offset.x, frame.origin.y + offset.y, size.width, size.height);
}

- (void)removeAllGestureRecognizers {
    NSArray* recognizers = [NSArray arrayWithArray:self.gestureRecognizers];
    for (UIGestureRecognizer* recognizer in recognizers) {
        [self removeGestureRecognizer:recognizer];
    }
}

- (NSString *)viewTree {
    NSMutableString* tree = [NSMutableString string];
    [self appendChildDescriptionTo:tree prefix:@"|--"];
    return tree;
}

- (void) appendChildDescriptionTo:(NSMutableString*)description prefix:(NSString*)prefix {
    CGRect frame = self.frame;
    [description appendFormat:@"\n%@%@(tag=%@, x=%.2f, y=%.2f, width=%.2f, height=%.2f)", prefix, NSStringFromClass([self class]), @(self.tag), frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
    NSString* newPrefix = [NSString stringWithFormat:@"|   %@", prefix];
    NSArray* subviews = self.subviews;
    if (subviews != nil) {
        for (UIView* subview in subviews) {
            [subview appendChildDescriptionTo:description prefix:newPrefix];
        }
    }
}

-(UIView *)duplicate {
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

@end
