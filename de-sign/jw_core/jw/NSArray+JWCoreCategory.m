//
//  NSArray+JWCoreCategory.m
//  June Winter
//
//  Created by GavinLo on 14-3-6.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "NSArray+JWCoreCategory.h"

@implementation NSArray (JWCoreCategory)

- (id)at:(NSUInteger)index
{
    id object = [self objectAtIndex:index];
    if(object == [NSNull null])
        return nil;
    return object;
}

- (NSUInteger)indexOf:(id)object
{
    return [self indexOfObject:object];
}

- (void)iterate:(void (^)(id, NSUInteger, BOOL *))block
{
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(obj == [NSNull null])
            block(nil, idx, stop);
        else
            block(obj, idx, stop);
    }];
}

- (void)iterateNonNil:(void (^)(id, NSUInteger, BOOL *))block
{
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(obj == [NSNull null])
            return;
        block(obj, idx, stop);
    }];
}

+ (BOOL)is:(NSArray *)a equalsTo:(NSArray *)b
{
    return (a == nil) ? (b == nil) : [a isEqualToArray:b];
}

@end
