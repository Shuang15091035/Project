//
//  JWMultiCamera.m
//  June Winter_game
//
//  Created by ddeyes on 16/1/21.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWMultiCamera.h"

@implementation JWMultiCamera

- (void)enumCameraUsing:(void (^)(id<JICamera>, NSUInteger))block {
    // subclass override
}

- (BOOL)preRenderCamera:(id<JICamera>)camera atIndex:(NSUInteger)idx {
    // subclass override
    return true;
}

- (void)postRenderCamera:(id<JICamera>)camera atIndex:(NSUInteger)idx {
    // subclass override
}

- (void)setZNear:(float)zNear {
    [super setZNear:zNear];
    [self enumCameraUsing:^(id<JICamera> camera, NSUInteger idx) {
        [camera setZNear:zNear];
    }];
}

- (void)setZFar:(float)zFar {
    [super setZFar:zFar];
    [self enumCameraUsing:^(id<JICamera> camera, NSUInteger idx) {
        [camera setZFar:zFar];
    }];
}

- (void)setFovy:(float)fovy  {
    [super setFovy:fovy];
    [self enumCameraUsing:^(id<JICamera> camera, NSUInteger idx) {
        [camera setFovy:fovy];
    }];
}

- (void)setOrthoScale:(float)orthoScale {
    [super setOrthoScale:orthoScale];
    [self enumCameraUsing:^(id<JICamera> camera, NSUInteger idx) {
        [camera setOrthoScale:orthoScale];
    }];
}

- (void)setProjectionMode:(JWProjectionMode)projectionMode {
    [super setProjectionMode:projectionMode];
    [self enumCameraUsing:^(id<JICamera> camera, NSUInteger idx) {
        [camera setProjectionMode:projectionMode];
    }];
}

@end
