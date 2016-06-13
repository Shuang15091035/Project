//
//  JWFPSCameraPrefab.m
//  June Winter
//
//  Created by GavinLo on 14/12/27.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWFPSCameraPrefab.h"
#import "JWGameContext.h"
#import "JWGameObject.h"
#import "JWCamera.h"
#import "JWCameraPrefabDefaultBehaviour.h"

@implementation JWFPSCameraPrefab

- (id)initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent cameraId:(NSString *)cameraId initPicth:(float)initPicth initYaw:(float)initYaw initHeight:(float)initHeight
{
    self = [super initWithContext:context parent:parent cameraId:cameraId];
    if(self != nil)
    {
        [mCamera.transform picthDegrees:initPicth];
        [mRoot.transform yawDegrees:initYaw];
        [mCamera.transform translate:JCVector3Make(0.0f, initHeight, 0.0f)];
        
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

- (void)move1dx:(float)dx dy:(float)dy
{
    const float deltaYaw = dx * mMove1SpeedX;
    // TODO constraint
    {
        [mRoot.transform yawDegrees:deltaYaw];
    }
    
    const float deltaPicth = dy * mMove1SpeedY;
    // TODO constraint
    {
        [mCamera.transform picthDegrees:deltaPicth];
    }
}

- (void)scaleS:(float)s
{
    const float deltaZoom = s * mScaleSpeed;
    [mRoot.transform translate:JCVector3Make(0.0f, 0.0f, deltaZoom) inSpace:JWTransformSpaceLocal];
    // TODO constraint
}

@end
