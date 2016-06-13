//
//  CMDeviceMotion+JWCoreCategory.m
//  jw_core
//
//  Created by GavinLo on 15/3/24.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "CMDeviceMotion+JWCoreCategory.h"
#import <jw/JCMath.h>

@implementation CMDeviceMotion (JWCoreCategory)

//- (JCQuaternion)orientationByDeviceOrientation:(UIDeviceOrientation)orientation {
//    CMQuaternion aq = self.attitude.quaternion;
//    JCQuaternion q = JCQuaternionMake(aq.w, aq.x, aq.y, aq.z);
//    NSLog(@"o:%@", @(orientation));
//    switch (orientation) {
//        case UIDeviceOrientationLandscapeLeft: {
//            JCQuaternion r;
//            r = JCQuaternionFromAngleAxis(-JCPi2, JCVector3UnitZ());
//            q = JCQuaternionMulq(&r, &q);
//            r = JCQuaternionFromAngleAxis(JCPi2, JCVector3UnitX());
//            q = JCQuaternionMulq(&r, &q);
//            r = JCQuaternionFromAngleAxis(JCPi2, JCVector3UnitZ());
//            q = JCQuaternionMulq(&q, &r);
//            break;
//        }
//        case UIDeviceOrientationLandscapeRight: {
//            JCQuaternion r;
//            r = JCQuaternionFromAngleAxis(-JCPi2, JCVector3UnitZ());
//            q = JCQuaternionMulq(&r, &q);
//            r = JCQuaternionFromAngleAxis(-JCPi2, JCVector3UnitX());
//            q = JCQuaternionMulq(&r, &q);
//            r = JCQuaternionFromAngleAxis(JCPi2, JCVector3UnitZ());
//            q = JCQuaternionMulq(&q, &r);
//            break;
//        }
//        case UIDeviceOrientationPortrait: {
//            JCQuaternion r;
//            r = JCQuaternionFromAngleAxis(-JCPi2, JCVector3UnitX());
//            q = JCQuaternionMulq(&r, &q);
//            break;
//        }
//        case UIDeviceOrientationPortraitUpsideDown: {
//            JCQuaternion r;
//            r = JCQuaternionFromAngleAxis(JCPi2, JCVector3UnitX());
//            q = JCQuaternionMulq(&r, &q);
//            break;
//        }
//        default:
//            break;
//    }
////    JCVector3 x;
////    JCVector3 y;
////    JCVector3 z;
////    JCQuaternionToAxes(&q, &x, &y, &z);
////    NSLog(@"(%.2f,%.2f,%.2f),(%.2f,%.2f,%.2f),(%.2f,%.2f,%.2f)", x.x, x.y, x.z, y.x, y.y, y.z, z.x, z.y, z.z);
//    return q;
//}

- (JCQuaternion)orientationByInterfaceOrientation:(UIInterfaceOrientation)orientation {
    CMQuaternion aq = self.attitude.quaternion;
    JCQuaternion q = JCQuaternionMake(aq.w, aq.x, aq.y, aq.z);
    switch (orientation) {
        case UIInterfaceOrientationLandscapeRight: {
            JCQuaternion r;
            r = JCQuaternionFromAngleAxis(JCPi2, JCVector3UnitZ());
            q = JCQuaternionMulq(&r, &q);
            r = JCQuaternionFromAngleAxis(-JCPi2, JCVector3UnitX());
            q = JCQuaternionMulq(&r, &q);
            r = JCQuaternionFromAngleAxis(-JCPi2, JCVector3UnitZ());
            q = JCQuaternionMulq(&q, &r);
            break;
        }
        case UIInterfaceOrientationLandscapeLeft: {
            JCQuaternion r;
            r = JCQuaternionFromAngleAxis(-JCPi2, JCVector3UnitZ());
            q = JCQuaternionMulq(&r, &q);
            r = JCQuaternionFromAngleAxis(-JCPi2, JCVector3UnitX());
            q = JCQuaternionMulq(&r, &q);
            r = JCQuaternionFromAngleAxis(JCPi2, JCVector3UnitZ());
            q = JCQuaternionMulq(&q, &r);
            break;
        }
        case UIInterfaceOrientationPortrait: {
            JCQuaternion r;
            r = JCQuaternionFromAngleAxis(-JCPi2, JCVector3UnitX());
            q = JCQuaternionMulq(&r, &q);
            break;
        }
        case UIInterfaceOrientationPortraitUpsideDown: {
            JCQuaternion r;
            r = JCQuaternionFromAngleAxis(JCPi2, JCVector3UnitX());
            q = JCQuaternionMulq(&r, &q);
            break;
        }
        default:
            break;
    }
    //    JCVector3 x;
    //    JCVector3 y;
    //    JCVector3 z;
    //    JCQuaternionToAxes(&q, &x, &y, &z);
    //    NSLog(@"(%.2f,%.2f,%.2f),(%.2f,%.2f,%.2f),(%.2f,%.2f,%.2f)", x.x, x.y, x.z, y.x, y.y, y.z, z.x, z.y, z.z);
    return q;
}

- (CMAcceleration)userAccelerationInReferenceFrame {
    CMAcceleration acc = [self userAcceleration];
    CMRotationMatrix rot = [self attitude].rotationMatrix;
    
    CMAcceleration accRef;
    accRef.x = acc.x*rot.m11 + acc.y*rot.m12 + acc.z*rot.m13;
    accRef.y = acc.x*rot.m21 + acc.y*rot.m22 + acc.z*rot.m23;
    accRef.z = acc.x*rot.m31 + acc.y*rot.m32 + acc.z*rot.m33;
    
    return accRef;
}

- (CMAcceleration)gravityInReferenceFrame {
    CMAcceleration acc = [self gravity];
    CMRotationMatrix rot = [self attitude].rotationMatrix;
    
    CMAcceleration accRef;
    accRef.x = acc.x*rot.m11 + acc.y*rot.m12 + acc.z*rot.m13;
    accRef.y = acc.x*rot.m21 + acc.y*rot.m22 + acc.z*rot.m23;
    accRef.z = acc.x*rot.m31 + acc.y*rot.m32 + acc.z*rot.m33;
    
    return accRef;
}

- (CMAcceleration)userAccelerationInGlobalFrame {
    CMAcceleration a = self.userAcceleration;
    CMRotationMatrix r = self.attitude.rotationMatrix;
    CMAcceleration ag;
    ag.x = a.x * r.m11 + a.y * r.m12 + a.z * r.m13;
    ag.y = a.x * r.m21 + a.y * r.m22 + a.z * r.m23;
    ag.z = a.x * r.m31 + a.y * r.m32 + a.z * r.m33;
    
//    static double bias = 0.0;
//    // calculate user acceleration in the direction of gravity
//    double verticalAcceleration = self.gravity.x * self.userAcceleration.x +
//    self.gravity.y * self.userAcceleration.y +
//    self.gravity.z * self.userAcceleration.z;
//    
//    // update the bias in low pass filter (bias is an object variable)
//    double delta = verticalAcceleration - bias;
//    if (ABS(delta) < 0.1) bias += 0.01 * delta;
//    
//    // remove bias from user acceleration
//    ag.x = self.userAcceleration.x - bias * self.gravity.x;
//    ag.y = self.userAcceleration.y - bias * self.gravity.y;
//    ag.z = self.userAcceleration.z - bias * self.gravity.z;
    
    return ag;
}

@end
