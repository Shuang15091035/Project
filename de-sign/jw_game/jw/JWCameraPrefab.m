//
//  JWCameraPrefab.m
//  June Winter
//
//  Created by GavinLo on 14/11/12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWCameraPrefab.h"
#import "JWGameContext.h"
#import "JWGameObject.h"
#import "JWCamera.h"
#import "JWBehaviour.h"

@implementation JWCameraPrefab

+ (id)cameraWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent cameraId:(NSString *)cameraId {
    return [[self alloc] initWithContext:context parent:parent cameraId:cameraId];
}

- (id)initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent cameraId:(NSString *)cameraId {
    self = [super init];
    if (self != nil) {
        mContext = context;
        mMove1SpeedX = 1.0f;
        mMove1SpeedY = 1.0f;
        mMove2Enabled = NO;
        mMove2SpeedX = 1.0f;
        mMove2SpeedY = 1.0f;
        mMove3SpeedX = 1.0f;
        mMove3SpeedY = 1.0f;
        mScaleSpeed = 1.0f;
        [self onCreateWithContext:context parent:parent cameraId:cameraId];
    }
    return self;
}

- (void)onDestroy {
    mContext = nil;
    [super onDestroy];
}

- (void)onCreateWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent cameraId:(NSString *)cameraId {
    id<JIGameObject> cameraObject = [context createObject];
    cameraObject.Id = cameraId;
    cameraObject.name = cameraId;
    mCamera = [self onCreateCameraWithContext:context];
    [cameraObject addComponent:mCamera];
    mCamera.Id = cameraId;
    
    NSString* rootId = [NSString stringWithFormat:@"%@@root", cameraId];
    mRoot = [context createObject];
    mRoot.Id = rootId;
    mRoot.name = rootId;
    mRoot.parent = parent;
    
    [self onCreateOthersWithContext:context];
    
    id<JIBehaviour> behaviour = [self onCreateCameraBehaviourWithContext:context];
    [mCamera.host addComponent:behaviour];
}

- (id<JICamera>)onCreateCameraWithContext:(id<JIGameContext>)context {
    return [context createCamera];
}

- (void)onCreateOthersWithContext:(id<JIGameContext>)context {
    // subclass override
}

- (id<JIBehaviour>)onCreateCameraBehaviourWithContext:(id<JIGameContext>)context {
    // subclass override
    return nil;
}

- (id<JICamera>)camera {
    return mCamera;
}

- (id<JIGameObject>)root {
    return mRoot;
}

- (void)move1dx:(float)dx dy:(float)dy {
    
}

@synthesize move1SpeedX = mMove1SpeedX;
@synthesize move1SpeedY = mMove1SpeedY;

- (void)setMove1Speed:(float)move1Speed {
    mMove1SpeedX = move1Speed;
    mMove1SpeedY = move1Speed;
}

@synthesize move2Enabled = mMove2Enabled;

- (void)move2dx:(float)dx dy:(float)dy {
    
}

@synthesize move2SpeedX = mMove2SpeedX;
@synthesize move2SpeedY = mMove2SpeedY;

- (void)setMove2Speed:(float)move2Speed {
    mMove2SpeedX = move2Speed;
    mMove2SpeedY = move2Speed;
}

- (void)move3dx:(float)dx dy:(float)dy {
    
}

@synthesize move3SpeedX = mMove3SpeedX;
@synthesize move3SpeedY = mMove3SpeedY;

- (void)scaleS:(float)s {
    
}

@synthesize scaleSpeed = mScaleSpeed;

@synthesize boundsConstraint = mBoundsConstraint;

@end
