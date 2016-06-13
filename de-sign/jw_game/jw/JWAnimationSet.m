//
//  JWAnimationSet.m
//  June Winter_game
//
//  Created by ddeyes on 16/2/26.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAnimationSet.h"
#import "JWAnimation.h"
#import "JWGameContext.h"
#import <jw/JWNode.h>
#import <jw/JWCoreUtils.h>
#import <jw/NSString+JWCoreCategory.h>

@interface JWAnimationNode : JWNode {
    id<JIAnimation> mAnimation;
}

+ (id) nodeWithAnimation:(id<JIAnimation>)animation;
- (id) initWithAnimation:(id<JIAnimation>)animation;
@property (nonatomic, readwrite) id<JIAnimation> animation;

@end

@implementation JWAnimationNode

+ (id)nodeWithAnimation:(id<JIAnimation>)animation {
    return [[self alloc] initWithAnimation:animation];
}

- (id)initWithAnimation:(id<JIAnimation>)animation {
    self = [super init];
    if (self != nil) {
        mAnimation = animation;
    }
    return self;
}

@synthesize animation = mAnimation;

@end

@interface JWAnimationSet () {
    JWAnimationNode* mRoot;
}

@end

@implementation JWAnimationSet

- (void)onDestroy {
    if (mRoot != nil) {
        [mRoot enumChildrenUsing:^(id<JINode> node, NSUInteger idx, BOOL *stop) {
            JWAnimationNode* an = node;
            id<JIAnimation> anim = an.animation;
            [JWCoreUtils destroyObject:anim];
        }];
        mRoot = nil;
    }
    [super onDestroy];
}

- (void)addAnimation:(id<JIAnimation>)animation {
    if (animation == nil) {
        return;
    }
    if (mRoot == nil) {
        mRoot = [[JWAnimationNode alloc] init];
    }
    JWAnimationNode* an = [JWAnimationNode nodeWithAnimation:animation];
    an.parent = mRoot;
}

- (void)removeAnimation:(id<JIAnimation>)animation {
    if (animation == nil) {
        return;
    }
    if (mRoot == nil) {
        return;
    }
    __block JWAnimationNode* foundAnimNode = nil;
    [mRoot enumChildrenUsing:^(id<JINode> node, NSUInteger idx, BOOL *stop) {
        JWAnimationNode* an = node;
        id<JIAnimation> anim = an.animation;
        if (anim == animation) {
            foundAnimNode = an;
            *stop = YES;
        }
    }];
    if (foundAnimNode == nil) {
        return;
    }
    foundAnimNode.parent = nil;
}

- (id<JIAnimation>)animationForId:(NSString *)animationId {
    if (mRoot == nil) {
        return nil;
    }
    __block id<JIAnimation> foundAnim = nil;
    [mRoot enumChildrenUsing:^(id<JINode> node, NSUInteger idx, BOOL *stop) {
        JWAnimationNode* an = node;
        id<JIAnimation> anim = an.animation;
        if ([NSString is:anim.Id equalsTo:animationId]) {
            foundAnim = anim;
            *stop = YES;
        }
    }];
    return foundAnim;
}

- (void)enumAnimationUsing:(void (^)(id<JIAnimation>, NSUInteger, BOOL *))block {
    if (mRoot == nil) {
        return;
    }
    [mRoot enumChildrenUsing:^(id<JINode> node, NSUInteger idx, BOOL *stop) {
        JWAnimationNode* an = node;
        id<JIAnimation> anim = an.animation;
        block(anim, idx, stop);
    }];
}

- (void)onUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime {
    if (mRoot == nil) {
        return;
    }
    [mRoot enumChildrenUsing:^(id<JINode> node, NSUInteger idx, BOOL *stop) {
        JWAnimationNode* an = node;
        id<JIAnimation> anim = an.animation;
        [anim onUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
    }];
}

- (void)onTransformChanged:(id<JITransform>)transform {
    if (mRoot == nil) {
        return;
    }
    [mRoot enumChildrenUsing:^(id<JINode> node, NSUInteger idx, BOOL *stop) {
        JWAnimationNode* an = node;
        JWAnimation* anim = an.animation;
        [anim onTransformChanged:transform];
    }];
}

- (id<JIComponent>)copyInstance {
    JWAnimationSet* animationSet = [mContext createAnimationSet];
    if (mRoot != nil) {
        [mRoot enumChildrenUsing:^(id<JINode> node, NSUInteger idx, BOOL *stop) {
            JWAnimationNode* an = node;
            id<JIAnimation> anim = an.animation;
            [animationSet addAnimation:(id<JIAnimation>)[anim copyInstance]];
        }];
    }
    return animationSet;
}

@end
