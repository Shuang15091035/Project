//
//  JWGameScene.m
//  June Winter
//
//  Created by GavinLo on 14-4-30.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWGameScene.h"
#import "JWGameEngine.h"
#import "JWGameFrame.h"
#import "JWGameObject.h"
#import "JWRenderQueue.h"
#import "JWCamera.h"
#import "JWRayQuery.h"
#import "JWBoundsQuery.h"
#import "JWObjectQuery.h"
#import "JWAnimation.h"
#import "JWAnimationResource.h"
#import "JWAnimationResourceManager.h"
#import "JWList.h"

@interface JWGameScene ()
{
    id<JIGameObject> mRoot;
    id<JICamera> mTransitionCamera;
    id<JIAnimation> mTransitionCameraAnimation;
}

@property (nonatomic, readonly) id<JIUList> cameraList;
@property (nonatomic, readonly) id<JIUList> lightList;

@end

@implementation JWGameScene

- (id<JIUList>)cameraList
{
    if(mCameras == nil)
        mCameras = [JWSafeUList list];
    return mCameras;
}

- (id<JIUList>)lightList
{
    if(mLights == nil)
        mLights = [JWSafeUList list];
    return mLights;
}

- (id)initWithContext:(id<JIGameContext>)context
{
    self = [super init];
    if(self != nil)
    {
        mContext = context;
        [self createRoot];
    }
    return self;
}

- (void)onDestroy
{
    [mLights clear];
    [mCameras clear];
    [JWCoreUtils destroyObject:mRenderQueue];
    mRenderQueue = nil;
    [JWCoreUtils destroyObject:mRayQuery];
    mRayQuery = nil;
    [JWCoreUtils destroyObject:mBoundsQuery];
    mBoundsQuery = nil;
    [JWCoreUtils destroyObject:mObjectQuery];
    mObjectQuery = nil;
    [super onDestroy];
}

- (void)setId:(NSString *)Id {
    [super setId:Id];
    self.root.Id = [NSString stringWithFormat:@"root@%@", Id];
    self.root.name = self.root.Id;
}

- (void) createRoot
{
    JWGameObject* root = (JWGameObject*)[mContext createObject];
    NSString* rootId = [NSString stringWithFormat:@"root@%@", @(self.hash)];
    root.Id = rootId;
    root.name = rootId;
    [root onAddToScene:self];
    mRoot = root;
}

- (id<JIGameContext>)context
{
    return mContext;
}

- (id<JIGameObject>)root
{
    return mRoot;
}

- (void)addCamera:(id<JICamera>)camera
{
    if(camera == nil)
        return;
    [self.cameraList addObject:camera likeASet:YES];
}

- (void)removeCamera:(id<JICamera>)camera
{
    if(camera == nil)
        return;
    [self.cameraList removeObject:camera];
}

- (id<JICamera>)getCameraById:(NSString *)cameraId
{
    if(mCameras == nil)
        return nil;
    __block id<JICamera> found = nil;
    [mCameras enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JICamera> camera = obj;
        if ([camera.Id isEqualToString:cameraId]) {
            found = camera;
            *stop = YES;
        }
    }];
    return found;
}

- (id<JICamera>)currentCamera
{
    return mCurrentCamera;
}

- (BOOL)changeCameraById:(NSString *)cameraId
{
    id<JICamera> camera = [self getCameraById:cameraId];
    return [self changeCamera:camera];
}

- (BOOL)changeCameraById:(NSString *)cameraId duration:(NSUInteger)duration
{
    if(duration == 0 || mCurrentCamera == nil)
        return [self changeCameraById:cameraId];
    
    id<JICamera> camera = [self getCameraById:cameraId];
    if (camera == nil || mCurrentCamera == camera) {
        return NO;
    }
    
    // 生成过渡camera
    if (mTransitionCamera == nil) {
        id<JIGameObject> transitionCameraObject = [mContext createObject];
        transitionCameraObject.Id = [NSString stringWithFormat:@"transtition-camera@%@", @(self.hash)];
        transitionCameraObject.name = transitionCameraObject.Id;
        transitionCameraObject.parent = mRoot;
        
        mTransitionCamera = [mContext createCamera];
        mTransitionCamera.Id = transitionCameraObject.Id;
        mTransitionCamera.name = mTransitionCamera.Id;
        [transitionCameraObject addComponent:mTransitionCamera];
        
        mTransitionCameraAnimation = [mContext createAnimation];
        [transitionCameraObject addComponent:mTransitionCameraAnimation];
        id<JIAnimationResource> animationResource = (id<JIAnimationResource>)[mContext.animationResourceManager createFromFile:[JWFile fileWithName:mTransitionCamera.name content:nil]];
        JWAnimationTrack* animationTrack = [animationResource addTrackByTarget:nil type:JCAnimationTypeTransform duration:duration loop:NO];
        // 生成两帧的过渡动画
        [animationTrack addKeyFrame:JCAnimationFrameMake(0)];
        [animationTrack addKeyFrame:JCAnimationFrameMake(0)];
        mTransitionCameraAnimation.resource = animationResource;
    }
    
    // 修改动画数据
    JWAnimationTrack* animationTrack = mTransitionCameraAnimation.resource.mainTrack;
    JCAnimationFrameRef startFrame = [animationTrack keyFrameAtIndex:0];
    JCAnimationFrameRef endFrame = [animationTrack keyFrameAtIndex:1];
    startFrame->timePosition = 0;
    endFrame->timePosition = duration;
    JWTransform* currentCameraTransform = mCurrentCamera.transform;
    [currentCameraTransform update];
    JCTransform cct = JCTransformGetTransform(currentCameraTransform._transform, true);
    JWTransform* cameraTransform = camera.transform;
    [camera.transform update];
    JCTransform ct = JCTransformGetTransform(cameraTransform._transform, true);
    JCTransformSetTransform(&startFrame->transform, &cct, false);
    JCTransformSetTransform(&endFrame->transform, &ct, false);
    
//    JCAnimationTrack animationTrack = JCAnimationTrackMake();
//    JCAnimationTrackInit(&animationTrack, JCAnimationTypeTransform, duration);
//    JCAnimationTrackAddKeyFrame(&animationTrack, startFrame);
//    JCAnimationTrackAddKeyFrame(&animationTrack, endFrame);
//    mTransitionCameraAnimation.resource.track = &animationTrack;
    
//    JWAnimationTrack* animationTrack = [JWAnimationTrack trackWithType:JCAnimationTypeTransform duration:duration loop:NO];
//    [animationTrack addKeyFrame:startFrame];
//    [animationTrack addKeyFrame:endFrame];
//    [mTransitionCameraAnimation.resource addTrack:animationTrack];
    
    JWTransform* transitionCameraTransform = mTransitionCamera.transform;
    [transitionCameraTransform _setTransform:currentCameraTransform._transform inWorld:NO];
    mTransitionCameraAnimation.length = duration;
    
    // 启动动画并且在结束时切换到目标camera
    [mTransitionCameraAnimation stop];
    JWAnimationListener* listener = [[JWAnimationListener alloc] init];
    listener.onPause = (^void(id<JIAnimation> animation)
    {
        [self changeCamera:camera];
    });
    mTransitionCameraAnimation.listener = listener;
    [mTransitionCameraAnimation play];
    
    return [self changeCamera:mTransitionCamera];
}

- (BOOL) changeCamera:(id<JICamera>)camera
{
    if(camera == nil || mCurrentCamera == camera)
        return NO;
    
    // auto abjust aspect
    if (camera.willAutoAdjustAspect) {
        if (mContext != nil) {
            id<JIGameEngine> engine = mContext.engine;
            if (engine != nil) {
                id<JIGameFrame> frame = engine.frame;
                if (frame != nil) {
                   [camera setAspectWithWidth:frame.width andHeight:frame.height];
                }
            }
        }
    }
    
    mCurrentCamera = camera;
    return YES;
}

- (void)addLight:(id<JILight>)light
{
    if(light == nil)
        return;
    if([self.lightList addObject:light likeASet:YES])
        [self notifyLightsChanged];
}

- (void)removeLight:(id<JILight>)light
{
    if(light == nil)
        return;
    if([self.lightList removeObject:light])
        [self notifyLightsChanged];
}

- (id<NSFastEnumeration>)lights
{
    return self.lightList;
}

- (void) notifyLightsChanged
{
    // TODO
}

- (JCColor)clearColor {
    return mClearColor;
}

- (void)setClearColor:(JCColor)clearColor {
    mClearColor = clearColor;
    
    id<JIGameEngine> engine = mContext.engine;
    UIView* gameView = engine.frame.view;
    if (gameView != nil) {
        if (JCColorHasAlpha(&mClearColor)) { // NOTE 若底色为透明（alpha不为1，或者不接近1），则让渲染窗口也成为透明
            gameView.opaque = NO;
            gameView.backgroundColor = [UIColor clearColor];
        } else {
            gameView.opaque = YES;
            gameView.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (id<JIRayQuery>)rayQuery
{
    if(mRayQuery == nil)
        mRayQuery = [[JWRayQuery alloc] init];
    return mRayQuery;
}

- (id<JIBoundsQuery>)boundsQuery {
    if (mBoundsQuery == nil) {
        mBoundsQuery = [[JWBoundsQuery alloc] init];
    }
    return mBoundsQuery;
}

- (id<JIObjectQuery>)objectQuery {
    if (mObjectQuery == nil) {
        mObjectQuery = [[JWObjectQuery alloc] init];
    }
    return mObjectQuery;
}

- (id<JIRayQueryResult>)getCameraRayQueryResultFromScreenX:(float)x screenY:(float)y {
    if (mCurrentCamera == nil) {
        return nil;
    }
    JCVector2 cameraXY = [mCurrentCamera getCoordinatesFromScreenX:x screenY:y];
    JCRay3 ray = [mCurrentCamera getRayFromX:cameraXY.x screenY:cameraXY.y];
    id<JIRayQueryResult> result = [self.rayQuery getResultByRay:ray object:mRoot];
    return result;
}

- (JCRayPlaneIntersectResult)getCameraRayToUnitYZeroPlaneResultFromScreenX:(float)x screenY:(float)y {
    if (mCurrentCamera == nil) {
        return JCRayPlaneIntersectResultMake(false, 0.0f);
    }
    JCVector2 cameraXY = [mCurrentCamera getCoordinatesFromScreenX:x screenY:y];
    JCRay3 ray = [mCurrentCamera getRayFromX:cameraXY.x screenY:cameraXY.y];
    JCPlane ground = JCPlaneUnitYZero();
    JCRayPlaneIntersectResult result = JCRayPlaneIntersect(&ray, &ground);
    return result;
}

- (id<JIRenderQueue>)renderQueue
{
    if(mRenderQueue == nil)
        mRenderQueue = [[JWRenderQueue alloc] init];
    return mRenderQueue;
}

- (void)onUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime
{
    [mRoot onUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
}

#pragma events begin

- (BOOL)onTouchDown:(NSSet *)touches withEvent:(UIEvent *)event {
    return [mRoot onTouchDown:touches withEvent:event];
}

- (BOOL)onTouchMove:(NSSet *)touches withEvent:(UIEvent *)event {
    return [mRoot onTouchMove:touches withEvent:event];
}

- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    return [mRoot onTouchUp:touches withEvent:event];
}

- (BOOL)onTouchCancel:(NSSet *)touches withEvent:(UIEvent *)event {
   return [mRoot onTouchCancel:touches withEvent:event];
}

- (void)onPinch:(UIPinchGestureRecognizer *)pinch {
    [mRoot onPinch:pinch];
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap {
    [mRoot onSingleTap:singleTap];
}

- (void)onDoubleTap:(UITapGestureRecognizer *)doubleTap {
    [mRoot onDoubleTap:doubleTap];
}

- (void)onDoubleDrag:(UIPanGestureRecognizer *)doubleDrag {
    [mRoot onDoubleDrag:doubleDrag];
}

- (void)onLongPress:(UILongPressGestureRecognizer *)longPress {
    [mRoot onLongPress:longPress];
}

- (void)onGamepad:(id<JIGamepad>)gamepad {
    [mRoot onGamepad:gamepad];
}

#pragma events end

- (void)onGameFrameChangedWidth:(float)width andHeight:(float)height {
    if (mCameras == nil) {
        return;
    }
    for(id<JICamera> camera in mCameras) {
        if(camera.willAutoAdjustAspect) {
            switch (camera.projectionMode) {
                case JWProjectionModeOrtho: {
                    [camera setOrthoWindowWithWidth:width andHeight:height];
                    break;
                }
                case JWProjectionModePerspective: {
                    [camera setAspectWithWidth:width andHeight:height];
                    break;
                }
            }
        }
    }
}

@end
