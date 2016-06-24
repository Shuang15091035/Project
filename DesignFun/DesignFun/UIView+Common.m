//
//  UIView+Common.m
//  FirstBlood
//
//  Created by qianfeng on 15/9/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (Position)
/**
 *  获取屏幕的宽
 *
 *  @return 屏幕的宽
 */
CGFloat screentWidth()
{
    return [[UIScreen mainScreen] bounds].size.width;
}
/**
 *  获取屏幕的高
 *
 *  @return 屏幕的高度
 */
CGFloat screenHeight(){

    return [[UIScreen mainScreen] bounds].size.height;
}
/**
 *  返回视图的宽
 *
 *  @return 宽
 */
- (CGFloat)width{
    
    return self.frame.size.width;
}
/**
 *  返回视图的高
 *
 *  @return 高
 */
- (CGFloat)height{

    return self.frame.size.height;
}
/**
 * 返回视图的宽
 *
 *  @param rect 视图的宽
 */
CGFloat width (CGRect rect){
    return CGRectGetWidth(rect);
}
/**
 *  @param 根据frame返回视图的高
 *
 *  @return 视图的frame
 */
CGFloat height(CGRect rect){
    return CGRectGetHeight(rect);
}
/**
 *  返回最大的Y
 */
CGFloat maxY(UIView *view){
    return CGRectGetMaxY(view.frame);
}
/**
 *  返回最大的X
 */
CGFloat maxX(UIView *view){
    return CGRectGetMaxX(view.frame);
}
/**
 *  返回最小的Y
 */
CGFloat minY(UIView *view){
    return CGRectGetMinY(view.frame);
}
/**
 *  返回最小的X
 */
CGFloat minX(UIView *view){
    return CGRectGetMinX(view.frame);
}
/**
 *  返回中间高度的X
 */
CGFloat midX(UIView *view){
    return CGRectGetMidX(view.frame);
}
/**
 *  返回中间高度的Y
 */
CGFloat midY(UIView *view){
    return CGRectGetMidY(view.frame);
}

CGFloat maxXF(CGRect rect) {
    return CGRectGetMaxX(rect);
}
CGFloat maxYF(CGRect rect){
    return CGRectGetMaxY(rect);
}
@end

@implementation UIView (Common)

@end
