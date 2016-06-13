//
//  JWCameraPrefabDefaultBehaviour.m
//  June Winter
//
//  Created by GavinLo on 14/11/12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWCameraPrefabDefaultBehaviour.h"
#import "JWCameraPrefab.h"
#import "UITouch+JWAppCategory.h"
#import <jw/UIPanGestureRecognizer+JWAppCategory.h>

@interface JWCameraPrefabDefaultBehaviour () {
    CGPoint mLastDoubleDragPositionInPixels;
}

@end

@implementation JWCameraPrefabDefaultBehaviour

- (id)initWithContext:(id<JIGameContext>)context cameraPrefab:(id<JICameraPrefab>)cameraPrefab {
    self = [super initWithContext:context];
    if (self != nil) {
        mCameraPrefab = cameraPrefab;
    }
    return self;
}

- (BOOL)onScreenTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    return YES;
}

- (BOOL)onScreenTouchMove:(NSSet *)touches withEvent:(UIEvent *)event {
    if (touches.count > 1) {
        return NO;
    }
    UITouch* touch = [touches anyObject];
    CGPoint dp = touch.deltaPositionInPixels;
    [mCameraPrefab move1dx:-dp.x dy:-dp.y];
    return YES;
}

- (void)onDoubleDrag:(UIPanGestureRecognizer *)doubleDrag {
    switch (doubleDrag.state) {
        case UIGestureRecognizerStateBegan: {
            mLastDoubleDragPositionInPixels = doubleDrag.positionInPixels;
            break;
        }
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded: {
            CGPoint currentDoubleDragPositionInPixels = doubleDrag.positionInPixels;
            CGPoint dp = CGPointMake(currentDoubleDragPositionInPixels.x - mLastDoubleDragPositionInPixels.x, currentDoubleDragPositionInPixels.y - mLastDoubleDragPositionInPixels.y);
            [mCameraPrefab move2dx:-dp.x dy:-dp.y];
            mLastDoubleDragPositionInPixels = currentDoubleDragPositionInPixels;
            break;
        }
        default: {
            break;
        }
    }
}

- (void)onPinch:(UIPinchGestureRecognizer *)pinch {
    [mCameraPrefab scaleS:-(pinch.scale - 1.0f)];
    pinch.scale = 1.0f;
}

@end
