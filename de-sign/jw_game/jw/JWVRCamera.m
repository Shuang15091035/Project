//
//  JWVRCamera.m
//  June Winter_game
//
//  Created by ddeyes on 16/1/21.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWVRCamera.h"
#import "JWGameContext.h"
#import "JWGameObject.h"

@interface JWVRCamera () {
    id<JICamera> mLeftEye;
    id<JICamera> mRightEye;
    float mIPD;
}

@end

@implementation JWVRCamera

- (id)initWithContext:(id<JIGameContext>)context {
    self = [super initWithContext:context];
    if (self != nil) {
        id<JIGameObject> leftEyeObject = [context createObject];
        mLeftEye = [context createCamera];
        [leftEyeObject addComponent:mLeftEye];
        NSString* leftEyeName = [NSString stringWithFormat:@"left_eye_%@", @(mLeftEye.hash)];
        leftEyeObject.Id = leftEyeName;
        leftEyeObject.name = leftEyeName;
        mLeftEye.Id = leftEyeName;
        mLeftEye.name = leftEyeName;
        
        id<JIGameObject> rightEyeObject = [context createObject];
        mRightEye = [context createCamera];
        [rightEyeObject addComponent:mRightEye];
        NSString* rightEyeName = [NSString stringWithFormat:@"right_eye_%@", @(mRightEye.hash)];
        rightEyeObject.Id = rightEyeName;
        rightEyeObject.name = rightEyeName;
        mRightEye.Id = rightEyeName;
        mRightEye.name = rightEyeName;
        
        self.viewport = JCViewportDefault();
        [self setIPD:0.06f]; // 60mm，正常人平均瞳距
    }
    return self;
}

- (id<JICamera>)leftEye {
    return mLeftEye;
}

- (id<JICamera>)rightEye {
    return mRightEye;
}

- (float)IPD {
    return mIPD;
}

- (void)setIPD:(float)IPD {
    mIPD = IPD;
    [mLeftEye.host.transform setPosition:JCVector3Make(-IPD * 0.5f, 0.0f, 0.0f)];
    [mRightEye.host.transform setPosition:JCVector3Make(IPD * 0.5f, 0.0f, 0.0f)];
}

- (void)enumCameraUsing:(void (^)(id<JICamera>, NSUInteger))block {
    block(mLeftEye, 0);
    block(mRightEye, 1);
}

- (void)setAspectWithWidth:(float)width andHeight:(float)height {
    [super setAspectWithWidth:width andHeight:height];
    float hw = width * 0.5f;
    [mLeftEye setAspectWithWidth:hw andHeight:height];
    [mRightEye setAspectWithWidth:hw andHeight:height];
}

- (void)setViewport:(JCViewport)viewport {
    [super setViewport:viewport];
    float hw = viewport.width * 0.5f;
    JCViewport leftViewport = JCViewportMake(viewport.left, viewport.top, hw, viewport.height);
    [mLeftEye setViewport:leftViewport];
    JCViewport rightViewport = JCViewportMake(viewport.left + hw, viewport.top, hw, viewport.height);
    [mRightEye setViewport:rightViewport];
}

- (void)onAddToHost:(id<JIGameObject>)host {
    [super onAddToHost:host];
    mLeftEye.host.parent = host;
    mRightEye.host.parent = host;
}

- (void)onRemoveFromHost:(id<JIGameObject>)host {
    [super onRemoveFromHost:host];
    mLeftEye.host.parent = nil;
    mRightEye.host.parent = nil;
}

@end
