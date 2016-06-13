//
//  JWCameraPrefab.h
//  June Winter
//
//  Created by GavinLo on 14/11/12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWObject.h>
#import <jw/JCBounds3.h>

@protocol JICameraPrefab <JIObject>

@property (nonatomic, readonly) id<JICamera> camera;
@property (nonatomic, readonly) id<JIGameObject> root;

- (void) move1dx:(float)dx dy:(float)dy;
@property (nonatomic, readwrite) float move1SpeedX;
@property (nonatomic, readwrite) float move1SpeedY;
- (void) setMove1Speed:(float)move1Speed;

@property (nonatomic, readwrite) BOOL move2Enabled;
- (void) move2dx:(float)dx dy:(float)dy;
@property (nonatomic, readwrite) float move2SpeedX;
@property (nonatomic, readwrite) float move2SpeedY;
- (void) setMove2Speed:(float)move2Speed;

- (void) move3dx:(float)dx dy:(float)dy;
@property (nonatomic, readwrite) float move3SpeedX;
@property (nonatomic, readwrite) float move3SpeedY;

- (void) scaleS:(float)s;
@property (nonatomic, readwrite) float scaleSpeed;

@property (nonatomic, readwrite) JCBounds3 boundsConstraint;

@end

@interface JWCameraPrefab : JWObject <JICameraPrefab> {
    id<JIGameContext> mContext;
    id<JICamera> mCamera;
    id<JIGameObject> mRoot;
    float mMove1SpeedX;
    float mMove1SpeedY;
    BOOL mMove2Enabled;
    float mMove2SpeedX;
    float mMove2SpeedY;
    float mMove3SpeedX;
    float mMove3SpeedY;
    float mScaleSpeed;
    JCBounds3 mBoundsConstraint;
}

+ (id) cameraWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent cameraId:(NSString*)cameraId;
- (id) initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent cameraId:(NSString*)cameraId;

- (id<JICamera>) onCreateCameraWithContext:(id<JIGameContext>)context;
- (void) onCreateOthersWithContext:(id<JIGameContext>)context;
- (id<JIBehaviour>) onCreateCameraBehaviourWithContext:(id<JIGameContext>)context;

@end
