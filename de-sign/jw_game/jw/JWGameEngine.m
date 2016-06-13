//
//  JWGameEngine.m
//  June Winter
//
//  Created by GavinLo on 14-5-3.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWGameEngine.h"
#import <UIKit/UIKit.h>
#import "JWGamePluginSystem.h"
#import "JWGameContext.h"
#import "JWGame.h"
#import "JWGameWorld.h"
#import "JWGameFrame.h"
#import "JWTimer.h"
#import "JWUpdateTimer.h"
#import "JWRenderTimer.h"
#import "JWAppEvents.h"
#import "JWARPlugin.h"
#import "JWGamepadManager.h"

@interface JWGameEngine () <JITimeUpdatable>
{
    id<JIGamePluginSystem> mPluginSystem;
    id<JIGameContext> mContext;
    id<JIGame> mGame;
    id<JIGameFrame> mFrame;
    id<JIUpdateTimer> mUpdateTimer;
    id<JIRenderTimer> mRenderTimer;
    
    JWAppEventBinder* mAppEventBinder;
    id<JIGamepadManager> mGamepadManager;
}

@end

@implementation JWGameEngine

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        [self createContext];
    }
    return self;
}

- (void)onCreate {
    [super onCreate];
    [self createUpdateTimer];
    [self createRenderTimer];
    [self createGameFrame];
    
//    // 初始化AR
//    id<JIARPlugin> arPlugin = self.pluginSystem.arPlugin;
//    if (arPlugin != nil) {
//        [arPlugin onInit];
//    }
}

- (void)onDestroy {
    // 注销AR
    id<JIARPlugin> arPlugin = self.pluginSystem.arPlugin;
    if (arPlugin != nil) {
        [arPlugin onDeinit];
    }
    
    UIView* frame = mFrame.view;
    [mAppEventBinder unbindEventsFromView:frame willUnbindSubviews:NO andFilter:nil];
    [JWCoreUtils destroyObject:mAppEventBinder];
    mAppEventBinder = nil;
    [JWCoreUtils destroyObject:mGamepadManager];
    mGamepadManager = nil;
    [super onDestroy];
}

- (void) createContext {
    mContext = [JWGameContext contextWithEngine:self];
    [mContext onCreate];
}

- (void) createUpdateTimer {
    mUpdateTimer = [JWUpdateTimer timerWith:self];
    mUpdateTimer.frequency = 60.0f;
}

- (void) createRenderTimer {
    id<JIARPlugin> arPlugin = self.pluginSystem.arPlugin;
    if(arPlugin != nil) { // AR可以重定义renderTimer
        mRenderTimer = [arPlugin createRenderTimer:self];
    }
    if (mRenderTimer == nil) {
        mRenderTimer = [self.pluginSystem.renderPlugin createRenderTimer:self];
    }
    [mRenderTimer onCreate];
    mRenderTimer.frequency = 60.0f;
}

- (void) createGameFrame {
    id<JIARPlugin> arPlugin = self.pluginSystem.arPlugin;
    if(arPlugin != nil) { // AR可以重定义gameFrame
        mFrame = [arPlugin createGameFrame:self];
    }
    if (mFrame == nil) {
        mFrame = [self.pluginSystem.renderPlugin createGameFrame:self];
    }
    [mFrame onCreate];
    UIView* view = mFrame.view;
    if(mAppEventBinder == nil)
        mAppEventBinder = [[JWAppEventBinder alloc] initWithEvents:self];
    [mAppEventBinder bindEventsToView:view willBindSubviews:NO andFilter:nil];
    // 基本手势互斥处理
    [mAppEventBinder.gestureEventBinder.lastSingleTapGestureRecognizer requireGestureRecognizerToFail:mAppEventBinder.gestureEventBinder.lastLongPressGestureRecognizer];
}

#pragma events begin

- (BOOL)onTouchDown:(NSSet *)touches withEvent:(UIEvent *)event {
    id<JIGameWorld> world = mGame.world;
    return [world onTouchDown:touches withEvent:event];
}

- (BOOL)onTouchMove:(NSSet *)touches withEvent:(UIEvent *)event {
    id<JIGameWorld> world = mGame.world;
    return [world onTouchMove:touches withEvent:event];
}

- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    id<JIGameWorld> world = mGame.world;
    return [world onTouchUp:touches withEvent:event];
}

- (BOOL)onTouchCancel:(NSSet *)touches withEvent:(UIEvent *)event {
    id<JIGameWorld> world = mGame.world;
    return [world onTouchCancel:touches withEvent:event];
}

- (void)onPinch:(UIPinchGestureRecognizer *)pinch {
    id<JIGameWorld> world = mGame.world;
    [world onPinch:pinch];
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap {
    id<JIGameWorld> world = mGame.world;
    [world onSingleTap:singleTap];
}

- (void)onDoubleTap:(UITapGestureRecognizer *)doubleTap {
    id<JIGameWorld> world = mGame.world;
    [world onDoubleTap:doubleTap];
}

- (void)onDoubleDrag:(UIPanGestureRecognizer *)doubleDrag {
    if (doubleDrag.numberOfTouches != 2) { // NOTE 严格控制是双指拖动
        return;
    }
    id<JIGameWorld> world = mGame.world;
    [world onDoubleDrag:doubleDrag];
}

- (void)onLongPress:(UILongPressGestureRecognizer *)longPress {
    id<JIGameWorld> world = mGame.world;
    [world onLongPress:longPress];
}

- (void)onGamepad:(id<JIGamepad>)gamepad {
    id<JIGameWorld> world = mGame.world;
    [world onGamepad:gamepad];
}

#pragma events end

- (void)onResume {
    [mUpdateTimer start];
    [mRenderTimer start];
}

- (void)onPause {
    [mUpdateTimer pause];
    [mRenderTimer pause];
}

- (id<JIGamePluginSystem>)pluginSystem {
    if(mPluginSystem == nil) {
        mPluginSystem = [[JWGamePluginSystem alloc] init];
    }
    return mPluginSystem;
}

- (id<JIGameContext>)context {
    return mContext;
}

- (id<JIGame>)game {
    if (mGame == nil) {
        @throw [NSException exceptionWithName:@"Game Engine" reason:@"Game must not be null." userInfo:nil];
    }
    return mGame;
}

- (void)setGame:(id<JIGame>)game {
    if (mGame == game) {
        return;
    }
    
    [mGame onDestroy];
    mGame = game;
    
    JWGame* g = mGame;
    [g setEngine:self];
    [mGame onCreate];
}

- (id<JIGameFrame>)frame {
    return mFrame;
}

- (id<JIUpdateTimer>)updateTimer {
    return mUpdateTimer;
}

- (id<JIRenderTimer>)renderTimer {
    return mRenderTimer;
}

- (JWAppEventBinder *)eventBinder {
    return mAppEventBinder;
}

- (id<JIGamepadManager>)gamepadManager {
    if (mGamepadManager == nil) {
        mGamepadManager = [mPluginSystem.inputPlugin createGamepadManager:self];
    }
    return mGamepadManager;
}

- (void)onFrameReady {
    // 初始化AR
    id<JIARPlugin> arPlugin = self.pluginSystem.arPlugin;
    if (arPlugin != nil) {
        [arPlugin onInit];
    }
}

- (void)onUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime {
    id<JIGameWorld> world = mGame.world;
    if (world != nil) {
        [world onUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
    }
}

@end
