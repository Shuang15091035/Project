//
//  JWFrustum.h
//  June Winter
//
//  Created by GavinLo on 14-4-30.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWComponent.h>

static const float JWDefaultZNear = 0.1f;
static const float JWDefaultZFar = 100.0f;
static const float JWDefaultFovy = 45.0f;
static const float JWDefaultAspect = 1.333f;
static const float JWDefaultOrthoWidth = 1.0f;
static const float JWDefaultOrthoHeight = 1.0f;

typedef NS_ENUM(NSInteger, JWProjectionMode) {
    JWProjectionModeOrtho,
    JWProjectionModePerspective,
};

@protocol JIFrustum <JIComponent>

@property (nonatomic, readwrite) float zNear;
@property (nonatomic, readwrite) float zFar;
@property (nonatomic, readwrite) float fovy;
@property (nonatomic, readwrite) float aspect;
- (void) setAspectWithWidth:(float)width andHeight:(float)height;
@property (nonatomic, readwrite) BOOL willAutoAdjustAspect;
@property (nonatomic, readonly) float orthoWidth;
@property (nonatomic, readonly) float orthoHeight;
- (void) setOrthoWindowWithWidth:(float)width andHeight:(float)height;
@property (nonatomic, readwrite) float orthoScale;
@property (nonatomic, readwrite) JWProjectionMode projectionMode;

@end

@interface JWFrustum : JWComponent <JIFrustum> {
    float mZNear;
    float mZFar;
    float mFovy;
    float mAspect;
    BOOL mWillAutoAdjustAspect;
    float mOrthoWidth;
    float mOrthoHeight;
    float mOrthoScale;
    JWProjectionMode mProjectionMode;
}

@end
