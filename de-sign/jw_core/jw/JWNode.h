//
//  JWNode.h
//  jw_core
//
//  Created by ddeyes on 15/12/3.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWEntity.h>

@protocol JINode <JIEntity>

//+ (bool)replaceNodeFrom:(id<JINode>)from to:(id<JINode>)to;

/**
 * 设置parent相当于把node挂接到parent的子序列当中，
 * 使用comparator可以让挂接的时候，child按升序排列
 */
@property (nonatomic, readwrite) id<JINode> parent;
- (void) addChild:(id<JINode>)child;
- (bool) removeChild:(id<JINode>)child;
@property (nonatomic, readwrite) id<JINode> firstChild;
@property (nonatomic, readwrite) id<JINode> nextSibling;
@property (nonatomic, readonly) id<JINode> lastSibling;
@property (nonatomic, readonly) NSUInteger numChildren;
- (void) enumChildrenUsing:(void (^)(id<JINode> child, NSUInteger idx, BOOL* stop))block;
- (void) enumSiblingsUsing:(void (^)(id<JINode> sibling, NSUInteger idx, BOOL* stop))block;
- (BOOL) hasChild:(id<JINode>)child;
- (void) clearChildren;
@property (nonatomic, readwrite, copy) NSComparator comparator;
- (BOOL) equals:(id<JINode>)other;

- (NSString*) dumpTree;

@end

@interface JWNode : JWEntity <JINode> {
    id<JINode> mParent;
    id<JINode> mFirstChlid;
    id<JINode> mNextSibling;
    NSComparator mComparator;
}

+ (id) node;

@end
