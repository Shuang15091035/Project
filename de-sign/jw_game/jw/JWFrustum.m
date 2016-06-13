//
//  JWFrustum.m
//  June Winter
//
//  Created by GavinLo on 14-4-30.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWFrustum.h"

@implementation JWFrustum

- (id)initWithContext:(id<JIGameContext>)context
{
    self = [super initWithContext:context];
    if(self != nil)
    {
        mProjectionMode = JWProjectionModePerspective;
        mZNear = JWDefaultZNear;
        mZFar = JWDefaultZFar;
        mFovy = JWDefaultFovy;
        mAspect = JWDefaultAspect;
        mWillAutoAdjustAspect = YES;
        mOrthoWidth = JWDefaultOrthoWidth;
        mOrthoHeight = JWDefaultOrthoHeight;
        mOrthoScale = 1.0f;
    }
    return self;
}

- (float)zNear
{
    return mZNear;
}

- (void)setZNear:(float)zNear
{
    mZNear = zNear;
}

- (float)zFar
{
    return mZFar;
}

- (void)setZFar:(float)zFar
{
    mZFar = zFar;
}

- (float)fovy
{
    return mFovy;
}

- (void)setFovy:(float)fovy
{
    mFovy = fovy;
}

- (BOOL)willAutoAdjustAspect
{
    return mWillAutoAdjustAspect;
}

- (void)setWillAutoAdjustAspect:(BOOL)willAutoAdjustAspect
{
    mWillAutoAdjustAspect = willAutoAdjustAspect;
}

- (float)aspect
{
    return mAspect;
}

- (void)setAspect:(float)aspect
{
    mAspect = aspect;
}

- (void)setAspectWithWidth:(float)width andHeight:(float)height
{
    if(height == 0.0f)
        return;
    self.aspect = width / height;
}

- (float)orthoWidth
{
    return mOrthoWidth * mOrthoScale;
}

- (float)orthoHeight
{
    return mOrthoHeight * mOrthoScale;
}

- (void)setOrthoWindowWithWidth:(float)width andHeight:(float)height
{
    mOrthoWidth = width;
    mOrthoHeight = height;
}

@synthesize orthoScale = mOrthoScale;

//- (void)orthoScale:(float)scale {
//    [self setOrthoWindowWithWidth:(mOrthoWidth * scale) andHeight:(mOrthoHeight * scale)];
//}

- (JWProjectionMode)projectionMode
{
    return mProjectionMode;
}

- (void)setProjectionMode:(JWProjectionMode)projectionMode
{
    mProjectionMode = projectionMode;
}

@end
