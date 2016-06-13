//
//  JWGamePluginSystem.m
//  June Winter
//
//  Created by GavinLo on 14-4-30.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWGamePluginSystem.h"
#import "JWCoreUtils.h"
#import "JWLog.h"
#import "JWGamePlugin.h"

@interface JWGamePluginSystem () {
    id<JIGamePlugin> mGamePlugin;
    id<JIRenderPlugin> mRenderPlugin;
    id<JIInputPlugin> mInputPlugin;
    id<JIARPlugin> mArPlugin;
}

@end

@implementation JWGamePluginSystem

- (void)onCreate
{
    [super onCreate];
}

- (void)onDestroy
{
    [JWCoreUtils destroyObject:mGamePlugin];
    mGamePlugin = nil;
    [JWCoreUtils destroyObject:mRenderPlugin];
    mRenderPlugin = nil;
    [JWCoreUtils destroyObject:mInputPlugin];
    mInputPlugin = nil;
    [JWCoreUtils destroyObject:mArPlugin];
    mArPlugin = nil;
    [super onDestroy];
}

- (id<JIGamePlugin>)gamePlugin
{
    if(mGamePlugin == nil)
    {
        mGamePlugin = [[JWGamePlugin alloc] init];
        [[[[JWLog log] withLevel:JWLogLevelNormal] withType:JWLogTypeSystem] log:@"No Game Plugin install. use default plugin instead."];
    }
    return mGamePlugin;
}

- (void)setGamePlugin:(id<JIGamePlugin>)gamePlugin
{
    if(gamePlugin == nil)
    {
        [JWCoreUtils destroyObject:mGamePlugin];
        mGamePlugin = nil;
        return;
    }
    if(mGamePlugin != nil)
    {
        @throw [NSException exceptionWithName:@"PluginSystem" reason:[NSString stringWithFormat:@"Game Plugin has been installed [%@].", NSStringFromClass([mGamePlugin class])] userInfo:nil];
    }
    [gamePlugin onCreate];
    mGamePlugin = gamePlugin;
}

- (id<JIRenderPlugin>)renderPlugin
{
    if(mRenderPlugin == nil)
    {
        @throw [NSException exceptionWithName:@"PluginSystem" reason:@"No Render Plugin install. Please assign one!" userInfo:nil];
    }
    return mRenderPlugin;
}

- (void)setRenderPlugin:(id<JIRenderPlugin>)renderPlugin
{
    if(renderPlugin == nil)
    {
        [JWCoreUtils destroyObject:mRenderPlugin];
        mRenderPlugin = nil;
        return;
    }
    if(mRenderPlugin != nil)
    {
        @throw [NSException exceptionWithName:@"PluginSystem" reason:[NSString stringWithFormat:@"Render Plugin has been installed [%@].", NSStringFromClass([mRenderPlugin class])] userInfo:nil];
    }
    [renderPlugin onCreate];
    mRenderPlugin = renderPlugin;
}

- (id<JIInputPlugin>)inputPlugin {
    if (mInputPlugin == nil) {
        @throw [NSException exceptionWithName:@"PluginSystem" reason:@"No Input Plugin install. Please assign one!" userInfo:nil];
    }
    return mInputPlugin;
}

- (void)setInputPlugin:(id<JIInputPlugin>)inputPlugin {
    if (inputPlugin == nil) {
        [JWCoreUtils destroyObject:mInputPlugin];
        mInputPlugin = nil;
        return;
    }
    if (mInputPlugin != nil) {
        @throw [NSException exceptionWithName:@"PluginSystem" reason:[NSString stringWithFormat:@"Input Plugin has been installed [%@].", NSStringFromClass([mInputPlugin class])] userInfo:nil];
    }
    [inputPlugin onCreate];
    mInputPlugin = inputPlugin;
}

- (id<JIARPlugin>)arPlugin
{
//    if(mArPlugin == nil)
//    {
//        @throw [NSException exceptionWithName:@"PluginSystem" reason:@"No AR Plugin install. Please assign one!" userInfo:nil];
//    }
    return mArPlugin;
}

- (void)setArPlugin:(id<JIARPlugin>)arPlugin
{
    if(arPlugin == nil)
    {
        [JWCoreUtils destroyObject:mArPlugin];
        mArPlugin = nil;
        return;
    }
    if(mArPlugin != nil)
    {
        @throw [NSException exceptionWithName:@"PluginSystem" reason:[NSString stringWithFormat:@"AR Plugin has been installed [%@].", NSStringFromClass([mArPlugin class])] userInfo:nil];
    }
    [arPlugin onCreate];
    mArPlugin = arPlugin;
}

@end
