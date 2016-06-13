//
//  JWObjectQuery.m
//  June Winter_game
//
//  Created by mac zdszkj on 16/1/19.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWObjectQuery.h"

#import "NSArray+JWCoreCategory.h"
#import "JWMutableArray.h"
#import "JCFlags.h"
#import "JWGameObject.h"
#import <jw/JWList.h>

@interface JWObjectQueryResult : JWObject <JIObjectQueryResult> {
    NSMutableArray<JWObjectQueryResultEntry*>* mEntries;
}

@property (nonatomic, readonly) NSMutableArray<JWObjectQueryResultEntry*>* mutableEntries;

@end

@implementation JWObjectQuery

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        mMask = JWSceneQueryMask_All;
    }
    return self;
}

- (id<JIObjectQueryResult>)getResultByObject:(id<JIGameObject>)object inObject:(id<JIGameObject>)inObject {
    JWObjectQueryResult* result = [[JWObjectQueryResult alloc] init];
    NSMutableArray<JWObjectQueryResultEntry*>* entries = result.mutableEntries;
    [self getResult:entries object:object inObject:inObject];
    return result;
}

- (void) getResult:(NSMutableArray*)entries object:(id<JIGameObject>)object inObject:(id<JIGameObject>)inObject {
    if (inObject == nil || object == inObject) {
        return;
    }
    if (JCFlagsTest(inObject.queryMask, mMask)) {
        BOOL r = [inObject queryByObject:object];
        if (r) {
            [entries addObject:[[JWObjectQueryResultEntry alloc] initWithObject:object]];
        }
    }
    [inObject.transform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> t = obj;
        id<JIGameObject> child = t.host;
        [self getResult:entries object:object inObject:child];
    }];
}

@end

@interface JWObjectQueryResultEntry () {
    id<JIGameObject> mObject;
}

@end

@implementation JWObjectQueryResultEntry

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

@implementation JWObjectQueryResult

- (NSUInteger)numEntries {
    return self.entries.count;
}

- (JWObjectQueryResultEntry *)entryAt:(NSUInteger)index {
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
