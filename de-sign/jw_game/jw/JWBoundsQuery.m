//
//  JWBoundsQuery.m
//  June Winter_game
//
//  Created by ddeyes on 16/1/15.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWBoundsQuery.h"

#import "NSArray+JWCoreCategory.h"
#import "JWMutableArray.h"
#import "JCFlags.h"
#import "JWGameObject.h"
#import <jw/JWList.h>

@interface JWBoundsQueryResult : JWObject <JIBoundsQueryResult> {
    NSMutableArray<JWBoundsQueryResultEntry*>* mEntries;
}

@property (nonatomic, readonly) NSMutableArray<JWBoundsQueryResultEntry*>* mutableEntries;

@end

@implementation JWBoundsQuery

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        mMask = JWSceneQueryMask_All;
    }
    return self;
}

- (id<JIBoundsQueryResult>)getResultByBounds:(JCBounds3)bounds object:(id<JIGameObject>)object {
    JWBoundsQueryResult* result = [[JWBoundsQueryResult alloc] init];
    NSMutableArray<JWBoundsQueryResultEntry*>* entries = result.mutableEntries;
    [self getResult:entries bounds:bounds object:object];
    return result;
}

- (void) getResult:(NSMutableArray*)entries bounds:(JCBounds3)bounds object:(id<JIGameObject>)object {
    if (object == nil) {
        return;
    }
    if (JCFlagsTest(object.queryMask, mMask)) {
        BOOL r = [object queryByBounds:bounds];
        if (r) {
            [entries addObject:[[JWBoundsQueryResultEntry alloc] initWithObject:object]];
        }
    }
    [object.transform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> t = obj;
        id<JIGameObject> child = t.host;
        [self getResult:entries bounds:bounds object:child];
    }];
}

@end

@interface JWBoundsQueryResultEntry () {
    id<JIGameObject> mObject;
}

@end

@implementation JWBoundsQueryResultEntry

- (id)initWithObject:(id<JIGameObject>)object {
    self = [super init];
    if (self != nil) {
        mObject = object;
    }
    return self;
}

@synthesize object = mObject;

- (NSString *)description {
    NSString* desc = [NSString stringWithFormat:@"(obj:%@)", mObject];
    return desc;
}

@end

@implementation JWBoundsQueryResult

- (NSUInteger)numEntries {
    return self.entries.count;
}

- (JWBoundsQueryResultEntry *)entryAt:(NSUInteger)index {
    return [self.entries objectAtIndex:index];
}

- (NSArray *)entries {
    return self.mutableEntries;
}

- (NSMutableArray*)mutableEntries {
    if (mEntries == nil) {
        mEntries = [NSMutableArray array];
    }
    return mEntries;
}

@end

