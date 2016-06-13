//
//  JWState.h
//  June Winter
//
//  Created by GavinLo on 14-2-12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>

/**
 * 状态接口
 */
@protocol JIState <JIObject>

/**
 * 前置条件,不满足则返回NO
 */
- (BOOL) onPreCondition;

/**
 * 状态进入时调用
 * @param data 传输给状态的数据
 */
- (void) onStateEnter:(NSDictionary*)data;

/**
 * 状态离开时调用
 */
- (void) onStateLeave;

/**
 * 状态恢复时调用
 */
- (void) onStateResume;

/**
 * 状态暂停时调用
 */
- (void) onStatePause;

/**
 * 接受消息
 */
- (void) onStateMessage:(id<JIStateMessage>)message;

/**
 * 对象所属的状态机
 */
@property (nonatomic, readonly) id<JIStateMachine> parentMachine;

/**
 * 父状态(对象所属的状态机同时为一个状态时返回)
 */
@property (nonatomic, readonly) id<JIState> parentState;

/**
 * 状态同时也可以是一个状态机
 */
@property (nonatomic, readonly) id<JIStateMachine> subMachine;

/**
 * 发送消息给父状态
 */
- (void) sendMessage:(id<JIStateMessage>)message;

@end

/**
 * 状态类
 */
@interface JWState : JWObject <JIState> {
    id<JIStateMachine> mParentMachine;
    id<JIStateMachine> mSubMachine;
}

+ (id) state;

- (void) notifyParent:(id<JIStateMachine>)parentMachine;

@end
