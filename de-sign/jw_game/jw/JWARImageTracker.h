//
//  JWARImageTracker.h
//  June Winter_game
//
//  Created by GavinLo on 15/3/5.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWObject.h>

@protocol JIARImageTracker <JIObject>

/**
 * 初始化Tracker，系统调用
 */
- (BOOL)initTracker;

/**
 * 启动Tracker，一般有系统调用，可以通过设置enabled=false阻止系统启动Tracker
 */
- (BOOL)startTracker;

/**
 * 停止Tracker，一般有系统调用
 */
- (BOOL)stopTracker;

/**
 * Tracker是否可用，可用的Tracker会有系统在适当的时候启动
 */
@property (nonatomic, readwrite, getter=isEnabled) BOOL enabled;

- (void) registerImageTarget:(id<JIARImageTarget>)target;
- (void) unregisterImageTarget:(id<JIARImageTarget>)target;

@end

@interface JWARImageTracker : JWObject <JIARImageTracker> {
    BOOL mEnabled;
    id<JIUList> mTargets;
}

@property (nonatomic, readonly) id<JIUList> targets;

@end
