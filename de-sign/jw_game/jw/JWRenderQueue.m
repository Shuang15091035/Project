//
//  JWRenderQueue.m
//  June Winter
//
//  Created by GavinLo on 14-5-2.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWRenderQueue.h"
#import "JWRenderable.h"
#import "JWMaterial.h"
//#import "JWList.h"
#import <jw/JWNode.h>

//static NSComparisonResult (^JWRenderableComparator)(id, id) = ^(id obj1, id obj2)
//{
//    id<JIRenderable> lr = (id<JIRenderable>)obj1;
//    id<JIRenderable> rr = (id<JIRenderable>)obj2;
//    id<JIMaterial> lm = lr.material;
//    id<JIMaterial> rm = rr.material;
//    const NSInteger lro = lr.renderOrder;
//    const NSInteger rro = rr.renderOrder;
//    if (lro == rro) {
//        // 渲染顺序相同时则通过材质排序，同时区分透明与非透明物件的渲染
//        // TODO **因为物件没有做深度排序，所以这种方式可能还是会存在问题
//        return [JWMaterial compareMaterial:lm toOther:rm];
//    }
//    return lro < rro ? NSOrderedAscending : NSOrderedDescending;
//};
//
//@interface JWRenderQueue ()
//{
//    id<JIUList> mQueue;
//}
//
//@property (nonatomic, readonly) id<JIUList> queue;
//
//@end
//
//@implementation JWRenderQueue
//
//- (id<JIUList>)queue
//{
//    if(mQueue == nil)
//    {
//        mQueue = [JWSafeUList list];
//        mQueue.sortingComparator = JWRenderableComparator;
//    }
//    return mQueue;
//}
//
//- (void)onCreate
//{
//    [super onCreate];
//}
//
//- (void)onDestroy
//{
//    [mQueue clear];
//    mQueue = nil;
//    [super onDestroy];
//}
//
//- (void)add:(id<JIRenderable>)renderable {
//    if (renderable == nil) {
//        return;
//    }
//    
//    id<JIUList> queue = self.queue;
//    id<JIRenderQueue> rq = renderable.renderQueue;
//    if (rq == self) {
//        return;
//    }
//    if (rq != nil) {
//        [rq remove:renderable];
//    }
//    [queue addObject:renderable likeASet:YES];
//}
//
//- (void)remove:(id<JIRenderable>)renderable {
//    id<JIUList> queue = self.queue;
//    [queue removeObject:renderable];
//}
//
//- (void)clear {
//    [self.queue clear];
//}
//
//// TODO 这里渲染一帧需要遍历两次列表，暂不作优化
//- (void)renderBackgrounds:(id)data {
//    id<JIUList> queue = self.queue;
//    [queue sort];
//    [queue enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//        id<JIRenderable> renderable = obj;
//        NSInteger renderOrder = renderable.renderOrder;
//        if(renderable.visible && JWRenderOrderBackgroundBegin < renderOrder && renderOrder < JWRenderOrderBackgroundEnd) {
//            [renderable render:data];
//        }
//    }];
//}
//
//// TODO 这里渲染一帧需要遍历两次列表，暂不作优化
//- (void)renderObjects:(id)data {
//    id<JIUList> queue = self.queue;
//    [queue sort];
//    [queue enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//        id<JIRenderable> renderable = obj;
//        NSInteger renderOrder = renderable.renderOrder;
//        if(renderable.visible && JWRenderOrderObjectBegin < renderOrder && renderOrder < JWRenderOrderObjectEnd) {
//            [renderable render:data];
//        }
//    }];
//}
//
//- (void)notifyChangedByRenderable:(id<JIRenderable>)renderable {
//    id<JIUList> queue = self.queue;
//    [queue notifyResort];
//}
//
//@end

@interface JWRenderQueueNode : JWNode {
    id<JIRenderable> mRenderable;
}

- (id) initWithRenderable:(id<JIRenderable>)renderable;
- (id) initWithRenderableHasParent:(id<JIRenderable>)renderable;

@property (nonatomic, readonly) id<JIRenderable> renderable;

@end

@interface JWRenderQueue () {
    JWRenderQueueNode* mBackgroundRoot;
    JWRenderQueueNode* mObjectRoot;
}

@property (nonatomic, readonly) JWRenderQueueNode* backgroundRoot;
@property (nonatomic, readonly) JWRenderQueueNode* objectRoot;

+ (BOOL) isBackground:(id<JIRenderable>)renderable;
+ (BOOL) isObject:(id<JIRenderable>)renderable;

@end

static NSComparisonResult (^JWRenderableComparator)(id, id) = ^(id obj1, id obj2) {
    JWRenderQueueNode* ln = (JWRenderQueueNode*)obj1;
    JWRenderQueueNode* rn = (JWRenderQueueNode*)obj2;
    id<JIRenderable> lr = ln.renderable;
    id<JIRenderable> rr = rn.renderable;
    id<JIMaterial> lm = lr.material;
    id<JIMaterial> rm = rr.material;
    const NSInteger lro = lr.renderOrder;
    const NSInteger rro = rr.renderOrder;
    if (lro == rro) {
        // 渲染顺序相同时则通过材质排序，同时区分透明与非透明物件的渲染
        // TODO **因为物件没有做深度排序，所以这种方式可能还是会存在问题
        return [JWMaterial compareMaterial:lm toOther:rm];
    }
    return lro < rro ? NSOrderedAscending : NSOrderedDescending;
};

@implementation JWRenderQueueNode

- (id)initWithRenderable:(id<JIRenderable>)renderable {
    self = [super init];
    if (self != nil) {
        mRenderable = renderable;
    }
    return self;
}

- (id)initWithRenderableHasParent:(id<JIRenderable>)renderable {
    self = [super init];
    if (self != nil) {
        if (renderable != nil) {
            JWRenderQueue* rq = renderable.renderQueue;
            if ([JWRenderQueue isBackground:renderable]) {
                mParent = rq.backgroundRoot;
            } else if ([JWRenderQueue isObject:renderable]) {
                mParent = rq.objectRoot;
            }
        }
        mRenderable = renderable;
    }
    return self;
}

@synthesize renderable = mRenderable;

- (BOOL)equals:(id<JINode>)other {
    if (other == nil) {
        return NO;
    }
    JWRenderQueueNode* on = (JWRenderQueueNode*)other;
    return mRenderable == on.renderable;
}

- (NSString *)description {
    return [mRenderable description];
}

@end

@implementation JWRenderQueue

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        [self onCreate];
    }
    return self;
}

- (void)onCreate {
    [super onCreate];
    mBackgroundRoot = [[JWRenderQueueNode alloc] initWithRenderable:nil];
    mBackgroundRoot.comparator = JWRenderableComparator;
    mObjectRoot = [[JWRenderQueueNode alloc] initWithRenderable:nil];
    mObjectRoot.comparator = JWRenderableComparator;
}

- (void)onDestroy {
    [self clear];
    [super onDestroy];
}

@synthesize backgroundRoot = mBackgroundRoot;
@synthesize objectRoot = mObjectRoot;

+ (BOOL)isBackground:(id<JIRenderable>)renderable {
    if (renderable == nil) {
        return NO;
    }
    NSInteger renderOrder = renderable.renderOrder;
    return JWRenderOrderBackgroundBegin < renderOrder && renderOrder < JWRenderOrderBackgroundEnd;
}

+ (BOOL)isObject:(id<JIRenderable>)renderable {
    if (renderable == nil) {
        return NO;
    }
    NSInteger renderOrder = renderable.renderOrder;
    return JWRenderOrderObjectBegin < renderOrder && renderOrder < JWRenderOrderObjectEnd;
}

- (void)add:(id<JIRenderable>)renderable {
    if (renderable == nil) {
        return;
    }
    JWRenderQueueNode* rqn = [[JWRenderQueueNode alloc] initWithRenderable:renderable];
    if ([JWRenderQueue isBackground:renderable]) {
        rqn.parent = mBackgroundRoot;
    } else if ([JWRenderQueue isObject:renderable]) {
        rqn.parent = mObjectRoot;
    }
}

- (void)remove:(id<JIRenderable>)renderable {
    if (renderable == nil) {
        return;
    }
    JWRenderQueueNode* rqn = [[JWRenderQueueNode alloc] initWithRenderableHasParent:renderable];
    rqn.parent = nil;
}

- (NSUInteger)numRenderables {
    return mBackgroundRoot.numChildren + mObjectRoot.numChildren;
}

- (void)clear {
    [mBackgroundRoot clearChildren];
    [mObjectRoot clearChildren];
}

- (void)renderBackgrounds {
    [mBackgroundRoot enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        JWRenderQueueNode* rqn = obj;
        id<JIRenderable> renderable = rqn.renderable;
        if (renderable.visible) {
            [renderable render:nil];
        }
    }];
}

- (void)renderObjects:(id<JICamera>)camera {
    [mObjectRoot enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        JWRenderQueueNode* rqn = obj;
        id<JIRenderable> renderable = rqn.renderable;
        if (renderable.visible) {
            [renderable render:camera];
        }
    }];
}

- (void)notifyChangedByRenderable:(id<JIRenderable>)renderable {
    [self remove:renderable];
    [self add:renderable];
}

- (void)dumpTree {
    NSLog(@"\nbackgrounds -- %@\nobjects -- %@", [mBackgroundRoot dumpTree], [mObjectRoot dumpTree]);
}

@end