//
//  JWEventQueue.h
//  June Winter
//
//  Created by GavinLo on 14/10/23.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>

typedef void (^JWQueueEventOnDoEventBlock)();
typedef void (^JWQueueEventOnCancelEventBlock)();

@protocol JIQueueEvent <JIObject>

- (void) onDoEvent;
- (void) onCancelEvent;

@end

@interface JWQueueEvent : JWObject <JIQueueEvent>

@property (nonatomic, readwrite) JWQueueEventOnDoEventBlock onDo;
@property (nonatomic, readwrite) JWQueueEventOnCancelEventBlock onCancel;

@end

//@protocol JIEventQueue <JIObject, NSFastEnumeration>
@protocol JIEventQueue <JIObject>

/**
 * 将一个事件放置到队列尾部
 */
- (void) queueEvent:(id<JIQueueEvent>)event;

/**
 * 将一个事件从队列中移除
 */
- (void) unqueueEvent:(id<JIQueueEvent>)event;

/**
 * 取消队列中一个未处理的事件
 */
- (void) cancelEvent:(id<JIQueueEvent>)event;

/**
 * 消费一个事件(从队列头弹出一个事件并处理,完毕后销毁)
 */
- (BOOL) consumeEvent;

/**
 * 消费一个指定类型的事件(从队列头弹出一个事件，若该事件与类型匹配则处理并销毁，否则重新添加到队列尾)
 */
- (BOOL) consumeEventWithType:(Class)type;

@property (nonatomic, readonly) BOOL isEmpty;

- (void) enumEventsUsing:(void (^)(id<JIQueueEvent> event, NSUInteger idx, BOOL* stop))block;

@end

@interface JWEventQueue : JWObject <JIEventQueue>

+ (id) queue;

@end
