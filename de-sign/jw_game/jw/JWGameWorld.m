//
//  JWGameWorld.m
//  June Winter
//
//  Created by GavinLo on 14-5-2.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWGameWorld.h"
#import "JWCoreUtils.h"
#import "JWGameScene.h"
#import "JWCamera.h"
#import "JWList.h"

@interface JWGameWorld ()

@property (nonatomic, readonly) id<JIUList> scenes;

@end

@implementation JWGameWorld

- (id<JIUList>)scenes {
    if (mScenes == nil) {
        mScenes = [JWSafeUList list];
    }
    return mScenes;
}

- (void)onCreate {
    [super onCreate];
}

- (void)onDestroy {
    [JWCoreUtils destroyList:mScenes];
    mScenes = nil;
    [super onDestroy];
}

- (void)addScene:(id<JIGameScene>)scene {
    if (scene == nil) {
        return;
    }
    [self.scenes addObject:scene likeASet:YES];
}

- (void)removeScene:(id<JIGameScene>)scene {
    if (scene == nil) {
        return;
    }
    [self.scenes removeObject:scene];
}

- (void)removeAllScenes {
    [self.scenes clear];
}

- (id<JIGameScene>)currentScene {
    return mCurrentScene;
}

- (BOOL)changeSceneById:(NSString *)sceneId {
    id<JIGameScene> scene = [self getSceneById:sceneId];
    if (scene == nil) {
        return NO;
    }
    mCurrentScene = scene;
    return YES;
}

- (id<JIGameScene>)getSceneById:(NSString *)sceneId {
    if (sceneId == nil) {
        return nil;
    }
    
    id<JIUList> scenes = self.scenes;
    __block id<JIGameScene> found = nil;
    [scenes enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JIGameScene> scene = obj;
        if ([sceneId isEqualToString:scene.Id]) {
            found = scene;
            *stop = YES;
        }
    }];
    return found;
}

- (void)onUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime {
    if (mCurrentScene != nil) {
        [mCurrentScene onUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
    }
}

#pragma events begin

- (BOOL)onTouchDown:(NSSet *)touches withEvent:(UIEvent *)event {
   return [mCurrentScene onTouchDown:touches withEvent:event];
}

- (BOOL)onTouchMove:(NSSet *)touches withEvent:(UIEvent *)event {
    return [mCurrentScene onTouchMove:touches withEvent:event];
}

- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    return [mCurrentScene onTouchUp:touches withEvent:event];
}

- (BOOL)onTouchCancel:(NSSet *)touches withEvent:(UIEvent *)event {
    return [mCurrentScene onTouchCancel:touches withEvent:event];
}

- (void)onPinch:(UIPinchGestureRecognizer *)pinch {
    [mCurrentScene onPinch:pinch];
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap {
    [mCurrentScene onSingleTap:singleTap];
}

- (void)onDoubleTap:(UITapGestureRecognizer *)doubleTap {
    [mCurrentScene onDoubleTap:doubleTap];
}

- (void)onDoubleDrag:(UIPanGestureRecognizer *)doubleDrag {
    [mCurrentScene onDoubleDrag:doubleDrag];
}

- (void)onLongPress:(UILongPressGestureRecognizer *)longPress {
    [mCurrentScene onLongPress:longPress];
}

- (void)onGamepad:(id<JIGamepad>)gamepad {
    [mCurrentScene onGamepad:gamepad];
}

#pragma events end

- (JCViewport)onGameFrameChangedWidth:(float)width andHeight:(float)height
{
    if(mScenes == nil)
        return JCViewportDefault();
    
    [mScenes enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        JWGameScene* scene = obj;
        [scene onGameFrameChangedWidth:width andHeight:height];
    }];
    if(mCurrentScene == nil)
        return JCViewportDefault();
    id<JICamera> currentCamera = mCurrentScene.currentCamera;
    if(currentCamera == nil)
        return JCViewportDefault();
    return currentCamera.viewport;
}

@end
