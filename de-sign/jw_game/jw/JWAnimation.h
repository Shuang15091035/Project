//
//  JWAnimation.h
//  June Winter
//
//  Created by GavinLo on 14/12/23.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWComponent.h>

typedef NS_ENUM(BOOL, JWAnimationPlayDirection) {
    JWAnimationPlayDirectionForward = YES,
    JWAnimationPlayDirectionBackward = NO,
};

typedef void (^JWAnimationOnPlayBlock)(id<JIAnimation> animation);
typedef void (^JWAnimationOnPauseBlock)(id<JIAnimation> animation);
typedef void (^JWAnimationOnStopBlock)(id<JIAnimation> animation);
typedef void (^JWAnimationOnLoopBlock)(id<JIAnimation> animation);

@protocol JIAnimationListener <NSObject>

- (void) onPlayAnimation:(id<JIAnimation>)animation;
- (void) onPauseAnimation:(id<JIAnimation>)animation;
- (void) onStopAnimation:(id<JIAnimation>)animation;
- (void) onLoopAnimation:(id<JIAnimation>)animation;

@end

@interface JWAnimationListener : NSObject <JIAnimationListener>

@property (nonatomic, readwrite) JWAnimationOnPlayBlock onPlay;
@property (nonatomic, readwrite) JWAnimationOnPauseBlock onPause;
@property (nonatomic, readwrite) JWAnimationOnStopBlock onStop;
@property (nonatomic, readwrite) JWAnimationOnLoopBlock onLoop;

@end

@protocol JIAnimation <JIComponent>

@property (nonatomic, readwrite) NSInteger length;
@property (nonatomic, readwrite, getter=isLoop) BOOL loop;
@property (nonatomic, readwrite) float speed;

@property (nonatomic, readwrite, getter=isPlaying) BOOL playing;
- (void) play;
- (void) pause;
- (void) rollback;
- (void) stop;

@property (nonatomic, readwrite) NSInteger time;
- (void) addTime:(NSInteger)deltaTimePosition animated:(BOOL)animated;
- (void) setTime:(NSInteger)timePosition animated:(BOOL)animated;

@property (nonatomic, readwrite) id<JIAnimationResource> resource;
@property (nonatomic, readwrite) id<JIAnimationListener> listener;

@end

@interface JWAnimation : JWComponent <JIAnimation>

@end
