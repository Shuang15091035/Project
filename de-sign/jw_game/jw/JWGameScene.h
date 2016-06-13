//
//  JWGameScene.h
//  June Winter
//
//  Created by GavinLo on 14-4-30.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWCore.h>
#import <jw/JWMutableArray.h>
#import <jw/JCColor.h>
#import <jw/JWGameEvents.h>
#import <jw/JCGeometryUtils.h>

@protocol JIGameScene <JIEntity, JITimeUpdatable, JIGameEvents>

@property (nonatomic, readonly) id<JIGameContext> context;
@property (nonatomic, readonly) id<JIGameObject> root;
- (void) addCamera:(id<JICamera>)camera;
- (void) removeCamera:(id<JICamera>)camera;
- (id<JICamera>) getCameraById:(NSString*)cameraId;
@property (nonatomic, readonly) id<JICamera> currentCamera;
- (BOOL) changeCameraById:(NSString*)cameraId;
- (BOOL) changeCameraById:(NSString*)cameraId duration:(NSUInteger)duration;

- (void) addLight:(id<JILight>)light;
- (void) removeLight:(id<JILight>)light;
@property (nonatomic, readonly) id<NSFastEnumeration> lights;

@property (nonatomic, readwrite) JCColor clearColor;
@property (nonatomic, readonly) id<JIRayQuery> rayQuery;
@property (nonatomic, readonly) id<JIBoundsQuery> boundsQuery;
@property (nonatomic, readonly) id<JIObjectQuery> objectQuery;
- (id<JIRayQueryResult>) getCameraRayQueryResultFromScreenX:(float)x screenY:(float)y;
- (JCRayPlaneIntersectResult) getCameraRayToUnitYZeroPlaneResultFromScreenX:(float)x screenY:(float)y;

@property (nonatomic, readonly) id<JIRenderQueue> renderQueue;

@end

@interface JWGameScene : JWEntity <JIGameScene>
{
    id<JIGameContext> mContext;
    id<JICamera> mCurrentCamera;
    id<JIUList> mCameras;
    id<JIUList> mLights;
    JCColor mClearColor;
    id<JIRayQuery> mRayQuery;
    id<JIBoundsQuery> mBoundsQuery;
    id<JIObjectQuery> mObjectQuery;
    
    id<JIRenderQueue> mRenderQueue;
}

- (id) initWithContext:(id<JIGameContext>)context;

- (void) onGameFrameChangedWidth:(float)width andHeight:(float)height;

@end
