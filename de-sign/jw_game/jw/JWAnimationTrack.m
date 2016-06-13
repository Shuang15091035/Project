//
//  JWAnimationTrack.m
//  June Winter_game
//
//  Created by ddeyes on 16/2/25.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAnimationTrack.h"
#import "JWGameObject.h"

@interface JWAnimationTrack () {
    JCAnimationTrack mTrack;
    id mTarget;
    id<JIGameObject> mTargetObject;
}

@end

@implementation JWAnimationTrack

+ (id)trackWithTarget:(id)target type:(JCAnimationType)type duration:(NSUInteger)duration loop:(BOOL)loop {
    return [[self alloc] initWithTarget:target type:type duration:duration loop:loop];
}

+ (id)trackWithType:(JCAnimationType)type duration:(NSUInteger)duration loop:(BOOL)loop {
    return [[self alloc] initWithTarget:nil type:type duration:duration loop:loop];
}

- (id)initWithTarget:(id)target type:(JCAnimationType)type duration:(NSUInteger)duration loop:(BOOL)loop {
    self = [super init];
    if (self != nil) {
        mTrack = JCAnimationTrackMake(type, duration, loop ? true : false);
        self.target = target;
    }
    return self;
}

- (id)initWithType:(JCAnimationType)type duration:(NSUInteger)duration loop:(BOOL)loop {
    self = [super init];
    if (self != nil) {
        mTrack = JCAnimationTrackMake(type, duration, loop ? true : false);
    }
    return self;
}

- (id)target {
    return mTarget;
}

- (void)setTarget:(id)target {
    mTarget = target;
    if ([target conformsToProtocol:@protocol(JIGameObject)]) {
        mTargetObject = target;
    }
}

- (id<JIGameObject>)targetObject {
    return mTargetObject;
}

- (JCAnimationType)type {
    return mTrack.type;
}

- (void)setType:(JCAnimationType)type {
    mTrack.type = type;
}

- (NSUInteger)duration {
    return mTrack.duration;
}

- (void)setDuration:(NSUInteger)duration {
    mTrack.duration = duration;
}

- (BOOL)isLoop {
    return mTrack.isLoop ? YES : NO;
}

- (void)setLoop:(BOOL)loop {
    mTrack.isLoop = loop ? true : false;
}

- (JCAnimationInterpolationFunc)interpolationFunc {
    return mTrack.interpolationFunc;
}

- (void)setInterpolationFunc:(JCAnimationInterpolationFunc)interpolationFunc {
    mTrack.interpolationFunc = interpolationFunc;
}

- (JCAnimationFrameRef)addKeyFrame:(JCAnimationFrame)frame {
    return JCAnimationTrackAddKeyFrame(&mTrack, frame);
}

- (JCAnimationFrameRef)keyFrameAtIndex:(NSUInteger)index {
    return JCAnimationTrackKeyFrameAtIndexRef(&mTrack, index);
}

- (JCAnimationFrameRef)keyFrameAtTimePosition:(NSInteger)timePosition {
    JCULong numFrames = JCAnimationTrackGetNumKeyFrames(&mTrack);
    for (JCULong i = 0; i < numFrames; i++) {
        JCAnimationFrame* frame = &mTrack.frames[i];
        if (frame->timePosition == timePosition) {
            return frame;
        }
    }
    return NULL;
}

- (JCAnimationFrame)getInterpolationFrameByTimePosition:(NSInteger)timePosition {
    return JCAnimationTrackGetInterpolationFrame(&mTrack, timePosition);
}

- (BOOL)hasTheSameTypeWithTarget:(id)target type:(JCAnimationType)type {
    if (mTarget == target && mTrack.type == type) {
        return YES;
    }
    if (mTrack.type == JCAnimationTypeRotate && type == JCAnimationTypeEulerAngles)
    {
        return YES;
    }
    if (type == JCAnimationTypeRotate && mTrack.type == JCAnimationTypeEulerAngles)
    {
        return YES;
    }
    if (mTrack.type == JCAnimationTypeTransform
        && (type == JCAnimationTypeTranslate
            || type == JCAnimationTypeRotate
            || type == JCAnimationTypeScale
            || type == JCAnimationTypeEulerAngles))
    {
        return YES;
    }
    if (type == JCAnimationTypeTransform
        && (mTrack.type == JCAnimationTypeTranslate
            || mTrack.type == JCAnimationTypeRotate
            || mTrack.type == JCAnimationTypeScale
            || mTrack.type == JCAnimationTypeEulerAngles))
    {
        return YES;
    }
    return NO;
}

@end
