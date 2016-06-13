//
//  JWDeviceMotionCamera.m
//  June Winter_game
//
//  Created by GavinLo on 15/3/22.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWDeviceMotionCamera.h"
#import "JWGameContext.h"
#import "JWGameObject.h"
#import "JWCamera.h"
#import "JWBehaviour.h"
#import <jw/CMDeviceMotion+JWCoreCategory.h>

@interface JWDeviceMotionCameraBehaviour : JWBehaviour

- (id) initWithContext:(id<JIGameContext>)context cameraPrefab:(JWDeviceMotionCamera*)cameraPrefab;
- (void) start;
- (void) calibrate;

@end

@interface JWDeviceMotionCameraBehaviour () {
    JWDeviceMotionCamera* mCameraPrefab;
    
    NSTimeInterval mInitTimeStamp;
    CMAttitude* mInitAttitude;
    CMAcceleration mInitAcceleration;
    CMAcceleration mInitGravity;
    JCVector3 mLastV;
    JCVector3 mInitPosition;
}

@end

@implementation JWDeviceMotionCameraBehaviour

- (id)initWithContext:(id<JIGameContext>)context cameraPrefab:(JWDeviceMotionCamera *)cameraPrefab {
    self = [super initWithContext:context];
    if (self != nil) {
        mCameraPrefab = cameraPrefab;
    }
    return self;
}

- (void)start {
    CMMotionManager* motionManager = mContext.motionManager;
    if (motionManager.deviceMotionAvailable) {
        motionManager.deviceMotionUpdateInterval = 1;
        [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            if (mInitAttitude == nil) {
                mInitTimeStamp = motion.timestamp;
                mInitAttitude = motion.attitude;
                mInitAcceleration = motion.userAccelerationInReferenceFrame;
                mInitGravity = motion.gravityInReferenceFrame;
                mInitPosition.z = 0.0f;
                mLastV.z = 0.0f;
                return;
            }
            [motion.attitude multiplyByInverseOfAttitude:mInitAttitude];
//            CMQuaternion q = motion.attitude.quaternion;
//            JCQuaternion qq = JCQuaternionMake(q.w, q.x, q.y, q.z);
//            [mCameraPrefab.camera.transform setOrientationQ:qq inSpace:JWTransformSpaceLocal];
            
            // s = v0·t + a·t²/2
//            float dt = motion.timestamp - mInitTimeStamp;
//            CMAcceleration a = motion.userAccelerationInReferenceFrame;
//            //a.y *= 9.8f;
//            //NSLog(@"ay:%@", @(a.y));
//            //float ay = a.y - mInitAcceleration.y;
//            float ay = (a.y + mInitAcceleration.y) / 2.0f;
//            //float ay = a.y;
//            //float ay = motion.gravity.y + motion.userAcceleration.y;
////            ay *= 9.8f * 100.0f;
//            //ay = -ay;
//            ay *= -9.8f;
//            //float vy = ay * dt / 2.0f;
//            float vy = mLastV.y + ay * dt;
//            //float dy = vy * dt;
//            mInitPosition.y += ((mLastV.y + vy) / 2.0f) * dt;
//            //NSLog(@"dy:%@", @(dy));
//            //[mCameraPrefab.camera.transform setPositionX:0.0f Y:0.0f Z:dy inSpace:JWTransformSpaceParent];
//            //[mCameraPrefab.camera.transform translateX:0.0f Y:0.0f Z:dy inSpace:JWTransformSpaceParent];
//            //mInitPosition.y += dy;
//            //NSLog(@"y:%@", @(mCameraPrefab.camera.transform.position.z));
//            NSLog(@"y:%@", @(mInitPosition.y));
//            //float py = mInitPosition.y * 100.0f;
//            //[mCameraPrefab.camera.transform setPositionX:0.0f Y:0.0f Z:py inSpace:JWTransformSpaceParent];
//            mInitTimeStamp = motion.timestamp;
//            mInitAcceleration = a;
//            mLastV.y = vy;
            
            // TODO 完善
//            float t0 = mInitTimeStamp;
//            float t1 = motion.timestamp;
//            float t = t1 - t0;
//            float g0 = mInitGravity.z;
//            float g1 = motion.gravityInReferenceFrame.z;
//            float a0 = mInitAcceleration.z;
//            float a1 = motion.userAccelerationInReferenceFrame.z;
//            //float a = (a0 + a1) * 9.8f / 2.0f;
//            float a = (a1 - a0) * 9.8f;
//            //float a = ((a1 + g0) - (a0 + g1)) * 9.8f;
//            float v0 = mLastV.z;
//            //float v1 = v0 + (a * t);
//            float v1 = a1 * 9.8f;
//            float v = (v0 + v1) / 2.0f;
//            float dp = v * t;
//            mInitPosition.z += dp;
//            NSLog(@"h:%.4f", mInitPosition.z);
//            mInitTimeStamp = t1;
//            mInitAcceleration.z = a1;
//            mInitGravity.z = g1;
//            mLastV.z = v1;
        }];
    }
}

- (void) calibrate {
    mInitAttitude = nil;
    mInitTimeStamp = 0.0f;
    [mCameraPrefab.camera.transform setPosition:JCVector3Make(0.0f, 0.0f, 0.0f) inSpace:JWTransformSpaceLocal];
}

@end

@interface JWDeviceMotionCamera () {
    JWDeviceMotionCameraBehaviour* mCameraBehaviour;
}

@end

@implementation JWDeviceMotionCamera

- (void)onCreateWithContext:(id<JIGameContext>)context {
    mCamera.host.parent = mRoot;
    [mRoot.transform picthDegrees:-90.0f];
    
    mCameraBehaviour = [[JWDeviceMotionCameraBehaviour alloc] initWithContext:context cameraPrefab:self];
    [mCamera.host addComponent:mCameraBehaviour];
}

- (void)start {
    [mCameraBehaviour start];
}

- (void)calibrate {
    [mCameraBehaviour calibrate];
}

@end
