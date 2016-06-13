//
//  JWState.m
//  June Winter
//
//  Created by GavinLo on 14-2-12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWState.h"
#import "JWStateMachine.h"

@implementation JWState

+ (id)state {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        [self onCreate];
    }
    return self;
}

- (BOOL)onPreCondition
{
    return YES;
}

- (void)onStateEnter:(NSDictionary *)data
{
    
}

- (void)onStateLeave
{
    
}

- (void)onStateResume
{
    
}

- (void)onStatePause
{
    
}

- (void)onStateMessage:(id<JIStateMessage>)message
{
    
}

- (id<JIStateMachine>)parentMachine
{
    return mParentMachine;
}

- (id<JIState>)parentState
{
    if(mParentMachine == nil)
        return nil;
    return mParentMachine.state;
}

- (void)notifyParent:(id<JIStateMachine>)parentMachine
{
    mParentMachine = parentMachine;
}

- (id<JIStateMachine>)subMachine
{
    if(mSubMachine == nil)
    {
        JWStateMachine* subMachine = [JWStateMachine machineWithName:nil andState:self];
        mSubMachine = subMachine;
    }
    return mSubMachine;
}

- (void)sendMessage:(id<JIStateMessage>)message
{
    if(mParentMachine.state != nil)
        [mParentMachine.state onStateMessage:message];
}

@end
