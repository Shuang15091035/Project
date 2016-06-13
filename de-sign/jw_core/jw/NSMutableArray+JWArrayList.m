//
//  NSMutableArray+JWArrayList.m
//  June Winter
//
//  Created by GavinLo on 14-3-4.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "NSMutableArray+JWArrayList.h"

@implementation NSMutableArray (JWArrayList)

- (void)add:(id)object
{
    if(object == nil)
        object = [NSNull null];
    [self addObject:object];
}

- (BOOL)remove:(id)object
{
    if([self indexOfObject:object] == NSNotFound)
        return NO;
    [self removeObject:object];
    return YES;
}

- (id)removeFirst
{
    id first = [self at:0];
    [self remove:first];
    return first;
}

- (id)removeLast
{
    id last = [self at:(self.count - 1)];
    [self removeLastObject]; // last有可能出现在列表中的不同位置,不能直接移除[self remove:last]
    return last;
}

- (void)pop
{
    [self removeLastObject];
}

- (void)clear
{
    [self removeAllObjects];
}

- (id)at:(NSUInteger)index
{
    if(index >= self.count)
        return nil;
    
    id object = [self objectAtIndex:index];
    if(object == [NSNull null])
        return nil;
    return object;
}

- (NSUInteger)indexOf:(id)object
{
    return [self indexOfObject:object];
}

- (void)set:(NSUInteger)index object:(id)object
{
    if(index >= self.count)
    {
        NSUInteger addItemsCount = index - self.count + 1;
        for(NSUInteger i = 0; i < addItemsCount; i++)
            [self add:nil];
    }
    if(object == nil)
        object = [NSNull null];
    [self replaceObjectAtIndex:index withObject:object];
}

- (BOOL)contains:(id)object
{
    if(object == nil)
        object = [NSNull null];
    return [self containsObject:object];
}

- (BOOL)isEmpty
{
    return self.count == 0;
}

- (void)addAll:(NSArray *)array
{
    [self addObjectsFromArray:array];
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

@end
