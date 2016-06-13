//
//  JWEventQueue.m
//  June Winter
//
//  Created by GavinLo on 14/10/23.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWEventQueue.h"
#import "NSMutableArray+JWArrayList.h"
#import "JWCoreUtils.h"
#import "JWNode.h"

@interface JWQueueEvent () {
    JWQueueEventOnDoEventBlock mOnDo;
    JWQueueEventOnCancelEventBlock mOnCancel;
}

@end

@implementation JWQueueEvent

- (void)onCreate {
    [super onCreate];
}

- (void)onDestroy {
    [super onDestroy];
}

- (JWQueueEventOnDoEventBlock)onDo {
    return mOnDo;
}

- (void)setOnDo:(JWQueueEventOnDoEventBlock)onDo {
    mOnDo = onDo;
}

- (JWQueueEventOnCancelEventBlock)onCancel {
    return mOnCancel;
}

- (void)setOnCancel:(JWQueueEventOnCancelEventBlock)onCancel {
    mOnCancel = onCancel;
}

- (void)onDoEvent {
    if (mOnDo != nil) {
        mOnDo();
    }
}

- (void)onCancelEvent {
    if (mOnCancel != nil) {
        mOnCancel();
    }
}

@end

@interface JWQueueEventNode : JWNode {
    id<JIQueueEvent> mEvent; // NOTE 支持无锁的多线程迭代过程中增删操作
}

- (id) initWithEvent:(id<JIQueueEvent>)event;
@property (nonatomic, readwrite) id<JIQueueEvent> event;

@end

@implementation JWQueueEventNode

- (id)initWithEvent:(id<JIQueueEvent>)event {
    self = [super init];
    if (self != nil) {
        mEvent = event;
    }
    return self;
}

- (void)onDestroy {
    [JWCoreUtils destroyObject:mEvent];
    mEvent = nil;
    [super onDestroy];
}

@synthesize event = mEvent;

- (BOOL)equals:(id<JINode>)other {
    if (other == nil) {
        return NO;
    }
    JWQueueEventNode* on = (JWQueueEventNode*)other;
    return mEvent == on.event;
}

@end

//#pragma mark JWQueueEventComparator
//static NSComparisonResult (^JWQueueEventComparator)(id, id) = ^(id obj1, id obj2) {
//    JWQueueEventNode* ln = (JWQueueEventNode*)obj1;
//    JWQueueEventNode* rn = (JWQueueEventNode*)obj2;
//    id<JIQueueEvent> le = ln.event;
//    id<JIQueueEvent> re = rn.event;
//    if (le == re) {
//        return NSOrderedSame;
//    }
//    return le.hash < re.hash ? NSOrderedAscending : NSOrderedDescending;
//};

@interface JWEventQueue () {
    id<JINode> mQueueRoot;
}

@property (nonatomic, readonly) NSMutableArray* queue;

@end

@implementation JWEventQueue

+ (id)queue {
    return [[JWEventQueue alloc] init];
}

- (void)onCreate {
    [super onCreate];
}

- (void)onDestroy {
    [mQueueRoot enumChildrenUsing:^(id<JINode> child, NSUInteger idx, BOOL *stop) {
        [JWCoreUtils destroyObject:child];
    }];
    mQueueRoot = nil;
    [super onDestroy];
}

- (void)queueEvent:(id<JIQueueEvent>)event {
    if (event == nil) {
        return;
    }
    if (mQueueRoot == nil) {
        mQueueRoot = [[JWQueueEventNode alloc] initWithEvent:nil];
    }
    JWQueueEventNode* qen = [[JWQueueEventNode alloc] initWithEvent:event];
    [mQueueRoot addChild:qen];
}

- (void)unqueueEvent:(id<JIQueueEvent>)event {
    if (event == nil) {
        return;
    }
    if (mQueueRoot == nil) {
        return;
    }
    JWQueueEventNode* qen = [[JWQueueEventNode alloc] initWithEvent:event];
    [mQueueRoot removeChild:qen];
}

- (void)cancelEvent:(id<JIQueueEvent>)event {
    if (event == nil) {
        return;
    }
    JWQueueEventNode* qen = [[JWQueueEventNode alloc] initWithEvent:event];
    if ([mQueueRoot removeChild:qen]) {
        [event onCancelEvent];
        [JWCoreUtils destroyObject:qen];
    }
}

- (BOOL)consumeEvent {
    return [self consumeEventWithType:NULL];
}

- (BOOL)consumeEventWithType:(Class)type {
    BOOL consumed = NO;
    if (mQueueRoot == nil) {
        return consumed;
    }
    JWQueueEventNode* qen = mQueueRoot.firstChild;
    id<JIQueueEvent> event = qen.event;
    if (event != nil) {
        if (type == NULL || [event isMemberOfClass:type]) {
            [event onDoEvent];
            consumed = YES;
        }
        if (consumed) {
            [mQueueRoot removeChild:qen];
        }
    }
    return consumed;
}

- (BOOL)isEmpty {
    return mQueueRoot == nil || mQueueRoot.firstChild == nil;
}

- (void)enumEventsUsing:(void (^)(id<JIQueueEvent>, NSUInteger, BOOL *))block {
    if (mQueueRoot == nil) {
        return;
    }
    [mQueueRoot enumChildrenUsing:^(id<JINode> child, NSUInteger idx, BOOL *stop) {
        JWQueueEventNode* qen = child;
        block(qen.event, idx, stop);
    }];
}

@end

//@interface JWEventQueue ()
//{
//    NSMutableArray* mQueue;
//}
//
//@property (nonatomic, readonly) NSMutableArray* queue;
//
//@end
//
//@implementation JWEventQueue
//
//+ (id)queue {
//    return [[JWEventQueue alloc] init];
//}
//
//- (void)onCreate {
//    [super onCreate];
//}
//
//- (void)onDestroy {
//    [JWCoreUtils destroyArray:mQueue];
//    mQueue = nil;
//    [super onDestroy];
//}
//
//- (NSMutableArray *)queue
//{
//    if(mQueue == nil)
//        mQueue = [NSMutableArray array];
//    return mQueue;
//}
//
//- (void)queueEvent:(id<JIQueueEvent>)event {
//    [self.queue add:event];
//}
//
//- (void)unqueueEvent:(id<JIQueueEvent>)event {
//    [self.queue remove:event];
//}
//
//- (void)cancelEvent:(id<JIQueueEvent>)event {
//    if ([self.queue remove:event]) {
//        [event onCancelEvent];
//        [JWCoreUtils destroyObject:event];
//    }
//}
//
//- (BOOL)consumeEvent {
//    return [self consumeEventWithType:NULL];
//}
//
//- (BOOL)consumeEventWithType:(Class)type {
//    BOOL consumed = NO;
//    if ([self.queue isEmpty]) {
//        return consumed;
//    }
//    id<JIQueueEvent> event = [self.queue removeFirst];
//    if (event != nil) {
//        if (type == NULL || [event isMemberOfClass:type]) {
//            [event onDoEvent];
//            consumed = YES;
//        }
//        if (!consumed) {
//            [self.queue add:event];
//        }
//    }
//    return consumed;
//}
//
//- (BOOL)isEmpty {
//    return self.queue.isEmpty;
//}
//
//- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
//    return [self.queue countByEnumeratingWithState:state objects:buffer count:len];
//}
//
//@end
