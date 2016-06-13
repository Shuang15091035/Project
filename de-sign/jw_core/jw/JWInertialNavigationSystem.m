//
//  JWInertialNavigationSystem.m
//  jw_core
//
//  Created by GavinLo on 15/3/29.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWInertialNavigationSystem.h"
#import <CoreMotion/CoreMotion.h>
#import <jw/CMDeviceMotion+JWCoreCategory.h>

@interface JWInertialNavigationSystem () {
    JCInertialNavigationSystem mInertialNavigationSystem;
    CMMotionManager* mMotionManager;
    CMAttitude* mCalibrateAttitude;
    OnInertialNavigationSystemUpdateBlock mOnUpdate;
}

@end

@implementation JWInertialNavigationSystem

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        [self onCreate];
    }
    return self;
}

- (void)dealloc {
    [self onDestroy];
}

- (void)onCreate {
    [super onCreate];
    mInertialNavigationSystem = JCInertialNavigationSystemMake();
    mMotionManager = [CMMotionManager new];
}

- (void)onDestroy {
    [super onDestroy];
}

- (BOOL)start {
    if (!mMotionManager.deviceMotionAvailable) {
        return NO;
    }
    mMotionManager.deviceMotionUpdateInterval = 1.0 / 60.0f;
    JCInertialNavigationSystemStartCalibrating(&mInertialNavigationSystem, 2.0);
    [mMotionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical toQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        
//        if (mCalibrateAttitude != nil) {
//            CMRotationMatrix rm = motion.attitude.rotationMatrix;
//            [motion.attitude multiplyByInverseOfAttitude:mCalibrateAttitude];
//            CMRotationMatrix rm2 = motion.attitude.rotationMatrix;
//            int i = 0;
//        }
        JCFloat time = motion.timestamp;
        CMAcceleration a = motion.userAccelerationInGlobalFrame;
        JCVector3 linearAcceleration = JCVector3Make(a.x, a.y, a.z);
        linearAcceleration = JCVector3Muls(&linearAcceleration, 9.81);
//        JCQuaternion orientation = JCQuaternionMake(motion.attitude.quaternion.w, motion.attitude.quaternion.x, motion.attitude.quaternion.y, motion.attitude.quaternion.z);
//        JCInertialNavigationSystemUpdate(&mInertialNavigationSystem, time, acceleration, orientation);
        JCVector3 rotationRate = JCVector3Make(motion.rotationRate.x, motion.rotationRate.y, motion.rotationRate.z);
        JCInertialNavigationSystemUpdate(&mInertialNavigationSystem, time, linearAcceleration, rotationRate);
        JCInertialNavigationSystemResult result = mInertialNavigationSystem.result;
        switch (result.state) {
            case JCInertialNavigationSystemStateStartTracking: {
                mCalibrateAttitude = motion.attitude;
                break;
            }
            default:
                break;
        }
        
        if (mOnUpdate != nil) {
            mOnUpdate(self);
        }
    }];
    return YES;
}

- (void)stop {
    [mMotionManager stopDeviceMotionUpdates];
}

- (JCInertialNavigationSystemResult)result {
    return mInertialNavigationSystem.result;
}

- (OnInertialNavigationSystemUpdateBlock)onUpdate {
    return mOnUpdate;
}

- (void)setOnUpdate:(OnInertialNavigationSystemUpdateBlock)onUpdate {
    mOnUpdate = onUpdate;
}

@end
