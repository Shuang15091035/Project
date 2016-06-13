//
//  JWGamePlugin.m
//  June Winter
//
//  Created by GavinLo on 14-4-30.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWGamePlugin.h"

@implementation JWGamePlugin

- (void)onCreate
{
    [super onCreate];
}

- (void)onDestroy
{
    [super onDestroy];
}

- (id<JIGameWorld>)createWorld:(id<JIGameContext>)context
{
    return [[JWGameWorld alloc] init];
}

- (id<JIGameScene>)createScene:(id<JIGameContext>)context
{
    return [[JWGameScene alloc] initWithContext:context];
}

- (id<JIGameObject>)createObject:(id<JIGameContext>)context
{
    return [[JWGameObject alloc] initWithContext:context];
}

@end
