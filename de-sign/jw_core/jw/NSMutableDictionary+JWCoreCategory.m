//
//  NSMutableDictionary+JWCoreCategory.m
//  June Winter
//
//  Created by GavinLo on 14-3-4.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "NSMutableDictionary+JWCoreCategory.h"

@implementation NSMutableDictionary (JWCoreCategory)

- (id)get:(NSString *)key
{
    return [self valueForKey:key];
}

- (void)put:(NSString *)key value:(id)value
{
    [self setValue:value forKey:key];
}

- (id)remove:(NSString *)key
{
    id value = [self valueForKey:key];
    [self removeObjectForKey:key];
    return value;
}

- (void)clear
{
    [self removeAllObjects];
}

- (void)addAll:(NSDictionary *)dictionary
{
    if(dictionary == nil)
        return;
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setObject:obj forKey:key];
    }];
}

- (void)iterate:(void (^)(id, id, BOOL *))block
{
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if(key == [NSNull null])
            key = nil;
        if(obj == [NSNull null])
            obj = nil;
        block(key, obj, stop);
    }];
}

- (void)iterateNonNilKey:(void (^)(id, id, BOOL *))block
{
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if(key == [NSNull null])
            return;
        if(obj == [NSNull null])
            obj = nil;
        block(key, obj, stop);
    }];
}

@end
