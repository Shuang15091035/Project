//
//  JWRenderTimer.m
//  June Winter
//
//  Created by GavinLo on 14-5-3.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWRenderTimer.h"
#import <jw/JWAsyncEventHandler.h>
#import <jw/JWAsyncResultTask.h>
#import <jw/JWAsyncTaskResult.h>

@interface JWSnapshotEventHandler : JWAsyncEventHandler {
    id<JIOnSnapshotListener> mListener;
}

- (id) initWithAsync:(BOOL)async listener:(id<JIOnSnapshotListener>)listener;
- (void) onSnapshot:(UIImage*)snapshot;

@end

@implementation JWSnapshotEventHandler

- (id)initWithAsync:(BOOL)async listener:(id<JIOnSnapshotListener>)listener {
    self = [super initWithAsync:async];
    if (self != nil) {
        mListener = listener;
    }
    return self;
}

- (void)onSnapshot:(UIImage *)snapshot {
    if (mAsync) {
        if (mListener != nil) {
            [JWAsyncUtils runOnMainQueue:^{
                [mListener onSnapshot:snapshot];
            }];
        }
    } else {
        if (mListener != nil) {
            [mListener onSnapshot:snapshot];
        }
    }
}

@end

@interface JWSnapshotTask : JWAsyncResultTask {
    JCRect mRect;
    JWSnapshotEventHandler* mHandler;
    JWRenderTimer* mRenderTimer;
}

- (id) initWithResult:(JWAsyncResult *)result rect:(JCRect)rect handler:(JWSnapshotEventHandler*)handler renderTimer:(JWRenderTimer*)renderTimer;

@end

@implementation JWSnapshotTask

- (id)initWithResult:(JWAsyncResult *)result rect:(JCRect)rect handler:(JWSnapshotEventHandler *)handler renderTimer:(JWRenderTimer *)renderTimer {
    self = [super initWithResult:result];
    if (self != nil) {
        mRect = rect;
        mHandler = handler;
        mRenderTimer = renderTimer;
    }
    return self;
}

- (id)doInBackground:(NSArray *)params {
    if (self.isCancelled) {
        return nil;
    }
    UIImage* screenshot = [mRenderTimer snapshotToUIImageByRect:mRect];
    return screenshot;
}

- (void)onPostExecute:(id)result {
    if (self.isCancelled) {
        return;
    }
    mAsyncResult.syncResult = result;
    [mHandler onSnapshot:result];
}

@end

@interface JWOnSnapshotListener () {
    JWOnSnapshotBlock mOnSnapshot;
}

@end

@implementation JWOnSnapshotListener

- (void)onSnapshot:(UIImage *)snapshot {
    if (mOnSnapshot != nil) {
        mOnSnapshot(snapshot);
    }
}

- (JWOnSnapshotBlock)onSnapshot {
    return mOnSnapshot;
}

- (void)setOnSnapshot:(JWOnSnapshotBlock)onSnapshot {
    mOnSnapshot = onSnapshot;
}

@end

@implementation JWRenderTimer

- (id)initWithEngine:(id)engine {
    self = [super init];
    if (self != nil) {
        mEngine = engine;
        mFrameInfo = JCFrameInfoMake();
        mGeometryInfo = JCGeometryInfoMake();
    }
    return self;
}

- (void)requestRender {
    
}

- (UIImage *)snapshotByRect:(JCRect)rect {
    return [self snapshotByRect:rect async:NO listener:nil].syncResult;
}

- (JWAsyncResult *)snapshotByRect:(JCRect)rect async:(BOOL)async listener:(id<JIOnSnapshotListener>)listener {
    JWAsyncTaskResult* result = [JWAsyncTaskResult result];
    JWSnapshotEventHandler* handler = [[JWSnapshotEventHandler alloc] initWithAsync:async listener:listener];
    JWSnapshotTask* task = [[JWSnapshotTask alloc] initWithResult:result rect:rect handler:handler renderTimer:self];
    result.asyncTask = task;
    if (!async) {
        [task onPreExecute];
        if (task.isCancelled) {
            result.syncResult = nil;
            return result;
        }
        UIImage* screenshot = [task doInBackground:nil];
        [task onPostExecute:screenshot];
        result.syncResult = screenshot;
    } else {
        [task execute:nil];
        result.syncResult = nil;
    }
    return result;
}

- (UIImage *)snapshotToUIImageByRect:(JCRect)rect {
    // subclass override
    return nil;
}

- (id<JIEventQueue>)eventQueue {
    if (mEventQueue == nil) {
        mEventQueue = [JWEventQueue queue];
    }
    return mEventQueue;
}

@synthesize engine = mEngine;

- (JCFrameInfo)frameInfo {
    return mFrameInfo;
}

- (JCGeometryInfo)geometryInfo {
    return mGeometryInfo;
}

@end
