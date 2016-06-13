//
//  NSMutableArray+JWMutableArray.m
//  June Winter
//
//  Created by GavinLo on 14-5-23.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "NSMutableArray+JWMutableArray.h"

@implementation NSMutableArray (JWMutableArray)

- (BOOL)addObject:(id)anObject likeASet:(BOOL)unique willIngoreNil:(BOOL)willIngoreNil
{
    if (anObject == nil) {
        if (willIngoreNil) {
            return NO;
        }
        anObject = [NSNull null];
    }
    if (unique && [self containsObject:anObject]) {
        return NO;
    }
    [self addObject:anObject];
    return YES;
}

- (BOOL)addObject:(id)anObject likeASetUseComparator:(JWIsEqualComparatorBlock)comparator willIngoreNil:(BOOL)willIngoreNil {
    if (anObject == nil) {
        if (willIngoreNil) {
            return NO;
        }
        anObject = [NSNull null];
    }
    if (comparator != nil) {
        for (id obj in self) {
            if (comparator(anObject, obj)) {
                return NO;
            }
        }
    }
    [self addObject:anObject];
    return YES;
}

- (void)addObjectsFromArray:(NSArray *)otherArray likeASet:(BOOL)unique willIngoreNil:(BOOL)willIngoreNil {
    for (id object in otherArray) {
        [self addObject:object likeASet:unique willIngoreNil:willIngoreNil];
    }
}

@end
