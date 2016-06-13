//
//  JWGame.m
//  June Winter
//
//  Created by GavinLo on 14-5-3.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWGame.h"
#import "JWGameContext.h"

@interface JWGame ()
{
    id<JIGameEngine> mEngine;
    id<JIGameWorld> mWorld;
}

@end

@implementation JWGame

- (void)onCreate
{
    if(mEngine == nil)
        return;
    
    mWorld = [mEngine.context createWorld];
    [self onContentCreate];
}

- (id<JIGameEngine>)engine
{
    return mEngine;
}

- (id<JIGameWorld>)world
{
    return mWorld;
}

- (UIView *)onUiCreate:(UIView *)parent {
    return nil;
}

- (void)onContentCreate
{
    
}

- (void)onContentDestroy
{
    
}

- (void)setEngine:(id<JIGameEngine>)engine
{
    mEngine = engine;
}

@end
