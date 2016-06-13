//
//  JWLayoutParams.h
//  June Winter
//
//  Created by GavinLo on 14/12/19.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JWLayoutConstants) {
    /**
     * 控件大小撑满父控件
     */
    JWLayoutMatchParent = -1,
    /**
     * 控件大小匹配控件内容,比如Label里面的文本
     */
    JWLayoutWrapContent = -2,
};

typedef NS_OPTIONS(NSUInteger, JWLayoutAlignment) {
    JWLayoutAlignNone = 0,
    JWLayoutAlignParentLeft = 0x1 << 0,
    JWLayoutAlignParentTop = 0x1 << 1,
    JWLayoutAlignParentRight = 0x1 << 2,
    JWLayoutAlignParentBottom = 0x1 << 3,
    JWLayoutAlignCenterHorizontal = 0x1 << 4,
    JWLayoutAlignCenterVertical = 0x1 << 5,
    JWLayoutAlignCenterInParent = JWLayoutAlignCenterHorizontal | JWLayoutAlignCenterVertical,
    JWLayoutAlignParentTopLeft = JWLayoutAlignParentTop | JWLayoutAlignParentLeft,
    JWLayoutAlignParentTopRight = JWLayoutAlignParentTop | JWLayoutAlignParentRight,
    JWLayoutAlignParentBottomLeft = JWLayoutAlignParentBottom | JWLayoutAlignParentLeft,
    JWLayoutAlignParentBottomRight = JWLayoutAlignParentBottom | JWLayoutAlignParentRight,
};

typedef NS_ENUM(NSInteger, JWLayoutOrientation) {
    JWLayoutOrientationNone,
    JWLayoutOrientationHorizontal,
    JWLayoutOrientationVertical,
};

@interface JWLayoutParams : NSObject

@property (nonatomic, readwrite) UIView* view;

/**
 * 当为NO时，可让控件不受Layout机制约束
 */
@property (nonatomic, readwrite) BOOL enabled;

/**
 * 宽度,一般设置为具体大小,同时也可以设置为JWLayoutMatchParent或JWLayoutWrapContent来使控件自适应
 * 注:大小如果设置为[0,1)之间,会当做屏幕宽度的百分比处理
 */
@property (nonatomic, readwrite) CGFloat width;

/**
 * 高度,一般设置为具体大小,同时也可以设置为JWLayoutMatchParent或JWLayoutWrapContent来使控件自适应
 * 注:大小如果设置为[0,1)之间,会当做屏幕高度的百分比处理
 */
@property (nonatomic, readwrite) CGFloat height;

/**
 * 比重,这个比重不是传统意义上的关于父控件的空间比例,而是控件分割父控件剩余空间的比重,
 * 同时它不是一个百分比,父控件在分割剩余空间的时候会通过叠加所有子控件的weight为totalWeight,
 * 而此控件则分割剩余空间的(weight/totalWeight)
 */
@property (nonatomic, readwrite) CGFloat weight;

/**
 * 内容左间距，控件内容与控件边缘的距离
 */
@property (nonatomic, readwrite) CGFloat paddingLeft;

/**
 * 内容上间距，控件内容与控件边缘的距离
 */
@property (nonatomic, readwrite) CGFloat paddingTop;

/**
 * 内容右间距，控件内容与控件边缘的距离
 */
@property (nonatomic, readwrite) CGFloat paddingRight;

/**
 * 内容下间距，控件内容与控件边缘的距离
 */
@property (nonatomic, readwrite) CGFloat paddingBottom;

/**
 * 内容间距,控件内容与控件边缘的距离
 * 注：这是统一设置上下左右间距的实用属性，获取其值没有意义
 */
@property (nonatomic, readwrite) CGFloat padding;

/**
 * 左间距，控件边缘与其他控件的距离
 * 注：大小如果设置为[0,1)之间，会当做屏幕宽度的百分比处理
 */
@property (nonatomic, readwrite) CGFloat marginLeft;

/**
 * 上间距，控件边缘与其他控件的距离
 * 注：大小如果设置为[0,1)之间，会当做屏幕高度的百分比处理
 */
@property (nonatomic, readwrite) CGFloat marginTop;

/**
 * 右间距，控件边缘与其他控件的距离
 * 注：大小如果设置为[0,1)之间，会当做屏幕宽度的百分比处理
 */
@property (nonatomic, readwrite) CGFloat marginRight;

/**
 * 下间距，控件边缘与其他控件的距离
 * 注：大小如果设置为[0,1)之间，会当做屏幕高度的百分比处理
 */
@property (nonatomic, readwrite) CGFloat marginBottom;

/**
 * 间距，控件边缘与其他控件的距离
 * 注：大小如果设置为[0,1)之间，会当做屏幕高度的百分比处理
 * 注：这是统一设置上下左右间距的实用属性，获取其值没有意义
 */
@property (nonatomic, readwrite) CGFloat margin;

/**
 * 控件的对齐方式
 */
@property (nonatomic, readwrite) JWLayoutAlignment alignment;

/**
 * 设置当前view在rightOf的右边
 */
@property (nonatomic, readwrite) UIView* rightOf;

/**
 * 设置当前view在below的下面
 */
@property (nonatomic, readwrite) UIView* below;

/**
 * 设置当前view在leftOf的左边
 */
@property (nonatomic, readwrite) UIView* leftOf;

/**
 * 设置当前view在above的上面
 */
@property (nonatomic, readwrite) UIView* above;

/**
 * 控件的方向，对于layout有意义
 */
@property (nonatomic, readwrite) JWLayoutOrientation orientation;

@end
