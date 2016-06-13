//
//  JWAnimation.m
//  June Winter
//
//  Created by GavinLo on 14/12/23.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAnimation.h"
#import "JWAnimationResource.h"
#import "JCFlags.h"
#import "JWGameObject.h"
#import "JWTransform.h"

@interface JWAnimationListener () {
    JWAnimationOnPlayBlock mOnPlay;
    JWAnimationOnPauseBlock mOnPause;
    JWAnimationOnStopBlock mOnStop;
    JWAnimationOnLoopBlock mOnLoop;
}

@end

@implementation JWAnimationListener

- (void)onPlayAnimation:(id<JIAnimation>)animation {
    if (mOnPlay != nil) {
        mOnPlay(animation);
    }
}

- (void)onPauseAnimation:(id<JIAnimation>)animation {
    if (mOnPause != nil) {
        mOnPause(animation);
    }
}

- (void)onStopAnimation:(id<JIAnimation>)animation {
    if (mOnStop != nil) {
        mOnStop(animation);
    }
}

- (void)onLoopAnimation:(id<JIAnimation>)animation {
    if (mOnLoop != nil) {
        mOnLoop(animation);
    }
}

- (JWAnimationOnPlayBlock)onPlay {
    return mOnPlay;
}

- (void)setOnPlay:(JWAnimationOnPlayBlock)onPlay {
    mOnPlay = onPlay;
}

- (JWAnimationOnPauseBlock)onPause {
    return mOnPause;
}

- (void)setOnPause:(JWAnimationOnPauseBlock)onPause {
    mOnPause = onPause;
}

- (JWAnimationOnStopBlock)onStop {
    return mOnStop;
}

- (void)setOnStop:(JWAnimationOnStopBlock)onStop {
    mOnStop = onStop;
}

- (JWAnimationOnLoopBlock)onLoop {
    return mOnLoop;
}

- (void)setOnLoop:(JWAnimationOnLoopBlock)onLoop {
    mOnLoop = onLoop;
}

@end

@interface JWAnimation () {
    NSInteger mLength;
    BOOL mLoop;
    float mSpeed; // 动画速度（设置1.5相当于x1.5，设置0.3相当于x0.3）
    BOOL mPlaying;
    NSInteger mTime;
    JWAnimationPlayDirection mDirection; // 动画播放的方向（顺序播放还是回放）
    BOOL mAnimated; // 动画是否从当前时间点过渡到指定时间点
    NSInteger mAnimTime; // 上述指定时间点
    
    id<JIAnimationResource> mResource;
    id<JIAnimationListener> mListener;
}

@end

@implementation JWAnimation

- (id)initWithContext:(id<JIGameContext>)context {
    self = [super initWithContext:context];
    if (self != nil) {
        mLength = 1000;
        mLoop = NO;
        mSpeed = 1.0f;
        mPlaying = NO;
        mTime = 0;
        mDirection = JWAnimationPlayDirectionForward;
        mAnimated = NO;
        mAnimTime = 0;
        mResource = nil;
        mListener = nil;
    }
    return self;
}

- (void)onComponentUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime {
    [super onComponentUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
    if (!mPlaying) {
        return;
    }
    if (mDirection) {
        NSInteger timePosition = mTime + ((NSInteger)((float)elapsedTime * mSpeed));
        if (mAnimated) {
            if (timePosition > mAnimTime) {
                timePosition = mAnimTime;
                mAnimated = NO;
                [self pause];
            }
        }
        if([self setTimeImpl:timePosition]) {
            [self pause];
        }
    } else {
        NSInteger timePosition = mTime - ((NSInteger)((float)elapsedTime * mSpeed));
        if (mAnimated) {
            if (timePosition < mAnimTime) {
                timePosition = mAnimTime;
                mAnimated = NO;
                [self pause];
            }
        }
        if([self setTimeImpl:timePosition]) {
            [self pause];
        }
    }
    [self requestRender];
}

- (NSInteger)length {
    return mLength;
}

- (void)setLength:(NSInteger)length {
    mLength = length;
}

- (BOOL)isLoop {
    return mLoop;
}

- (void)setLoop:(BOOL)loop {
    mLoop = loop;
}

@synthesize speed = mSpeed;

- (BOOL)isPlaying {
    return mPlaying;
}

- (void)setPlaying:(BOOL)playing {
    if (playing) {
        [self play];
    } else {
        [self pause];
    }
}

- (void)play {
    mDirection = JWAnimationPlayDirectionForward;
    if (mPlaying) {
        return;
    }
    mPlaying = YES;
    [mListener onPlayAnimation:self];
}

- (void)rollback {
    mDirection = JWAnimationPlayDirectionBackward;
    if (mPlaying) {
        return;
    }
    mPlaying = YES;
    [mListener onPlayAnimation:self];
}

- (void)pause {
    mPlaying = NO;
    [mListener onPauseAnimation:self];
}

- (void)stop {
    [self stopImpl];
}

- (void) stopImpl {
    mTime = 0;
    mPlaying = NO;
    [mListener onStopAnimation:self];
}

- (NSInteger)time {
    return mTime;
}

- (void)setTime:(NSInteger)time {
    [self setTime:time animated:NO];
}

- (void)addTime:(NSInteger)deltaTimePosition animated:(BOOL)animated {
    [self setTime:(mTime + deltaTimePosition) animated:animated];
}

- (void)setTime:(NSInteger)timePosition animated:(BOOL)animated {
    mAnimated = animated;
    if (mAnimated) {
        mAnimTime = timePosition;
        if (timePosition > mTime) {
            [self play];
        } else if (timePosition < mTime) {
            [self rollback];
        }
        return;
    }
    [self setTimeImpl:timePosition];
}

- (BOOL) setTimeImpl:(NSInteger)timePosition {
    BOOL willStop = NO;
    if (mResource == nil) {
        return willStop;
    }
    
    if (mLoop) {
        if (timePosition > mLength) {
            timePosition %= mLength;
        } else if (timePosition < 0) {
            timePosition = mLength - ((-timePosition) % mLength);
        }
    } else {
        if (timePosition > mLength) {
            timePosition = mLength;
            willStop = YES;
        } else if (timePosition < 0) {
            timePosition = 0;
            willStop = YES;
        }
    }
    [mResource enumTrackUsing:^(JWAnimationTrack *track, NSUInteger idx, BOOL *stop) {
        JCAnimationFrame frame = [track getInterpolationFrameByTimePosition:timePosition];
        if (JCAnimationFrameIsInvalid(&frame)) {
            return;
        }
        id<JIGameObject> targetObject = track.targetObject;
        id<JITransform> transform = nil;
        if (targetObject == nil) {
            transform = self.transform;
        } else {
            transform = targetObject.transform;
        }
        if (JCFlagsTest(track.type, JCAnimationTypeTransform)) {
            JWTransform* t = transform;
            [t _setTransform:&frame.transform inWorld:NO];
        } else {
            if (JCFlagsTest(track.type, JCAnimationTypeTranslate)) {
                [transform setPosition:frame.transform.position inSpace:JWTransformSpaceParent];
            }
            if (JCFlagsTest(track.type, JCAnimationTypeRotate)) {
                [transform setOrientation:frame.transform.orientation inSpace:JWTransformSpaceLocal];
            } else if (JCFlagsTest(track.type, JCAnimationTypeEulerAngles)) {
                [transform setEulerAngles:frame.eulerAngles inSpace:JWTransformSpaceLocal];
            }
            if (JCFlagsTest(track.type, JCAnimationTypeScale)) {
                [transform setScale:frame.transform.scale];
            }
        }
    }];
    mTime = timePosition;
    return willStop;
}

- (id<JIAnimationResource>)resource {
    return mResource;
}

- (void)setResource:(id<JIAnimationResource>)resource {
    if (mResource == resource) {
        return;
    }
    mResource = resource;
    if (mResource == nil) {
        return;
    }
    [self setResourceParams];
}

- (void) setResourceParams {
    //mLength = mResource.track->duration;
    if (mLength == 0) {
        [mResource enumTrackUsing:^(JWAnimationTrack *track, NSUInteger idx, BOOL *stop) {
            mLength += track.duration;
        }];
    }
}

@synthesize listener = mListener;

- (id<JIComponent>)copyInstance {
    JWAnimation* animation = [mContext createAnimation];
    animation.resource = mResource;
    animation.length = mLength;
    animation.loop = mLoop;
    animation.speed = mSpeed;
    return animation;
}

@end
