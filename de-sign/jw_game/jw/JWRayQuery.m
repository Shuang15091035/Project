//
//  JWRayQuery.m
//  June Winter
//
//  Created by GavinLo on 14/12/10.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWRayQuery.h"
#import "NSArray+JWCoreCategory.h"
#import "JWMutableArray.h"
#import "JCFlags.h"
#import "JWGameObject.h"
#import <jw/JWList.h>

@interface JWRayQueryResult : JWObject <JIRayQueryResult> {
    NSMutableArray* mEntries;
}

@property (nonatomic, readonly) NSMutableArray* mutableEntries;

@end

@implementation JWRayQuery

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        mMask = JWSceneQueryMask_All;
    }
    return self;
}

@synthesize willSortByDistance = mWillSortByDistance;

static NSComparisonResult (^JWRayQueryResultComparator)(id, id) = ^(id obj1, id obj2) {
    JWRayQueryResultEntry* lhs = obj1;
    JWRayQueryResultEntry* rhs = obj2;
    const float ld = lhs.distance;
    const float rd = rhs.distance;
    if (ld == rd) {
        return NSOrderedSame;
    }
    return ld < rd ? NSOrderedAscending : NSOrderedDescending;
};

- (id<JIRayQueryResult>)getResultByRay:(JCRay3)ray object:(id<JIGameObject>)object {
    JWRayQueryResult* result = [[JWRayQueryResult alloc] init];
    NSMutableArray* entries = result.mutableEntries;
    [self getResult:entries ray:ray object:object];
    if (mWillSortByDistance) {
        [entries sortUsingComparator:JWRayQueryResultComparator];
    }
    return result;
}

- (void) getResult:(NSMutableArray*)entries ray:(JCRay3)ray object:(id<JIGameObject>)object
{
    if (object == nil) {
        return;
    }
    if (JCFlagsTest(object.queryMask, mMask)) {
        JCRayBounds3IntersectResult r = [object queryByRay:ray];
        if (r.hit) {
            [entries addObject:[[JWRayQueryResultEntry alloc] initWithObject:object distance:r.distance]];
        }
    }
    [object.transform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> t = obj;
        id<JIGameObject> child = t.host;
        [self getResult:entries ray:ray object:child];
    }];
}

@end

@interface JWRayQueryResultEntry () {
    id<JIGameObject> mObject;
    float mDistance;
}

@end

@implementation JWRayQueryResultEntry

- (id)initWithObject:(id<JIGameObject>)object distance:(float)distance {
    self = [super init];
    if (self != nil) {
        mObject = object;
        mDistance = distance;
    }
    return self;
}

@synthesize object = mObject;
@synthesize distance = mDistance;

- (NSString *)description {
    NSString* desc = [NSString stringWithFormat:@"(obj:%@, d:%f)", mObject, mDistance];
    return desc;
}

@end

@implementation JWRayQueryResult

- (NSUInteger)numEntries {
    return self.entries.count;
}

- (JWRayQueryResultEntry *)entryAt:(NSUInteger)index {
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
