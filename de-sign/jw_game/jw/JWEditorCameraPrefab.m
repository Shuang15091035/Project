//
//  JWEditorCameraPrefab.m
//  June Winter
//
//  Created by GavinLo on 14/11/12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWEditorCameraPrefab.h"
#import "JWGameContext.h"
#import "JWGameObject.h"
#import "JWCamera.h"
#import "JWCameraPrefabDefaultBehaviour.h"

@interface JWEditorCameraPrefab ()
{
    id<JIGameObject> mRotateXObject;
    
    // TODO constraint
    BOOL mPitchConstraintEnabled;
    float mMinPitch;
    float mMaxPitch;
    JCLinearFunction mLinearScale;
}

@end

@implementation JWEditorCameraPrefab

- (id)initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent cameraId:(NSString *)cameraId initPicth:(float)initPicth initYaw:(float)initYaw initZoom:(float)initZoom
{
    self = [super initWithContext:context parent:parent cameraId:cameraId];
    if(self != nil)
    {
        [mRoot.transform yawDegrees:initYaw];
        [mRotateXObject.transform picthDegrees:initPicth];
        [mCamera.transform translate:JCVector3Make(0.0f, 0.0f, initZoom)];
        
        mLinearScale = JCLinearFunctionMake(0.0f, 0.0f);
    }
    return self;
}

- (float)yaw {
    return mRoot.transform.yawing;
}

- (void)setYaw:(float)yaw {
    [mRoot.transform resetOrientation:NO];
    [mRoot.transform yawDegrees:yaw];
}

- (float)picth {
    return mRotateXObject.transform.pitching;
}

- (void)setPicth:(float)picth {
    [mRotateXObject.transform resetOrientation:NO];
    [mRotateXObject.transform picthDegrees:picth];
}

- (float)zoom {
    return mCamera.transform.position.z;
}

- (void)setZoom:(float)zoom {
    JCVector3 position = mCamera.transform.position;
    position.z = zoom;
    [mCamera.transform setPosition:position];
}

@synthesize linearScale = mLinearScale;

- (void)onCreateOthersWithContext:(id<JIGameContext>)context {
    NSString* rotateXId = [NSString stringWithFormat:@"%@@rotateX", mCamera.Id];
    mRotateXObject = [context createObject];
    mRotateXObject.Id = rotateXId;
    mRotateXObject.name = rotateXId;
    mRotateXObject.parent = mRoot;
    mCamera.host.parent = mRotateXObject;
    
    // TODO bounds disable
}

- (id<JIBehaviour>)onCreateCameraBehaviourWithContext:(id<JIGameContext>)context {
    return [[JWCameraPrefabDefaultBehaviour alloc] initWithContext:context cameraPrefab:self];
}

- (void)move1dx:(float)dx dy:(float)dy
{
    const float deltaYaw = dx * mMove1SpeedX;
    // TODO constraint
    {
        [mRoot.transform yawDegrees:deltaYaw];
    }
    
    const float deltaPitch = dy * mMove1SpeedY;
    // TODO constraint
    if (mPitchConstraintEnabled) {
        float pitch = mRotateXObject.transform.pitching;
        pitch += deltaPitch;
        if (mMinPitch < pitch && pitch < mMaxPitch) {
            [mRotateXObject.transform picthDegrees:deltaPitch];
        }
    } else {
        [mRotateXObject.transform picthDegrees:deltaPitch];
    }
    
    // TODO constraint bounds
}

- (void)move2dx:(float)dx dy:(float)dy {
    if (!mMove2Enabled) {
        return;
    }
    JCAxes axes = mCamera.transform.axes;
//    const float deltaX = dx * mMove2SpeedX;
//    const float deltaY = dy * mMove2SpeedY;
    JCVector3 detalX = JCVector3Muls(&axes.x, dx * mMove2SpeedX);
    JCVector3 detalY = JCVector3Muls(&axes.z, dy * mMove2SpeedY);
    [mRoot.transform translate:detalX inSpace:JWTransformSpaceLocal];
    [mRoot.transform translate:detalY inSpace:JWTransformSpaceLocal];
    //[mRoot.transform translateX:deltaX Y:0.0f Z:deltaY];
}

- (void)scaleS:(float)s
{
    float t = mCamera.host.transform.position.z;
    float ls = JCLinearFunctionFx(&mLinearScale, t);
    //NSLog(@"%@", @(ls));
    float finalScaleSpeed = mScaleSpeed + ls;
    t += s * finalScaleSpeed;
    // TODO constraint
    {
        [mCamera.host.transform setPosition:JCVector3Make(0.0f, 0.0f, t)];
    }
    // TODO constraint bounds
}

@synthesize pitchConstraintEnabled = mPitchConstraintEnabled;
@synthesize minPitch = mMinPitch;
@synthesize maxPitch = mMaxPitch;

- (void)adjustCameraTransform:(id<JITransform>)transform {
    JCVector3 position = transform.position;
    JCQuaternion orientation = transform.orientation;
    JCVector3 xAxis;
    JCVector3 yAxis;
    JCVector3 zAxis;
    JCQuaternionToAxes(&orientation, &xAxis, &yAxis, &zAxis);
    JCVector3 cameraPos = position;
    JCVector3 cameraDir = JCVector3Negative(&zAxis);
    
    // 确定root的position
    JCRay3 cameraRay = JCRay3Make(cameraPos, cameraDir);
    JCVector3 rootWorldPosition = [mRoot.transform positionInSpace:JWTransformSpaceWorld];
    JCPlane plane = JCPlaneMake(JCVector3UnitY(), rootWorldPosition.y);
    JCRayPlaneIntersectResult result = JCRayPlaneIntersect(&cameraRay, &plane);
    if (!result.hit) {
        // TODO 暂时不能往上看
//        return;
        result.point = JCVector3Zero(); // 平行无交点 设置原点为焦点
        result.distance = 5.0f; // TODO 暂时
    } else {
        result.point = JCRayPlaneIntersectResultGetHitPoint(&result, &cameraRay);
    }
    [mRoot.transform setPosition:JCVector3Make(result.point.x, rootWorldPosition.y, result.point.z) inSpace:JWTransformSpaceWorld];
    
    // 确定camera的position的z
    float cameraZ = result.distance;
    [mCamera.host.transform setPosition:JCVector3Make(0.0f, 0.0f, cameraZ)];
    
    // 确定root的yaw
    JCVector3 planeYawDir = zAxis;
    planeYawDir.y = rootWorldPosition.y;
    planeYawDir = JCVector3Normalize(&planeYawDir);
    JCVector3 planeUnitZ = JCVector3UnitZ();
    planeUnitZ.y = rootWorldPosition.y;
    float cosYaw = JCVector3DotProductv(&planeYawDir, &planeUnitZ);
    float yaw = JCRad2Deg(JCAcosf(cosYaw));
    JCVector3 f = JCVector3CrossProductv(&planeUnitZ, &planeYawDir);
    if (f.y < 0.0f) {
        yaw = -yaw;
    }
    [mRoot.transform resetOrientation:NO];
    [mRoot.transform yawDegrees:yaw];
    
    // 确定rotateX的picth
    [mRotateXObject.transform resetOrientation:NO];
    CGFloat height = position.y;
//    JCVector3 d = JCVector3Subv(&position,&result.point);
//    CGFloat distance = JCVector3SquareLength(&d);
//    CGFloat picthDegreeRad = asinf(height/distance);
//    CGFloat picthDegree = picthDegreeRad * 180/3.14;
    CGFloat distance = sqrt(pow(position.x - result.point.x, 2) + pow(position.y - result.point.y, 2) + pow(position.z - result.point.z, 2));
    if (distance != 0) {
        CGFloat picthDegreeRad = asinf(height/distance);
        CGFloat picthDegree = picthDegreeRad * 180/3.14;
        [mRotateXObject.transform picthDegrees:-picthDegree];
    }
}

@end
