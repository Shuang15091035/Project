//
//  NSMapTable+JWCoreCategory.m
//  June Winter
//
//  Created by GavinLo on 14/12/29.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "NSMapTable+JWCoreCategory.h"

@implementation NSMapTable (JWCoreCategory)

- (id)get:(id)key
{
    return [self objectForKey:key];
}

- (void)put:(id)key value:(id)value
{
    [self setObject:value forKey:key];
}

- (void)clear
{
    [self removeAllObjects];
}

@end
