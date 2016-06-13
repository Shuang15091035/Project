//
//  UIView+JWUiCategory.h
//  June Winter
//
//  Created by GavinLo on 14-3-11.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JCSize.h>
#import <jw/JCPadding.h>
#import <jw/JWUiCommon.h>

@interface UIView (JWUiCategory)

@property (nonatomic, readwrite) CGPoint frameOrigin;
@property (nonatomic, readwrite) CGSize frameSize;

/**
 * 根据设备屏幕(如retina屏幕)进行处理
 */
@property (nonatomic, readwrite) CGRect frameInPixels;

//+ (CGSize) sizeByDeviceOrientation:(CGSize)size;
//+ (CGRect) rectByDeviceOrientation:(CGRect)rect;

/**
 * 根据屏幕朝向进行处理
 */
//@property (nonatomic, readwrite) CGRect frameByDeviceOrientation;
//@property (nonatomic, readwrite) CGRect frameByDeviceOrientationInPixels;
- (void) setLayersFrame:(CGRect)frame;

@property (nonatomic, readwrite, getter=isVisible) BOOL visible;

/**
 * 显示状态开关(显示=>隐藏/隐藏=>显示)
 * @return 是否可见
 */
- (BOOL) toggle;

- (BOOL) hasView:(UIView*)view;

// 以下是脱离Layout机制的实用方法
@property (nonatomic, readwrite) CGFloat marginLeft;
@property (nonatomic, readwrite) CGFloat marginTop;
@property (nonatomic, readwrite) CGFloat marginRight;
@property (nonatomic, readwrite) CGFloat marginBottom;
@property (nonatomic, readwrite) CGFloat margin;
@property (nonatomic, readwrite) CGFloat paddingLeft;
@property (nonatomic, readwrite) CGFloat paddingTop;
@property (nonatomic, readwrite) CGFloat paddingRight;
@property (nonatomic, readwrite) CGFloat paddingBottom;
@property (nonatomic, readwrite) CGFloat padding;
- (void) leftOf:(UIView*)view byMargin:(CGFloat)margin;
- (void) rightOf:(UIView*)view byMargin:(CGFloat)margin;
- (void) fitSubviewsWithOptions:(JWUiFitOptions)options padding:(JCPadding)padding;

- (void) removeAllGestureRecognizers;

- (NSString*) viewTree;
- (UIView*) duplicate;

@end
