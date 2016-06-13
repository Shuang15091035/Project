//
//  UIImage+JWImageUtils.h
//  June Winter
//
//  Created by GavinLo on 15/1/5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JWImageOptions.h>
#import <jw/JCBitmap.h>

@interface UIImage (JWImageUtils)

@property (nonatomic, readonly) CGSize sizeInPixels;

/**
 * 从JW定义的resource bundle中取image
 */
+ (UIImage*) imageByResourceDrawable:(NSString*)drawableName;
+ (UIImage*) imageByResourceDrawable:(NSString*)drawableName withOptions:(JWImageOptions*)options;

/**
 * 按比例缩放image
 */
- (UIImage*) imageByScale:(CGFloat)scale;
- (UIImage*) imageByScaleAspectFitWidth:(CGFloat)width;
- (UIImage*) imageByScaleAspectFitHeight:(CGFloat)height;
- (UIImage*) imageByOptions:(JWImageOptions*)options;

/**
 * 若image为类android定义的9-patch格式,则转换成系统可用的resizable image
 */
@property (nonatomic, readonly) UIImage* ninePatch;
- (UIImage*) ninePatchWithOptions:(JWImageOptions*)options;
@property (nonatomic, readonly) UIEdgeInsets insets;

/**
 * 把image数据转换为字节流,格式为RGBA8888
 * @param scalePowerOf2 是否强制缩放为2的N次幂
 */
- (JCBitmap) bitmapScalePowerOf2:(BOOL)scalePowerOf2;
+ (UIImage*) fromBitmap:(JCBitmapRef)bitmap;

@end
