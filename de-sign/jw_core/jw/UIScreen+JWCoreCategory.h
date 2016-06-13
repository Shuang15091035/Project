//
//  UIScreen+JWCoreCategory.h
//  June Winter
//
//  Created by GavinLo on 15/1/8.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (JWCoreCategory)

@property (nonatomic, readonly) CGRect statusBarFrame;
@property (nonatomic, readonly) CGRect navigationBarFrame;

/**
 * 显示内容区域
 * iOS<7.0为除了status bar和navigation bar以外的区域,iOS>=7.0为整个屏幕
 */
@property (nonatomic, readonly) CGRect frameForDisplayContent;

/**
 * 最大显示内容区域
 * iOS<7.0为除了status bar以外的区域,iOS>=7.0为整个屏幕
 */
@property (nonatomic, readonly) CGRect frameForMaxDisplayContent;

/**
 * 除了status bar以外的区域
 */
@property (nonatomic, readonly) CGRect frameUnderStatusBar;

/**
 * 除了status bar和navigation bar以外的区域
 */
@property (nonatomic, readonly) CGRect frameUnderNavigationBar;

/**
 * 整个屏幕区域
 */
@property (nonatomic, readonly) CGRect fullFrame;

/**
 * 在iOS8之前，当设备朝向发生改变时，控件坐标系会自动调整到相对于该朝向的坐标系。
 * 永远以用户站立时，右手方向为x轴和屏幕宽度的方向，垂直向下为y轴和屏幕高度的方向。
 * 故在代码中使用UITouch的locationInView:nil风险很大，因为没有自适应，而locationInView:self.view则会跟view一样自动调整坐标系。
 * 这边处理一下bounds
 */
@property (nonatomic, readonly) CGRect boundsByOrientation;
@property (nonatomic, readonly) CGRect boundsInPixels;

- (CGFloat) widthByScale:(CGFloat)scale;
- (CGFloat) heightByScale:(CGFloat)scale;

- (CGPoint) pointInPixelsByPoint:(CGPoint)point;
- (CGPoint) pointByPointInPixels:(CGPoint)pointInPixels;

/**
 * 获取相对宽度,若输入宽度在(-1,1)中则视为百分比,否则原值返回
 */
- (CGFloat) getRelativeWidth:(CGFloat)width;

/**
 * 获取相对高度,若输入高度在(-1,1)中则视为百分比,否则原值返回
 */
- (CGFloat) getRelativeHeight:(CGFloat)height;

@end
