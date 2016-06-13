//
//  JWRenderTimer.h
//  June Winter
//
//  Created by GavinLo on 14-5-3.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JCRect.h>
#import <jw/JWGamePredef.h>
#import <jw/JWTimer.h>
#import <jw/JWAsyncResult.h>
#import <jw/JWEventQueue.h>
#import <jw/JCFrameInfo.h>
#import <jw/JCGeometryInfo.h>

typedef void (^JWOnSnapshotBlock)(UIImage* screenshot);

@protocol JIOnSnapshotListener <NSObject>

- (void) onSnapshot:(UIImage*)snapshot;

@end

@interface JWOnSnapshotListener : NSObject <JIOnSnapshotListener>

@property (nonatomic, readwrite) JWOnSnapshotBlock onSnapshot;

@end

@protocol JIRenderTimer <JITimer>

- (void) requestRender;
- (UIImage*) snapshotByRect:(JCRect)rect;
- (JWAsyncResult*) snapshotByRect:(JCRect)rect async:(BOOL)async listener:(id<JIOnSnapshotListener>)listener;

@property (nonatomic, readonly) id<JIEventQueue> eventQueue;
@property (nonatomic, readonly) id<JIGameEngine> engine;
@property (nonatomic, readonly) JCFrameInfo frameInfo;
@property (nonatomic, readonly) JCGeometryInfo geometryInfo;

@end

@interface JWRenderTimer : JWTimer <JIRenderTimer>
{
    id<JIGameEngine> mEngine;
    id<JIEventQueue> mEventQueue;
    JCFrameInfo mFrameInfo;
    JCGeometryInfo mGeometryInfo;
}

- (id) initWithEngine:(id<JIGameEngine>)engine;
- (UIImage*) snapshotToUIImageByRect:(JCRect)rect;

@end
