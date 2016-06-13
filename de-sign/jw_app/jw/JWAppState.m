//
//  JWAppState.m
//  June Winter
//
//  Created by GavinLo on 14-2-13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAppState.h"
#import "JWAppStateMachine.h"
#import "JWCoreUtils.h"

@interface JWAppState ()
{
    UIView* mView;
    BOOL mViewOk;
    BOOL mOnCreated;
    JWViewEventBinder* mViewEventBinder;
    JWGestureEventBinder* mGestureEventBinder;
}

@end

@implementation JWAppState

- (void)onDestroy
{
    [JWCoreUtils destroyObject:mViewEventBinder];
    mViewEventBinder = nil;
    [JWCoreUtils destroyObject:mGestureEventBinder];
    mGestureEventBinder = nil;
    [super onDestroy];
}

- (JWViewEventBinder *)viewEventBinder
{
    if(mViewEventBinder == nil)
        mViewEventBinder = [[JWViewEventBinder alloc] initWithEvents:self];
    return mViewEventBinder;
}

- (JWGestureEventBinder *)gestureEventBinder
{
    if(mGestureEventBinder == nil)
        mGestureEventBinder = [[JWGestureEventBinder alloc] initWithEvents:self];
    return mGestureEventBinder;
}

- (UIView *)onCreateView:(UIView *)parent
{
    return nil;
}

- (void)onCreated {
    
}

- (UIView *)view
{
    return mView;
}

- (void)onStateEnter:(NSDictionary *)data
{
    [super onStateEnter:data];
    if(!mViewOk)
    {
        UIView* parentView = nil;
        id<JIState> parentState = self.parentState;
        if(parentState != nil && [parentState conformsToProtocol:@protocol(JIAppState)])
        {
            id<JIAppState> parentAppState = (id<JIAppState>)parentState;
            parentView = parentAppState.view;
        }
        mView = [self onCreateView:parentView];
        mViewOk = YES;
        if (!mOnCreated) {
            [self onCreated];
            mOnCreated = YES;
        }
    }
}

- (BOOL)onTouchDown:(NSSet *)touches withEvent:(UIEvent *)event
{
    return NO;
}

- (BOOL)onTouchMove:(NSSet *)touches withEvent:(UIEvent *)event
{
    return NO;
}

- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event
{
    return NO;
}

- (BOOL)onTouchCancel:(NSSet *)touches withEvent:(UIEvent *)event
{
    return NO;
}

- (void)onPinch:(UIPinchGestureRecognizer *)pinch
{
    
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap
{
    
}

- (void)onDoubleTap:(UITapGestureRecognizer *)doubleTap
{
    
}

- (void)onDoubleDrag:(UIPanGestureRecognizer *)doubleDrag {
    
}

- (void)onLongPress:(UILongPressGestureRecognizer *)longPress {
    
}

- (id<JIStateMachine>)subMachine
{
    if(mSubMachine == nil)
    {
        JWAppStateMachine* subMachine = [JWAppStateMachine machineWithName:nil andState:self];
        mSubMachine = subMachine;
    }
    return mSubMachine;
}

@end
