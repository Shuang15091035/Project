//
//  JWPhysicalProperty.m
//  June Winter_game
//
//  Created by ddeyes on 16/3/2.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWPhysicalProperty.h"
#import "JWTransform.h"

@interface JWPhysicalProperty () {
    JCVector3 mVelocity;
    JCVector3 mAngularSpeed;
    JCVector3 mAcceleration;
}

@end

@implementation JWPhysicalProperty

- (id)initWithContext:(id<JIGameContext>)context {
    self = [super initWithContext:context];
    if (self != nil) {
        mVelocity = JCVector3Zero();
        mAngularSpeed = JCVector3Zero();
        mAcceleration = JCVector3Zero();
    }
    return self;
}

@synthesize velocity = mVelocity;
@synthesize angularSpeed = mAngularSpeed;
@synthesize acceleration = mAcceleration;

- (void)reset {
    mVelocity = JCVector3Zero();
    mAngularSpeed = JCVector3Zero();
    mAcceleration = JCVector3Zero();
}

- (void)onComponentUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime {
    [super onComponentUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
    [self handlePhysics:elapsedTime];
}

- (void) handlePhysics:(NSUInteger)elapsedTime {
    id<JITransform> transform = self.transform;
    const float dt = (float)elapsedTime / 1000.0f;
    JCVector3 at = JCVector3Muls(&mAcceleration, dt);
    mVelocity = JCVector3Addv(&mVelocity, &at);
    JCVector3 vt = JCVector3Muls(&mVelocity, dt);
    
    if (mAngularSpeed.x != 0.0f) {
        [transform picthDegrees:mAngularSpeed.x];
    }
    if (mAngularSpeed.y != 0.0f) {
        [transform yawDegrees:mAngularSpeed.y];
    }
    if (mAngularSpeed.z != 0.0f) {
        [transform rollDegrees:mAngularSpeed.z];
    }
    [transform translate:vt];
}

@end
