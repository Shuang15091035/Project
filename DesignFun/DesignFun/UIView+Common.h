//
//  UIView+Common.h
//  FirstBlood
//
//  Created by qianfeng on 15/9/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  获取视图位置的类别
 */
@interface UIView (Position)
/**
 *  屏幕的宽
 *
 *  @return 宽
 */
CGFloat screentWidth();
/**
 *  屏幕的高
 *
 *  @return 高
 */
CGFloat screenHeight();
/**
 *  返回视图的宽
 *
 *  @return 宽
 */
- (CGFloat)width;
/**
 *  返回视图的高
 *
 *  @return 高
 */
- (CGFloat)height;
/**
 * 返回视图的宽
 *
 *  @param rect 视图的宽
 */
CGFloat width (CGRect rect);
/**
 *  @param 根据frame返回视图的高
 *
 *  @return 视图的frame
 */
CGFloat height(CGRect rect);
/**
 *  返回最大的Y
 */
CGFloat maxY(UIView *view);
/**
 *  返回最大的X
 */
CGFloat maxX(UIView *view);
/**
 *  返回最小的Y
 */
CGFloat minY(UIView *view);
/**
 *  返回最小的X
 */
CGFloat minX(UIView *view);
/**
 *  返回中间高度的X
 */
CGFloat midX(UIView *view);
/**
 *  返回中间高度的Y
 */
CGFloat midY(UIView *view);
/**
 *  返回最大的X值
 */
CGFloat maxXF(CGRect rect);

/**
 *  返回最大的Y值
 */
CGFloat maxYF(CGRect rect);

@end

@interface UIView (Common)

@end
