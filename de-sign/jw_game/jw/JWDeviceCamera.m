//
//  JWDeviceCamera.m
//  June Winter_game
//
//  Created by ddeyes on 15/11/19.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWDeviceCamera.h"
#import "JWGameContext.h"
#import "JWGameObject.h"
#import "JWCamera.h"
#import "JWBehaviour.h"
#import <jw/CMDeviceMotion+JWCoreCategory.h>
#import <jw/UIDevice+JWCoreCategory.h>

@interface JWDeviceCamera () {
    id<JIGameObject> mHead;
}

@end

@implementation JWDeviceCamera

- (void)onCreateOthersWithContext:(id<JIGameContext>)context {
    mHead = [context createObject];
    mHead.parent = mRoot;
    mCamera.host.parent = mHead;
    [mHead.transform setPosition:JCVector3Make(0.0f, 1.5f, 0.0f)];
}

- (void)start {
    CMMotionManager* motionManager = mContext.motionManager;
    if (motionManager.deviceMotionAvailable) {
        if ([UIDevice currentDevice].type == UIDeviceTypeIPad) {
            if ([UIDevice currentDevice].ipadModel <= UIDeviceIPadModel4) {
                motionManager.deviceMotionUpdateInterval = 1.0f / 30.0f;
            } else {
                motionManager.deviceMotionUpdateInterval = 1.0f / 60.0f;
            }
        } else if ([UIDevice currentDevice].type == UIDeviceTypeIPhone) {
            if ([UIDevice currentDevice].iphoneModel <= UIDeviceIPhoneModel4) {
                motionManager.deviceMotionUpdateInterval = 1.0f / 15.0f;
            } else if ([UIDevice currentDevice].iphoneModel > UIDeviceIPhoneModel4 && [UIDevice currentDevice].iphoneModel < UIDeviceIPhoneModel5s) {
                motionManager.deviceMotionUpdateInterval = 1.0f / 30.0f;
            } else {
                motionManager.deviceMotionUpdateInterval = 1.0f / 60.0f;
            }
        }
        [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical toQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            //JCQuaternion q = [motion orientationByDeviceOrientation:[[UIDevice currentDevice] orientation]];
            JCQuaternion q = [motion orientationByInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
            [mCamera.transform setOrientation:q inSpace:JWTransformSpaceLocal];
        }];
    }
}

- (void)stop {
    CMMotionManager* motionManager = mContext.motionManager;
    [motionManager stopDeviceMotionUpdates];
}

- (float)height {
    return mHead.transform.position.y;
}

- (void)setHeight:(float)height {
    [mHead.transform setPosition:JCVector3Make(mHead.transform.position.x, height, mHead.transform.position.z)];
}

@end
