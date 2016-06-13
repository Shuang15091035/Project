//
//  JWAnimationTrack.h
//  June Winter_game
//
//  Created by ddeyes on 16/2/25.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWObject.h>
#import <jw/JCAnimation.h>

@interface JWAnimationTrack : JWObject

+ (id) trackWithTarget:(id)target type:(JCAnimationType)type duration:(NSUInteger)duration loop:(BOOL)loop;
+ (id) trackWithType:(JCAnimationType)type duration:(NSUInteger)duration loop:(BOOL)loop;
- (id) initWithTarget:(id)target type:(JCAnimationType)type duration:(NSUInteger)duration loop:(BOOL)loop;
- (id) initWithType:(JCAnimationType)type duration:(NSUInteger)duration loop:(BOOL)loop;

@property (nonatomic, readwrite) id target;
@property (nonatomic, readonly) id<JIGameObject> targetObject;
@property (nonatomic, readwrite) JCAnimationType type;
@property (nonatomic, readwrite) NSUInteger duration;
@property (nonatomic, readwrite, getter=isLoop) BOOL loop;
@property (nonatomic, readwrite) JCAnimationInterpolationFunc interpolationFunc;

- (JCAnimationFrameRef) addKeyFrame:(JCAnimationFrame)frame;
- (JCAnimationFrameRef) keyFrameAtIndex:(NSUInteger)index;
- (JCAnimationFrameRef) keyFrameAtTimePosition:(NSInteger)timePosition;
- (JCAnimationFrame) getInterpolationFrameByTimePosition:(NSInteger)timePosition;
- (BOOL) hasTheSameTypeWithTarget:(id)target type:(JCAnimationType)type;

@end
