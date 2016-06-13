//
//  JWGameEngine.h
//  June Winter
//
//  Created by GavinLo on 14-5-3.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWLifeCycle.h>
#import <jw/JWGameEvents.h>

@protocol JIGameEngine <JILifeCycle, JIGameEvents>

@property (nonatomic, readonly) id<JIGamePluginSystem> pluginSystem;
@property (nonatomic, readonly) id<JIGameContext> context;
@property (nonatomic, readwrite) id<JIGame> game;
@property (nonatomic, readonly) id<JIGameFrame> frame;
@property (nonatomic, readonly) id<JIUpdateTimer> updateTimer;
@property (nonatomic, readonly) id<JIRenderTimer> renderTimer;
@property (nonatomic, readonly) JWAppEventBinder* eventBinder;
@property (nonatomic, readonly) id<JIGamepadManager> gamepadManager;

/**
 * UI准备好后调用，某些插件需要在这里才能初始化
 */
- (void) onFrameReady;

@end

@interface JWGameEngine : JWLifeCycle <JIGameEngine>

@end
