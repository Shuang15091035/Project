//
//  JWNode.m
//  jw_core
//
//  Created by ddeyes on 15/12/3.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWNode.h"
#import "JWCoreUtils.h"
#import "NSArray+JWCoreCategory.h"

@implementation JWNode

+ (id)node {
    return [[self alloc] init];
}

- (void)onDestroy {
    self.parent = nil;
    [self clearChildren];
    mNextSibling = nil;
    [super onDestroy];
}

//+ (bool)replaceNodeFrom:(id<JINode>)from to:(id<JINode>)to {
//    if (from == nil) {
//        return false;
//    }
//    if (from.parent == nil && from.nextSibling == nil) { // 孤立节点
//        return false;
//    }
//    
//    return true;
//}

- (id<JINode>)parent {
    return mParent;
}

- (void)setParent:(id<JINode>)parent {
    JWNode* par = mParent;
    if (par != nil) {
        [par removeChild:self];
    }
    mParent = parent;
    par = mParent;
    if (par != nil) {
        [par addChild:self];
    }
}

- (void)addChild:(id<JINode>)child {
    if (child == nil) {
        return;
    }
    
    if ([self hasChild:child]) { // 不允许子节点重复
        return;
    }
    
    // NOTE 寻找插入点，并实现插入排序（升序排列）
    id<JINode> curNode = mFirstChlid;
    id<JINode> preNode = nil;
    id<JINode> addToThis = nil;
    while (curNode != nil) {
        if (mComparator != nil && mComparator(child, curNode) == NSOrderedAscending) {
            addToThis = preNode;
            break;
        } else {
            addToThis = curNode;
        }
        preNode = curNode;
        curNode = curNode.nextSibling;
    }
    
    // 插入处理
    if (addToThis == nil) {
        id<JINode> firstChild = mFirstChlid;
        mFirstChlid = child;
        child.nextSibling = firstChild;
    } else {
        id<JINode> nextSibling = addToThis.nextSibling;
        addToThis.nextSibling = child;
        child.nextSibling = nextSibling;
    }
}

- (bool)removeChild:(id<JINode>)child {
    if (child == nil || mFirstChlid == nil) {
        return false;
    }
    id<JINode> removeThis = nil;
    if ([child equals:mFirstChlid]) {
        removeThis = mFirstChlid; // NOTE 避免判断相同而引用不同产生的bug
        mFirstChlid = removeThis.nextSibling;
        removeThis.nextSibling = nil;
        return true;
    }
    id<JINode> curNode = mFirstChlid;
    id<JINode> preNode = nil;
    id<JINode> removeFromThis = nil;
    while (curNode != nil) {
        if ([child equals:curNode]) {
            removeFromThis = preNode;
            removeThis = curNode; // NOTE 避免判断相同而引用不同产生的bug
            break;
        }
        preNode = curNode;
        curNode = curNode.nextSibling;
    }
    if (removeFromThis != nil) {
        removeFromThis.nextSibling = removeThis.nextSibling;
        removeThis.nextSibling = nil;
    }
    return true;
}

@synthesize firstChild = mFirstChlid;
@synthesize nextSibling = mNextSibling;

- (id<JINode>)lastSibling {
    id<JINode> findLastSibling = nil;
    id<JINode> sibling = mNextSibling;
    while(sibling != nil) {
        findLastSibling = sibling;
        sibling = sibling.nextSibling;
    }
    return findLastSibling;
}

- (NSUInteger)numChildren {
    id<JINode> child = mFirstChlid;
    NSUInteger i = 0;
    while (child != nil) {
        child = child.nextSibling;
        i++;
    }
    return i;
}

- (void)enumChildrenUsing:(void (^)(id<JINode>, NSUInteger, BOOL *))block {
    id<JINode> child = mFirstChlid;
    NSUInteger i = 0;
    while (child != nil) {
        BOOL stop = NO;
        block(child, i, &stop);
        if (stop) {
            break;
        }
        child = child.nextSibling;
        i++;
    }
}

- (void) enumSiblingsUsing:(void (^)(id<JINode> sibling, NSUInteger idx, BOOL* stop))block {
    id<JINode> sibling = mNextSibling;
    NSUInteger i = 0;
    while (sibling != nil) {
        BOOL stop = NO;
        block(sibling, i, &stop);
        if (stop) {
            break;
        }
        sibling = sibling.nextSibling;
        i++;
    }
}

- (BOOL)hasChild:(id<JINode>)child {
    id<JINode> curNode = mFirstChlid;
    while (curNode != nil) {
        if ([child equals:curNode]) {
            return YES;
        }
        curNode = curNode.nextSibling;
    }
    return NO;
}

- (void)clearChildren {
    id<JINode> child = mFirstChlid;
    while (child != nil) {
        id<JINode> nextSibling = child.nextSibling;
        [JWCoreUtils destroyObject:child];
        child = nextSibling;
    }
    mFirstChlid = nil;
}

@synthesize comparator = mComparator;

- (BOOL)equals:(id<JINode>)other {
    return self == other;
}

//- (NSString *)description {
//    return [NSString stringWithFormat:@"%@ -- \nparent(%@)\nfc(%@)\nns(%@)\nnc(%@)", NSStringFromClass([self class]), mParent, mFirstChlid, mNextSibling, @(self.numChildren)];
//}

- (NSString *)dumpTree {
    NSMutableString* tree = [NSMutableString string];
    [self appendChildDescriptionTo:tree prefix:@"|--"];
    return tree;
}

- (void) appendChildDescriptionTo:(NSMutableString*)description prefix:(NSString*)prefix {
    NSString* desc = self.description;
    NSArray* lines = [desc componentsSeparatedByString:@"\n"];
    if (lines.count == 1) {
        [description appendFormat:@"\n%@%@", prefix, desc];
    } else if (lines.count > 1) {
        NSString* line0 = [lines at:0];
        [description appendFormat:@"\n%@%@", prefix, line0];
        for (NSUInteger i = 1; i < lines.count; i++) {
            NSString* line = [lines at:i];
            [description appendFormat:@"\n%@  *%@", prefix, line];
        }
    }
    //[description appendFormat:@"\n%@%@", prefix, self.description];
    NSString* newPrefix = [NSString stringWithFormat:@"|   %@", prefix];
    [self enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        JWNode* node = obj;
        [node appendChildDescriptionTo:description prefix:newPrefix];
    }];
}

@end
