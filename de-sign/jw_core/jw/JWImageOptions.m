//
//  JWImageOptions.m
//  June Winter
//
//  Created by GavinLo on 15/1/5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWImageOptions.h"
#import "UIScreen+JWCoreCategory.h"

@interface JWImageOptions ()
{
    BOOL mHasFixedSize;
    CGFloat mFixedWidth;
    CGFloat mFixedHeight;
    JWKeepRatioPolicy mKeepRatioPolicy;
    BOOL mScalePowerOf2;
    UIEdgeInsets mInsets;
}

@end

@implementation JWImageOptions

+ (id)options
{
    return [[JWImageOptions alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if(self != nil)
    {
        mKeepRatioPolicy = JWKeepRatioPolicyUnknown;
        mInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (BOOL)hasRequestSize
{
    return mHasFixedSize;
}

- (void)setHasRequestSize:(BOOL)hasRequestSize
{
    mHasFixedSize = hasRequestSize;
}

- (CGFloat)requestWidth
{
    return self.fixedWidth;
}

- (void)setRequestWidth:(CGFloat)requestWidth
{
    self.fixedWidth = requestWidth;
}

- (CGFloat)requestHeight
{
    return self.fixedHeight;
}

- (void)setRequestHeight:(CGFloat)requestHeight
{
    self.fixedHeight = requestHeight;
}

- (BOOL)hasFixedSize
{
    return mHasFixedSize;
}

- (void)setHasFixedSize:(BOOL)hasFixedSize
{
    mHasFixedSize = hasFixedSize;
}

- (CGFloat)fixedWidth
{
    return mFixedWidth;
}

- (void)setFixedWidth:(CGFloat)fixedWidth
{
    mFixedWidth = [[UIScreen mainScreen] getRelativeWidth:fixedWidth];
    mHasFixedSize = YES;
}

- (CGFloat)fixedHeight
{
    return mFixedHeight;
}

- (void)setFixedHeight:(CGFloat)fixedHeight
{
    mFixedHeight = [[UIScreen mainScreen] getRelativeHeight:fixedHeight];
    mHasFixedSize = YES;
}

@synthesize keepRatioPolicy = mKeepRatioPolicy;
@synthesize scalePowerOf2 = mScalePowerOf2;
@synthesize insets = mInsets;

@end
