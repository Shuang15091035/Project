//
//  JWBirdCameraPrefab.m
//  June Winter_game
//
//  Created by ddeyes on 15/10/26.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWBirdCameraPrefab.h"
#import "JWGameContext.h"
#import "JWGameObject.h"
#import "JWCamera.h"
#import "JWCameraPrefabDefaultBehaviour.h"

@interface JWBirdCameraPrefab () {
    float mMoveStepFactorPerspective;
    float mMoveStepFactorOrtho;
}

@end

@implementation JWBirdCameraPrefab

- (id)initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent cameraId:(NSString *)cameraId initZoom:(float)initZoom {
    self = [super initWithContext:context parent:parent cameraId:cameraId];
    if (self != nil) {
        mMoveStepFactorPerspective = 1.0f;
        mMoveStepFactorOrtho = 1.0f;
        [mCamera.transform picthDegrees:-90.0f];
        [self setCameraPosition:initZoom newZoom:initZoom];
        
        // TODO bounds disable
    }
    return self;
}

- (void)onCreateOthersWithContext:(id<JIGameContext>)context {
    mCamera.host.parent = mRoot;
}

- (id<JIBehaviour>)onCreateCameraBehaviourWithContext:(id<JIGameContext>)context {
    return [[JWCameraPrefabDefaultBehaviour alloc] initWithContext:context cameraPrefab:self];
}

- (void)move1dx:(float)dx dy:(float)dy {
    float p = mCamera.projectionMode == JWProjectionModePerspective ? mMoveStepFactorPerspective : mMoveStepFactorOrtho;
    float deltaX = dx * mMove1SpeedX * p;
    float deltaY = dy * mMove1SpeedY * p;
    [mRoot.transform translate:JCVector3Make(deltaX, 0.0f, deltaY)];
}

- (void)scaleS:(float)s
{
    float t = mCamera.transform.position.y;
    float nt = t + (s * mScaleSpeed);
    [self setCameraPosition:t newZoom:nt];
    // TODO constraint
}

- (void) setCameraPosition:(float)zoom newZoom:(float)newZoom {
    switch (mCamera.projectionMode) {
        case JWProjectionModeOrtho: {
            float scale = newZoom / zoom;
            mCamera.orthoScale *= scale;
            //mMoveStepFactorOrtho *= scale;
            break;
        }
        case JWProjectionModePerspective: {
            [mCamera.transform setPosition:JCVector3Make(0.0f, newZoom, 0.0f)];
            mMoveStepFactorPerspective = newZoom / 10.0f;
            break;
        }
    }
}

@end
