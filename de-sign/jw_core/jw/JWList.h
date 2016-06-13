//
//  JWList.h
//  June Winter
//
//  Created by GavinLo on 15/1/2.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 无序列表
 * 如果向列表中添加nil,则被忽略
 */
@protocol JIUList <NSObject, NSFastEnumeration>

- (void) addObject:(id)object;
- (BOOL) addObject:(id)object likeASet:(BOOL)unique;
- (void) addObjectsFromList:(id<JIUList>)list;
- (void) addObjectsFromList:(id<JIUList>)list likeASet:(BOOL)unique;
- (BOOL) removeObject:(id)object;
- (BOOL) containsObject:(id)object;
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) BOOL isEmpty;
- (void) clear;
@property (nonatomic, readwrite) NSComparator sortingComparator;
- (void) sort;
- (void) notifyResort;

/**
 * 同步修改内容到主列表，主要用于线程安全
 */
- (void) update;

/**
 * 线程安全迭代，是否安全视子类实现而定
 */
- (void) enumUsing:(void (^)(id obj, NSUInteger idx, BOOL* stop))block;

@end

@interface JWUList : NSObject <JIUList>
{
    BOOL mNeedToResort;
    NSComparator mSortingComparator;
}

+ (id) list;

@end

/**
 * 线程安全的列表
 */
@interface JWSafeUList : JWUList

@end
