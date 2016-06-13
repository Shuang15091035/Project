//
//  JWStateMachine.m
//  June Winter
//
//  Created by GavinLo on 14-2-13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWStateMachine.h"
#import "JWCoreUtils.h"
#import "JWState.h"

@interface JWStateMachine ()

@end

@implementation JWStateMachine

+ (id)machineWithName:(NSString *)name {
    return [[self alloc] initWithName:name];
}

+ (id)machineWithName:(NSString *)name andState:(id<JIState>)state {
    return [[self alloc] initWithName:name andState:state];
}

- (id)initWithName:(NSString *)name {
    return [self initWithName:name andState:nil];
}

- (id)initWithName:(NSString *)name andState:(id<JIState>)state {
    self = [super init];
    if (self != nil) {
        mName = name;
        mState = state;
    }
    return self;
}

- (void)onCreate {
    [super onCreate];
}

- (void)onDestroy {
    [super onDestroy];
    
    [mStateStack clear];
    mStateStack = nil;
    
    [JWCoreUtils destroyDict:mStates];
    mStates = nil;
    mState = nil;
}

- (NSMutableDictionary *)states {
    if (mStates == nil) {
        mStates = [[NSMutableDictionary alloc] init];
    }
    return mStates;
}

- (NSMutableArray *)stateStack {
    if (mStateStack == nil) {
        mStateStack = [NSMutableArray array];
    }
    return mStateStack;
}

- (BOOL)addState:(id<JIState>)state withName:(NSString *)name {
    NSMutableDictionary* states = self.states;
    id<JIState> oldState = [mStates objectForKey:name];
    if (oldState != nil) {
        return NO;
    }
    [states setValue:state forKey:name];
    if ([state isKindOfClass:[JWState class]]) {
        JWState* cs = (JWState*)state;
        [cs notifyParent:self];
    }
    NSLog(@"add state[%@].", [self getClassNameFrom:state]);
    return TRUE;
}

- (id<JIState>)removeStateByName:(NSString *)name {
    NSMutableDictionary* states = self.states;
    id<JIState> state = [states objectForKey:name];
    if (state == nil) {
        return nil;
    }
    if (mCurrentState == state) {
        mCurrentState = nil;
    }
    if ([state isKindOfClass:[JWState class]]) {
        JWState* cs = (JWState*)state;
        [cs notifyParent:nil];
    }
    NSLog(@"remove state[%@].", [self getClassNameFrom:state]);
    return state;
}

- (id<JIState>)getStateByName:(NSString *)name {
    NSMutableDictionary* states = self.states;
    id<JIState> state = [states objectForKey:name];
    return state;
}

- (NSString *)getNameOfState:(id<JIState>)state {
    NSMutableDictionary* states = self.states;
    for (NSString* name in states) {
        id<JIState> s = [states objectForKey:name];
        if (state == s) {
            return name;
        }
    }
    return nil;
}

- (NSUInteger)stateCount {
    return self.states.count;
}

- (BOOL)setInitStateWith:(NSString *)name {
    mCurrentState = [self getStateByName:name];
    unsigned long hash = (unsigned long)self.hash;
    NSLog(@"FSM[%ld] set init state %@.", hash, [self getClassNameFrom:mCurrentState]);
    return YES;
}

- (id<JIState>)currentState {
    return mCurrentState;
}

- (NSArray *)history {
    return self.stateStack;
}

- (BOOL)changeStateTo:(NSString *)name passData:(NSDictionary *)data pushState:(BOOL)pushState {
    NSMutableDictionary* states = self.states;
    if (states.count == 0) {
        return NO;
    }
    id<JIState> from = mCurrentState;
    id<JIState> to = [states objectForKey:name];
    if (to == nil) {
        unsigned long hash = (unsigned long)self.hash;
        NSLog(@"FSM[%ld] there is no such state Named \"%@\", Please Add One.", hash, [self getClassNameFrom:to]);
        return NO;
    }
    return [self changeStateImpl:from to:to passData:data pushState:pushState];
}

- (BOOL)changeStateTo:(NSString *)name pushState:(BOOL)pushState {
    return [self changeStateTo:name passData:nil pushState:pushState];
}

- (BOOL)changeStateTo:(NSString *)name {
    return [self changeStateTo:name passData:nil pushState:YES];
}

- (BOOL)revertStateStep:(NSUInteger)step pushState:(BOOL)pushState {
    return [self revertStateImpl:step passData:nil pushState:pushState];
}

- (BOOL)revertStateStep:(NSUInteger)step {
    return [self revertStateImpl:step passData:nil pushState:NO];
}

- (BOOL)revertState:(BOOL)pushState {
    return [self revertStateImpl:1 passData:nil pushState:pushState];
}

- (BOOL)revertState {
    return [self revertState:NO];
}

- (void)sendMessage:(id<JIStateMessage>)message {
    id<JIState> currentState = self.currentState;
    [currentState onStateMessage:message];
}

- (id<JIState>)state {
    return mState;
}

- (BOOL)changeStateImpl:(id<JIState>)from to:(id<JIState>)to passData:(NSDictionary*)data pushState:(BOOL)pushState {
    if (from == to) {
        return NO;
    }
    
    unsigned long hash = (unsigned long)self.hash;
    if (to != nil && ![to onPreCondition]) { // 检查前置条件
        NSLog(@"FSM[%ld] pre-condition failed on %@, stay in %@.", hash, [self getClassNameFrom:to], [self getClassNameFrom:from]);
        return NO;
    }
    
    if (from != nil) {
        // TODO 暂时只处理主子状态机
        // 暂停子状态机中的当前状态
        id<JIStateMachine> subMachine = from.subMachine;
        if (subMachine != nil) {
            id<JIState> state = subMachine.currentState;
            [state onStatePause];
        }
        [from onStatePause];
        [from onStateLeave];
    }
    if (pushState) { // 允许返回nil状态
        [self.stateStack add:from];
    }
    mCurrentState = to;
    if (to != nil) {
        [to onStateEnter:data];
        [to onStateResume];
        // 唤醒子状态机中的当前状态
        id<JIStateMachine> subMachine = to.subMachine;
        if (subMachine != nil) {
            id<JIState> state = subMachine.currentState;
            [state onStateResume];
        }
    }
    
    NSLog(@"FSM[%ld] change state from %@ to %@.", hash, [self getClassNameFrom:from], [self getClassNameFrom:to]);
    return true;
}

- (BOOL)revertStateImpl:(int)step passData:(NSDictionary*)data pushState:(BOOL)pushState {
    NSMutableArray* stateStack = self.stateStack;
    if (stateStack.count == 0) {
        return NO;
    }
    
    id<JIState> from = mCurrentState;
    id<JIState> to = nil;
    int i = 0;
    while(i < step) {
        to = [stateStack at:(stateStack.count - 1)];
        [stateStack removeLastObject];
        i++;
    }
    return [self changeStateImpl:from to:to passData:data pushState:pushState];
}

- (NSString *)getClassNameFrom:(id<JIState>)state {
    if (state == nil) {
        return @"null";
    }
    return NSStringFromClass([state class]);
}

@end
