//
//  JWBehaviour.m
//  June Winter
//
//  Created by GavinLo on 14/10/29.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWBehaviour.h"
#import "UITouch+JWAppCategory.h"
#import "JCMath.h"

@interface JWBehaviour ()
{
    JWOnTouchEventBlock mOnScreenTouchDown;
    JWOnTouchEventBlock mOnScreenTouchMove;
    JWOnTouchEventBlock mOnScreenTouchUp;
    JWOnTouchEventBlock mOnScreenTouchCancel;
    JWOnTouchEventBlock mOnScreenClick;
    JWOnTouchEventBlock mOnTouchDown;
    JWOnTouchEventBlock mOnTouchMove;
    JWOnTouchEventBlock mOnTouchUp;
    JWOnTouchEventBlock mOnTouchCancel;
    JWOnPinchBlock mOnPinch;
    JWOnSingleTapBlock mOnSingleTap;
    JWOnDoubleTapBlock mOnDoubleTap;
    JWOnDoubleDragBlock mOnDoubleDrag;
    JWOnLongPressBlock mOnLongPress;
    JWOnUpdateBlock mOnUpdate;
    JWOnGamepadBlock mOnGamepad;
    
    BOOL mScreenTouchDown;
    CGPoint mScreenTouchDownPoint;
    float mScreenClickDistance;
}

@end

@implementation JWBehaviour

+ (id)behaviourWithContext:(id<JIGameContext>)context {
    return [[self alloc] initWithContext:context];
}

- (id)initWithContext:(id<JIGameContext>)context {
    self = [super initWithContext:context];
    if (self != nil) {
        mScreenClickDistance = 10.0f;
    }
    return self;
}

- (void)onComponentUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime {
    [super onComponentUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
    [self onBehaviourUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
}

- (BOOL)onScreenTouchDown:(NSSet *)touches withEvent:(UIEvent *)event {
    mScreenTouchDown = YES;
    mScreenTouchDownPoint = [UITouch getFocusPositionInPixelsByTouches:touches];
    if (mOnScreenTouchDown != nil) {
        return mOnScreenTouchDown(touches, event);
    }
    return NO;
}

- (BOOL)onScreenTouchMove:(NSSet *)touches withEvent:(UIEvent *)event {
    if (mOnScreenTouchMove != nil) {
        return mOnScreenTouchMove(touches, event);
    }
    return NO;
}

- (BOOL)onScreenTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    if (mScreenTouchDown) {
        CGPoint sp = [UITouch getFocusPositionInPixelsByTouches:touches];
        if (JCManhattanDistance(mScreenTouchDownPoint.x, mScreenTouchDownPoint.y, sp.x, sp.y) < mScreenClickDistance) {
            [self onScreenClick:touches withEvent:event];
        }
        mScreenTouchDown = NO;
        mScreenTouchDownPoint = CGPointZero;
    }
    if (mOnScreenTouchUp != nil) {
        return mOnScreenTouchUp(touches, event);
    }
    return NO;
}

- (BOOL)onScreenTouchCancel:(NSSet *)touches withEvent:(UIEvent *)event {
    if(mOnScreenTouchCancel != nil) {
        return mOnScreenTouchCancel(touches, event);
    }
    return NO;
}

- (BOOL)onScreenClick:(NSSet *)touches withEvent:(UIEvent *)event {
    if (mOnScreenClick != nil) {
        return mOnScreenClick(touches, event);
    }
    return NO;
}

- (BOOL)onTouchDown:(NSSet *)touches withEvent:(UIEvent *)event {
    if (mOnTouchDown != nil) {
        return mOnTouchDown(touches, event);
    }
    return NO;
}

- (BOOL)onTouchMove:(NSSet *)touches withEvent:(UIEvent *)event {
    if (mOnTouchMove != nil) {
        return mOnTouchMove(touches, event);
    }
    return NO;
}

- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    if (mOnTouchUp != nil) {
        return mOnTouchUp(touches, event);
    }
    return NO;
}

- (BOOL)onTouchCancel:(NSSet *)touches withEvent:(UIEvent *)event {
    if (mOnTouchCancel != nil) {
        return mOnTouchCancel(touches, event);
    }
    return NO;
}

- (void)onPinch:(UIPinchGestureRecognizer *)pinch {
    if (mOnPinch != nil) {
        mOnPinch(pinch);
    }
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap {
    if (mOnSingleTap != nil) {
        mOnSingleTap(singleTap);
    }
}

- (void)onDoubleTap:(UITapGestureRecognizer *)doubleTap {
    if (mOnDoubleTap != nil) {
        mOnDoubleTap(doubleTap);
    }
}

- (void)onDoubleDrag:(UIPanGestureRecognizer *)doubleDrag {
    if (mOnDoubleDrag != nil) {
        mOnDoubleDrag(doubleDrag);
    }
}

- (void)onLongPress:(UILongPressGestureRecognizer *)longPress {
    if (mOnLongPress != nil) {
        mOnLongPress(longPress);
    }
}

- (void)onBehaviourUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime {
    if (mOnUpdate != nil) {
        mOnUpdate(totalTime, elapsedTime);
    }
}

- (void)onGamepad:(id<JIGamepad>)gamepad {
    if (mOnGamepad != nil) {
        mOnGamepad(gamepad);
    }
}

- (JWOnTouchEventBlock)onScreenTouchDown {
    return mOnScreenTouchDown;
}

- (void)setOnScreenTouchDown:(JWOnTouchEventBlock)onScreenTouchDown {
    mOnScreenTouchDown = onScreenTouchDown;
}

- (JWOnTouchEventBlock)onScreenTouchMove {
    return mOnScreenTouchMove;
}

- (void)setOnScreenTouchMove:(JWOnTouchEventBlock)onScreenTouchMove {
    mOnScreenTouchMove = onScreenTouchMove;
}

- (JWOnTouchEventBlock)onScreenTouchUp {
    return mOnScreenTouchUp;
}

- (void)setOnScreenTouchUp:(JWOnTouchEventBlock)onScreenTouchUp {
    mOnScreenTouchUp = onScreenTouchUp;
}

- (JWOnTouchEventBlock)onScreenTouchCancel {
    return mOnScreenTouchCancel;
}

- (void)setOnScreenTouchCancel:(JWOnTouchEventBlock)onScreenTouchCancel {
    mOnScreenTouchCancel = onScreenTouchCancel;
}

- (JWOnTouchEventBlock)onTouchDown {
    return mOnTouchDown;
}

- (void)setOnTouchDown:(JWOnTouchEventBlock)onTouchDown {
    mOnTouchDown = onTouchDown;
}

- (JWOnTouchEventBlock)onTouchMove {
    return mOnTouchMove;
}

- (void)setOnTouchMove:(JWOnTouchEventBlock)onTouchMove {
    mOnTouchMove = onTouchMove;
}

- (JWOnTouchEventBlock)onTouchUp {
    return mOnTouchUp;
}

- (void)setOnTouchUp:(JWOnTouchEventBlock)onTouchUp {
    mOnTouchUp = onTouchUp;
}

- (JWOnTouchEventBlock)onTouchCancel {
    return mOnTouchCancel;
}

-  (void)setOnTouchCancel:(JWOnTouchEventBlock)onTouchCancel {
    mOnTouchCancel = onTouchCancel;
}

- (JWOnTouchEventBlock)onScreenClick {
    return mOnScreenClick;
}

- (void)setOnScreenClick:(JWOnTouchEventBlock)onScreenClick {
    mOnScreenClick = onScreenClick;
}

- (JWOnPinchBlock)onPinch {
    return mOnPinch;
}

- (void)setOnPinch:(JWOnPinchBlock)onPinch {
    mOnPinch = onPinch;
}

- (JWOnSingleTapBlock)onSingleTap {
    return mOnSingleTap;
}

- (void)setOnSingleTap:(JWOnSingleTapBlock)onSingleTap {
    mOnSingleTap = onSingleTap;
}

- (JWOnDoubleTapBlock)onDoubleTap {
    return mOnDoubleTap;
}

- (void)setOnDoubleTap:(JWOnDoubleTapBlock)onDoubleTap {
    mOnDoubleTap = onDoubleTap;
}

- (void)setOnDoubleDrag:(JWOnDoubleDragBlock)onDoubleDrag {
    mOnDoubleDrag = onDoubleDrag;
}

- (JWOnDoubleDragBlock)onDoubleDrag {
    return mOnDoubleDrag;
}

- (JWOnLongPressBlock)onLongPress {
    return mOnLongPress;
}

- (void)setOnLongPress:(JWOnLongPressBlock)onLongPress {
    mOnLongPress = onLongPress;
}

- (JWOnUpdateBlock)onUpdate {
    return mOnUpdate;
}

- (void)setOnUpdate:(JWOnUpdateBlock)onUpdate {
    mOnUpdate = onUpdate;
}

- (JWOnGamepadBlock)onGamepad {
    return mOnGamepad;
}

- (void)setOnGamepad:(JWOnGamepadBlock)onGamepad {
    mOnGamepad = onGamepad;
}

@end
