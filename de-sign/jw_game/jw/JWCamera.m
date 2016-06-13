//
//  JWCamera.m
//  June Winter
//
//  Created by GavinLo on 14-4-30.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWCamera.h"
#import <jw/JWTransform.h>
#import <jw/JWAsyncEventHandler.h>
#import <jw/JWAsyncResultTask.h>
#import <jw/JWAsyncTaskResult.h>

@interface JWTakePictureEventHandler : JWAsyncEventHandler {
    id<JIOnTakePictureListener> mListener;
}

- (id) initWithAsync:(BOOL)async listener:(id<JIOnTakePictureListener>)listener;
- (void) onTakePicture:(UIImage*)picture;

@end

@implementation JWTakePictureEventHandler

- (id)initWithAsync:(BOOL)async listener:(id<JIOnTakePictureListener>)listener {
    self = [super initWithAsync:async];
    if (self != nil) {
        mListener = listener;
    }
    return self;
}

- (void)onTakePicture:(UIImage *)picture {
    if (mAsync) {
        if (mListener != nil) {
            [JWAsyncUtils runOnMainQueue:^{
                [mListener onTakePicture:picture];
            }];
        }
    } else {
        if (mListener != nil) {
            [mListener onTakePicture:picture];
        }
    }
}

@end

@interface JWTakePictureTask : JWAsyncResultTask {
    JCRect mRect;
    JWTakePictureEventHandler* mHandler;
    JWCamera* mCamera;
}

- (id) initWithResult:(JWAsyncResult *)result rect:(JCRect)rect handler:(JWTakePictureEventHandler*)handler renderTimer:(JWCamera*)camera;

@end

@implementation JWTakePictureTask

- (id)initWithResult:(JWAsyncResult *)result rect:(JCRect)rect handler:(JWTakePictureEventHandler *)handler renderTimer:(JWCamera *)camera {
    self = [super initWithResult:result];
    if (self != nil) {
        mRect = rect;
        mHandler = handler;
        mCamera = camera;
    }
    return self;
}

- (id)doInBackground:(NSArray *)params {
    if (self.isCancelled) {
        return nil;
    }
    UIImage* picture = [mCamera takePictureToUIImageByRect:mRect];
    return picture;
}

- (void)onPostExecute:(id)result {
    if (self.isCancelled) {
        return;
    }
    mAsyncResult.syncResult = result;
    [mHandler onTakePicture:result];
}

@end

@interface JWOnTakePictureListener () {
    JWOnTakePictureBlock mOnTakePicture;
}

@end

@implementation JWOnTakePictureListener

- (void)onTakePicture:(UIImage *)picture {
    if (mOnTakePicture != nil) {
        mOnTakePicture(picture);
    }
}

- (JWOnTakePictureBlock)onTakePicture {
    return mOnTakePicture;
}

- (void)setOnTakePicture:(JWOnTakePictureBlock)onTakePicture {
    mOnTakePicture = onTakePicture;
}

@end

@interface JWCamera () {
    JCCamera mCamera;
}

@end

@implementation JWCamera

- (id)initWithContext:(id<JIGameContext>)context {
    self = [super initWithContext:context];
    if (self != nil) {
        mViewport = JCViewportDefault();
        mCamera = JCCameraMake();
    }
    return self;
}

- (JCViewport)viewport {
    return mViewport;
}

- (void)setViewport:(JCViewport)viewport {
    mViewport = viewport;
    mViewportDirty = YES;
}

- (BOOL)preRender {
    // subclass override
    return true;
}

- (void)render {
    // subclass override
}

- (void)postRender {
    // subclass override
}

- (JCVector2)getCoordinatesFromScreenX:(JCFloat)screenX screenY:(JCFloat)screenY {
    // subclass override
    return JCVector2Zero();
}

- (JCRay3)getRayFromX:(JCFloat)cameraX screenY:(JCFloat)cameraY {
    // subclass override
    return JCRay3Make(JCVector3Zero(), JCVector3Zero());
}

- (UIImage *)takePictureByRect:(JCRect)rect {
    return [self takePictureByRect:rect async:NO listener:nil].syncResult;
}

- (JWAsyncResult *)takePictureByRect:(JCRect)rect async:(BOOL)async listener:(id<JIOnTakePictureListener>)listener {
    JWAsyncTaskResult* result = [JWAsyncTaskResult result];
    JWTakePictureEventHandler* handler = [[JWTakePictureEventHandler alloc] initWithAsync:async listener:listener];
    JWTakePictureTask* task = [[JWTakePictureTask alloc] initWithResult:result rect:rect handler:handler renderTimer:self];
    result.asyncTask = task;
    if (!async) {
        [task onPreExecute];
        if (task.isCancelled) {
            result.syncResult = nil;
            return result;
        }
        UIImage* picture = [task doInBackground:nil];
        [task onPostExecute:picture];
        result.syncResult = picture;
    } else {
        [task execute:nil];
        result.syncResult = nil;
    }
    return result;
}

- (UIImage *)takePictureToUIImageByRect:(JCRect)rect {
    // subclass override
    return nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@(id=%@,name=%@,znear=%@,zfar=%@,fovy=%@,aspect=%@,orthoW=%@,orthoH=%@,viewport=(%@,%@,%@,%@),projection=%@)", NSStringFromClass([self class]), self.Id, self.name, @(self.zNear), @(self.zFar), @(self.fovy), @(self.aspect), @(self.orthoWidth), @(self.orthoHeight), @(self.viewport.left), @(self.viewport.top), @(self.viewport.width), @(self.viewport.height), @(self.projectionMode)];
}

- (JCCameraRefC)ccamera {
    JCVector3 cameraPosition = [self.transform positionInSpace:JWTransformSpaceWorld];
    mCamera.position = cameraPosition;
    return &mCamera;
}

@end
