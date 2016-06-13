//
//  UIColor+JWCoreCategory.m
//  June Winter
//
//  Created by GavinLo on 14-3-11.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "UIColor+JWCoreCategory.h"

@implementation UIColor (JWCoreCategory)

- (UIColor *)initWithARGB:(unsigned long)argb
{
    CGFloat a = (CGFloat)((argb & 0xff000000) >> 24) / 255.0f;
    CGFloat r = (CGFloat)((argb & 0x00ff0000) >> 16) / 255.0f;
    CGFloat g = (CGFloat)((argb & 0x0000ff00) >> 8 ) / 255.0f;
    CGFloat b = (CGFloat) (argb & 0x000000ff)        / 255.0f;
    return [self initWithRed:r green:g blue:b alpha:a];
}

- (UIColor *)initWithRGB:(unsigned long)rgb
{
    NSInteger argb = 0xff000000 | rgb;
    return [self initWithARGB:argb];
}

+ (UIColor *)colorWithARGB:(unsigned long)argb
{
    return [[UIColor alloc] initWithARGB:argb];
}

+ (UIColor *)colorWithRGB:(unsigned long)rgb
{
    return [[UIColor alloc] initWithRGB:rgb];
}

@end
