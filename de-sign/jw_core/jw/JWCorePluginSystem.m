//
//  JWCorePluginSystem.m
//  June Winter
//
//  Created by GavinLo on 14-3-5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWCorePluginSystem.h"
#import "JWExceptions.h"

static id<JICorePluginSystem> pluginSystem = nil;

@implementation JWCorePluginSystem

+ (id<JICorePluginSystem>)instance
{
    if(pluginSystem == nil)
        pluginSystem = [[JWCorePluginSystem alloc] init];
    return pluginSystem;
}

+ (void)dispose
{
    [pluginSystem onDestroy];
    pluginSystem = nil;
}

- (void)onDestroy
{
    [mImageSystem onDestroy];
    mImageSystem = nil;
}

- (id<JIImageSystem>)imageSystem
{
    if(mImageSystem == nil)
    {
        @throw [JWException exceptionWithName:@"CorePluginSystem" reason:@"No image system install. Please assign to install one!" userInfo:nil];
    }
    return mImageSystem;
}

- (void)setImageSystem:(id<JIImageSystem>)imageSystem
{
    if(imageSystem == nil)
    {
        @throw [JWException exceptionWithName:@"CorePluginSystem" reason:@"Can not install a null image system!!!" userInfo:nil];
    }
    [mImageSystem onDestroy];
    mImageSystem = imageSystem;
    [mImageSystem onCreate];
}

- (id<JIImageCache>)imageCache
{
    if(mImageCache == nil)
    {
        @throw [JWException exceptionWithName:@"CorePluginSystem" reason:@"No image cache install. Please assign to install one!" userInfo:nil];
    }
    return mImageCache;
}

- (void)setImageCache:(id<JIImageCache>)imageCache
{
    if(imageCache == nil)
    {
        @throw [JWException exceptionWithName:@"CorePluginSystem" reason:@"Can not install a null image cache!!!" userInfo:nil];
    }
    [mImageCache onDestroy];
    mImageCache = imageCache;
    [mImageCache onCreate];
}

- (id<JILog>)log
{
    if(mLog == nil)
    {
        @throw [JWException exceptionWithName:@"CorePluginSystem" reason:@"No log install. Please assign to install one!" userInfo:nil];
    }
    return mLog;
}

- (void)setLog:(id<JILog>)log
{
    if(log == nil)
    {
        @throw [JWException exceptionWithName:@"CorePluginSystem" reason:@"Can not install a null log!!!" userInfo:nil];
    }
    [mLog onDestroy];
    mLog = log;
    [mLog onCreate];
}

@end
