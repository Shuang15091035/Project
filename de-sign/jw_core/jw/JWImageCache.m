//
//  JWImageCache.m
//  June Winter
//
//  Created by GavinLo on 14-3-5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWImageCache.h"
#import "JWImageCacheGetAsyncTask.h"
#import "JWCoreUtils.h"
#import "JWCorePluginSystem.h"

@implementation JWImageCache

+ (id)cache
{
    return [[JWImageCache alloc] init];
}

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        mMemoryCache = [[NSCache alloc] init];
        //mMemoryCache.totalCostLimit = 5 * 1024 * 1024;
    }
    return self;
}

- (void)dealloc
{
    [mMemoryCache removeAllObjects];
    mMemoryCache = nil;
}

- (NSUInteger)sizeOfBytes
{
    return mMemoryCache.totalCostLimit;
}

- (void)setSizeOfBytes:(NSUInteger)sizeOfBytes
{
    mMemoryCache.totalCostLimit = sizeOfBytes;
}

- (UIImage *)getBy:(id)key options:(JWImageOptions *)options
{
    return [self getBy:key options:options async:NO onGet:nil].syncResult;
}

- (JWAsyncResult *)getBy:(id)key options:(JWImageOptions *)options async:(BOOL)async onGet:(JWImageCacheOnGetBlock)onGet
{
    JWAsyncResult* result = [JWAsyncResult result];
    JWImageCacheGetAsyncTask* task = [JWImageCacheGetAsyncTask taskWithImageCache:self key:key options:options onImageCacheGet:onGet];
    if(!async)
    {
        [task onPreExecute];
        if(task.isCancelled)
        {
            result.syncResult = task.resultImage;
            return result;
        }
        UIImage* image = [task doInBackground:nil];
        [task onPostExecute:image];
        result.syncResult = image;
    }
    else
    {
        [task execute:nil];
        result.syncResult = nil;
    }
    return result;
}

- (void)putBy:(id)key image:(UIImage *)image
{
    [mMemoryCache setObject:image forKey:key cost:[self sizeOf:image key:key]];
}

- (UIImage *)removeBy:(id)key
{
    UIImage* image = [mMemoryCache objectForKey:key];
    [mMemoryCache removeObjectForKey:key];
    return image;
}

- (UIImage *)queryBy:(id)key
{
    UIImage* image = [mMemoryCache objectForKey:key];
    return image;
}

- (NSUInteger)sizeOf:(UIImage *)image key:(id)key
{
    return [[JWCorePluginSystem instance].imageSystem sizeOf:image];
}

- (void)clear
{
    [mMemoryCache removeAllObjects];
}

- (void)cache:(NSCache *)cache willEvictObject:(id)obj
{
    NSLog(@"evict %@", obj);
}

@end

@implementation JWFileImageCache

- (void)dealloc
{
    [mFileCache removeAllObjects];
    mFileCache = nil;
}

- (void)putBy:(id)key image:(UIImage *)image
{
    // TODO
    [super putBy:key image:image];
}

- (UIImage *)removeBy:(id)key
{
    UIImage* image = [super removeBy:key];
    // TODO
    return image;
}

- (UIImage *)queryBy:(id)key
{
    UIImage* image = [super queryBy:key];
    // TODO
    return image;
}

- (void)clear
{
    // TODO
    [super clear];
}

@end
