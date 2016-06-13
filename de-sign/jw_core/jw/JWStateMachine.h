//
//  JWStateMachine.h
//  June Winter
//
//  Created by GavinLo on 14-2-13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWState.h>
#import <jw/JWStateMessage.h>
#import <jw/NSMutableArray+JWArrayList.h>

/**
 * 状态机接口
 */
@protocol JIStateMachine <JIObject>

/**
 * 添加状态
 */
- (BOOL) addState:(id<JIState>)state withName:(NSString*)name;

/**
 * 移除状态
 */
- (id<JIState>) removeStateByName:(NSString*)name;

/**
 * 获取状态
 */
- (id<JIState>) getStateByName:(NSString*)name;

/**
 * 获取状态名字
 */
- (NSString*) getNameOfState:(id<JIState>)state;

/**
 * 状态个数
 */
@property (nonatomic, readonly) NSUInteger stateCount;

/**
 * 设置初始状态,不调用状态的onStateEnter方法
 */
- (BOOL) setInitStateWith:(NSString*)name;

/**
 * 当前状态
 */
@property (nonatomic, readonly) id<JIState> currentState;

/**
 * 历史状态列表
 */
@property (nonatomic, readonly) NSArray* history;

/**
 * 正向状态切换
 * @param name 目标状态名字
 * @param data 传递给该状态的数据
 * @param pushState 是否将状态压栈(放置到历史队列中)
 */
- (BOOL) changeStateTo:(NSString*)name passData:(NSDictionary*)data pushState:(BOOL)pushState;

/**
 * 正向状态切换
 * @param name 目标状态名字
 * @param pushState 是否将状态压栈(放置到历史队列中)
 */
- (BOOL) changeStateTo:(NSString*)name pushState:(BOOL)pushState;

/**
 * 正向状态切换
 * @param name 目标状态名字
 */
- (BOOL) changeStateTo:(NSString*)name;

/**
 * 反向状态切换(切换到历史堆栈顶的状态)
 * @param step 步数
 * @param pushState 是否将状态压栈(放置到历史队列中)
 */
- (BOOL) revertStateStep:(NSUInteger)step pushState:(BOOL)pushState;

/**
 * 反向状态切换(切换到历史堆栈顶的状态)
 * @param step 步数
 */
- (BOOL) revertStateStep:(NSUInteger)step;

/**
 * 反向状态切换(切换到历史堆栈顶的状态)
 * @param pushState 是否将状态压栈(放置到历史队列中)
 */
- (BOOL) revertState:(BOOL)pushState;

/**
 * 反向状态切换(切换到历史堆栈顶的状态)
 */
- (BOOL) revertState;

/**
 * 发送消息给当前状态
 */
- (void) sendMessage:(id<JIStateMessage>)message;

/**
 * 若返回非null,表示这个状态机同时也是个状态
 */
@property (nonatomic, readonly) id<JIState> state;

@end

/**
 * 状态机类
 */
@interface JWStateMachine : JWObject <JIStateMachine>
{
    NSString* mName;
    NSMutableDictionary* mStates;
    id<JIState> mCurrentState;
    NSMutableArray* mStateStack;
    id<JIState> mState;
}

@property (nonatomic, readonly) NSMutableDictionary* states;
@property (nonatomic, readonly) NSMutableArray* stateStack;

+ (id) machineWithName:(NSString*)name;
+ (id) machineWithName:(NSString*)name andState:(id<JIState>)state;
- (id) initWithName:(NSString*)name;
- (id) initWithName:(NSString*)name andState:(id<JIState>)state;

- (NSString*) getClassNameFrom:(id<JIState>)state;

@end
