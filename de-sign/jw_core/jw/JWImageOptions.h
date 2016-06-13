//
//  JWImageOptions.h
//  June Winter
//
//  Created by GavinLo on 15/1/5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JWKeepRatioPolicy)
{
    /**
     * 未知策略
     */
    JWKeepRatioPolicyUnknown,
    
    /**
     * 宽度优先.<br>
     * 设置此项后,在缩放图片时使用图片的宽度(即{@link JWImageOptions#fixedWidth})作为依据,
     * 并根据图片的原始宽高计算出宽高比ratio,
     * 从而计算出缩放所需要的高度值.
     */
    JWKeepRatioPolicyWidthPriority,
    
    /**
     * 高度优先.<br>
     * 设置此项后,在缩放图片时使用图片的高度(即{@link JWImageOptions#fixedHeight})作为依据,
     * 并根据图片的原始宽高计算出宽高比ratio,
     * 从而计算出缩放所需要的高度值.
     */
    JWKeepRatioPolicyHeightPriority,
    
    /**
     * 短边优先.<br>
     * 设置此项后,在缩放图片时使用图片的原始宽度和原始高度中较短的一个作为依据,
     * 若它们长度相同则使用图片的宽度(即{@link JWImageOptions#fixedWidth})和高度(即{@link JWImageOptions#fixedHeight})中较短的一个作为依据,
     * 并根据图片的原始宽高计算出宽高比ratio,
     * 从而计算出缩放所需要的宽度与高度值.
     */
    JWKeepRatioPolicyShortPriority,
    
    /**
     * 长边优先.<br>
     * 设置此项后,在缩放图片时使用图片的原始宽度和原始高度中较长的一个作为依据,
     * 若它们长度相同则使用图片的宽度(即{@link JWImageOptions#fixedWidth})和高度(即{@link JWImageOptions#fixedHeight})中较长的一个作为依据,
     * 并根据图片的原始宽高计算出宽高比ratio,
     * 从而计算出缩放所需要的宽度与高度值.
     */
    JWKeepRatioPolicyLongPriority,
};

/**
 * UIImage解码参数
 */
@interface JWImageOptions : NSObject

+ (id) options;

/**
 * 是否具有请求大小数据{@link #requestWidth}和{@link #requestHeight},
 * 如果设为true,<b>在解析图片数据时</b>,会根据{@link #requestWidth}和{@link #requestHeight}来计算图片的缩放,
 * 减少在图片所消耗的内存,但最终的返回的图片大小不一定为({@link #requestWidth},{@link #requestHeight}).
 *
 * **以上为android版的特性,ios下处理同fixedSize
 */
@property (nonatomic, readwrite) BOOL hasRequestSize;
@property (nonatomic, readwrite) CGFloat requestWidth;
@property (nonatomic, readwrite) CGFloat requestHeight;

/**
 * 是否具有固定大小数据{@link #fixedWidth}和{@link #fixedHeight},
 * 如果设为true,<b>在解析图片数据后</b>,会根据{@link #fixedWidth}和{@link #fixedHeight}来缩放图片,
 * 这样会消耗额外的内存空间,但最终的返回的图片大小为({@link #fixedWidth},{@link #fixedHeight}).
 */
@property (nonatomic, readwrite) BOOL hasFixedSize;
@property (nonatomic, readwrite) CGFloat fixedWidth;
@property (nonatomic, readwrite) CGFloat fixedHeight;

/**
 * 宽高比策略
 */
@property (nonatomic, readwrite) JWKeepRatioPolicy keepRatioPolicy;

@property (nonatomic, readwrite) BOOL scalePowerOf2;
@property (nonatomic, readwrite) UIEdgeInsets insets;

@end
