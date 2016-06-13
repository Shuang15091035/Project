//
//  JWEditorCameraPrefab.h
//  June Winter
//
//  Created by GavinLo on 14/11/12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWCameraPrefab.h>
#import <jw/JCMath.h>

@interface JWEditorCameraPrefab : JWCameraPrefab

- (id) initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent cameraId:(NSString*)cameraId initPicth:(float)initPicth initYaw:(float)initYaw initZoom:(float)initZoom;

@property (nonatomic, readwrite) float yaw;
@property (nonatomic, readwrite) float picth;
@property (nonatomic, readwrite) float zoom;
@property (nonatomic, readwrite) BOOL pitchConstraintEnabled;
@property (nonatomic, readwrite) float minPitch;
@property (nonatomic, readwrite) float maxPitch;
@property (nonatomic, readwrite) JCLinearFunction linearScale;
- (void) adjustCameraTransform:(id<JITransform>)transform;

@end
