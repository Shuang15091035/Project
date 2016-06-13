//
//  JWList.m
//  June Winter
//
//  Created by GavinLo on 15/1/2.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWList.h"
#import "NSMutableArray+JWArrayList.h"
#import "NSMutableArray+JWMutableArray.h"

//@interface NSMutableArray (JWUList)
//
//- (BOOL) addObject:(id)object likeASet:(BOOL)unique;
//
//@end
//
//@implementation NSMutableArray (JWUList)
//
//- (BOOL)addObject:(id)object likeASet:(BOOL)unique
//{
//    if(object == nil)
//        return NO;
//    if(unique && [self containsObject:object])
//        return NO;
//    [self addObject:object];
//    return YES;
//}
//
//- (void)addObjectsFromArray:(NSArray *)otherArray likeASet:(BOOL)unique
//{
//    if(unique)
//    {
//        for(id object in otherArray)
//            [self addObject:object likeASet:YES];
//    }
//    else
//    {
//        [self addObjectsFromArray:otherArray];
//    }
//}
//
//@end

@interface JWUList () {
    NSMutableArray* mArray;
}

@property (nonatomic, readwrite) NSMutableArray* array;

@end

@implementation JWUList

+ (id)list {
    return [[self alloc] init];
}

- (NSMutableArray *)array {
    if(mArray == nil)
        mArray = [NSMutableArray array];
    return mArray;
}

- (void)setArray:(NSMutableArray *)array {
    mArray = array;
}

- (void)addObject:(id)object {
    [self addObject:object likeASet:NO];
}

- (BOOL)addObject:(id)object likeASet:(BOOL)unique {
    BOOL b = [self.array addObject:object likeASet:unique willIngoreNil:NO];
    if(b)
        mNeedToResort = YES;
    return b;
}

- (void)addObjectsFromList:(id<JIUList>)list {
    [self addObjectsFromList:list likeASet:NO];
}

- (void)addObjectsFromList:(id<JIUList>)list likeASet:(BOOL)unique {
    JWUList* l = list;
    [self.array addObjectsFromArray:l.array likeASet:unique willIngoreNil:NO];
    mNeedToResort = YES;
}

- (void)setObject:(id)object atIndex:(NSUInteger)index {
    [self.array replaceObjectAtIndex:index withObject:object];
    mNeedToResort = YES;
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [self.array removeObjectAtIndex:index];
    mNeedToResort = YES;
}

- (BOOL)removeObject:(id)object {
    NSUInteger i = [self.array indexOfObject:object];
    if (i == NSNotFound) {
        return NO;
    }
    [self.array removeObject:object];
    mNeedToResort = YES;
    return YES;
}

- (BOOL)containsObject:(id)object {
    return [self.array containsObject:object];
}

- (NSUInteger)count {
    return self.array.count;
}

- (BOOL)isEmpty {
    if (mArray == nil)
        return YES;
    return mArray.count == 0;
}

- (void)clear {
    [self.array removeAllObjects];
}

- (NSComparator)sortingComparator {
    return mSortingComparator;
}

- (void)setSortingComparator:(NSComparator)sortingComparator {
    mSortingComparator = sortingComparator;
}

- (void)sort {
    if (mNeedToResort) {
        [self.array sortUsingComparator:mSortingComparator];
        mNeedToResort = NO;
    }
}

- (void)notifyResort {
    mNeedToResort = YES;
}

- (void)update {
    // subclass override
}

- (void)enumUsing:(void (^)(id, NSUInteger, BOOL *))block {
    [self.array enumerateObjectsUsingBlock:block];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
    return [self.array countByEnumeratingWithState:state objects:buffer count:len];
}

@end

//@interface JWSafeListObjectEntry : NSObject {
//    id mObject;
//    BOOL mUnique;
//    NSUInteger mIndex;
//}
//
//+ entryWithObject:(id)object unique:(BOOL)unique;
//- initWithObject:(id)object unique:(BOOL)unique;
//+ entryWithObject:(id)object index:(NSUInteger)index;
//- initWithObject:(id)object index:(NSUInteger)index;
//@property (nonatomic, readwrite) id object;
//@property (nonatomic, readwrite) BOOL unique;
//@property (nonatomic, readwrite) NSUInteger index;
//
//@end
//
//@implementation JWSafeListObjectEntry
//
//@synthesize object = mObject;
//@synthesize unique = mUnique;
//@synthesize index = mIndex;
//
//+ (id)entryWithObject:(id)object unique:(BOOL)unique {
//    return [[self alloc] initWithObject:object unique:unique];
//}
//
//- (id)initWithObject:(id)object unique:(BOOL)unique {
//    self = [super init];
//    if (self != nil) {
//        mObject = object;
//        mUnique = unique;
//    }
//    return self;
//}
//
//+ (id)entryWithObject:(id)object index:(NSUInteger)index {
//    return [[self alloc] initWithObject:object index:index];
//}
//
//- (id)initWithObject:(id)object index:(NSUInteger)index {
//    self = [super init];
//    if (self != nil) {
//        mObject = object;
//        mIndex = index;
//    }
//    return self;
//}
//
//@end

@interface JWSafeUList () {
    NSObject* mArrayLock;
}

@end

@implementation JWSafeUList

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        mArrayLock = [[NSObject alloc] init];
    }
    return self;
}

- (BOOL)addObject:(id)object likeASet:(BOOL)unique {
    @synchronized(mArrayLock) {
        NSMutableArray* array = self.array;
        if ([array addObject:object likeASet:unique willIngoreNil:NO]) {
            [self notifyResort];
        }
    }
    return YES;
}

- (void)addObjectsFromList:(id<JIUList>)list likeASet:(BOOL)unique {
    __block BOOL b = NO;
    @synchronized(mArrayLock) {
        NSMutableArray* array = self.array;
        [list enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
            b = [array addObject:obj likeASet:unique willIngoreNil:NO];
        }];
    }
    if (b) {
        [self notifyResort];
    }
}

- (BOOL)removeObject:(id)object {
    BOOL b = NO;
    @synchronized(mArrayLock) {
        NSMutableArray* array = self.array;
        if ([array containsObject:object]) {
            [array removeObject:object];
            [self notifyResort];
            b = YES;
        }
    }
    return b;
}

- (void)clear {
    @synchronized(mArrayLock) {
        NSMutableArray* array = self.array;
        [array clear];
    }
    [self notifyResort];
}

- (void)enumUsing:(void (^)(id, NSUInteger, BOOL *))block {
    @synchronized(mArrayLock) {
        NSArray* array = self.array;
        [array enumerateObjectsUsingBlock:block];
    }
}

- (void)sort {
    if (mNeedToResort) {
        @synchronized(mArrayLock) {
            NSMutableArray* array = self.array;
            [array sortUsingComparator:mSortingComparator];
        }
        mNeedToResort = NO;
    }
}

@end

//@interface JWSafeUList () {
//    // 使用两个记录修改的列表来避免迭代中修改主列表，通过update方法同步修改，以实现线程安全
//    NSMutableArray* mAddedArray;
//    NSMutableArray* mRemovedArray;
//}
//
//@property (nonatomic, readonly) NSMutableArray* addedArray;
//@property (nonatomic, readonly) NSMutableArray* removedArray;
//
//@end
//
//@implementation JWSafeUList
//
//- (NSMutableArray *)addedArray {
//    if(mAddedArray == nil)
//        mAddedArray = [NSMutableArray array];
//    return mAddedArray;
//}
//
//- (NSMutableArray *)removedArray {
//    if(mRemovedArray == nil)
//        mRemovedArray = [NSMutableArray array];
//    return mRemovedArray;
//}
//
//+ (void) removeEntry:(JWSafeListObjectEntry*)entry fromArray:(NSMutableArray*)array {
//    if (array == nil) {
//        return;
//    }
//    JWSafeListObjectEntry* removeEntry = nil;
//    for (JWSafeListObjectEntry* e in array) {
//        if (e.object == entry.object) {
//            removeEntry = e;
//        }
//    }
//    [array removeObject:removeEntry];
//}
//
//- (BOOL)addObject:(id)object likeASet:(BOOL)unique {
//    NSMutableArray* addedArray = self.addedArray;
//    NSMutableArray* removedArray = self.removedArray;
//    JWSafeListObjectEntry* entry = [JWSafeListObjectEntry entryWithObject:object unique:unique];
//    [JWSafeUList removeEntry:entry fromArray:removedArray];
//    [addedArray addObject:entry];
//    return YES;
//}
//
//- (void)addObjectsFromList:(id<JIUList>)list likeASet:(BOOL)unique {
//    for (id obj in list) {
//        [self addObject:obj likeASet:unique];
//    }
//}
//
//- (BOOL)removeObject:(id)object {
//    NSMutableArray* addedArray = self.addedArray;
//    NSMutableArray* removedArray = self.removedArray;
//    JWSafeListObjectEntry* entry = [JWSafeListObjectEntry entryWithObject:object index:NSUIntegerMax];
//    [JWSafeUList removeEntry:entry fromArray:addedArray];
//    [removedArray addObject:entry];
//    return YES;
//}
//
//- (void)clear {
//    NSMutableArray* removedArray = self.removedArray;
//    JWSafeListObjectEntry* entry = [JWSafeListObjectEntry entryWithObject:nil index:(NSUIntegerMax - 1)];
//    [removedArray addObject:entry];
//}
//
//- (void)update {
//    if (mAddedArray == nil && mRemovedArray == nil) {
//        return;
//    }
//    if (mAddedArray.count == 0 && mRemovedArray.count == 0) {
//        return;
//    }
//    NSMutableArray* array = self.array;
//    for (JWSafeListObjectEntry* obj in mAddedArray) {
//        [array addObject:obj.object likeASet:obj.unique];
//    }
//    [mAddedArray removeAllObjects];
//    for (JWSafeListObjectEntry* obj in mRemovedArray) {
//        if (obj.index == NSUIntegerMax) {
//            [array removeObject:obj.object];
//        } else if (obj.index == NSUIntegerMax - 1) {
//            [array removeAllObjects];
//        } else {
//            [array removeObjectAtIndex:obj.index];
//        }
//    }
//    [mRemovedArray removeAllObjects];
//    [self notifyResort];
//}
//
//- (void)enumUsing:(void (^)(id, NSUInteger, BOOL *))block
//{
//    [self update];
//    NSUInteger i = 0;
//    NSArray* array = self.array;
//    for(id obj in array)
//    {
//        BOOL stop = NO;
//        block(obj, i++, &stop);
//        if(stop)
//            break;
//    }
//}
//
//@end
