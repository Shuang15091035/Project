//
//  JWImageCacheGetAsyncTask.m
//  June Winter
//
//  Created by GavinLo on 14-3-5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWImageCacheGetAsyncTask.h"
#import "JWCorePluginSystem.h"

@interface JWImageCacheGetAsyncTask ()
{
    JWImageCacheOnGetBlock mOnImageCacheGet;
}

@end

@implementation JWImageCacheGetAsyncTask

@synthesize imageCache = mImageCache;
@synthesize key = mKey;
@synthesize options = mOptions;

- (JWImageCacheOnGetBlock)onImageCacheGet
{
    return mOnImageCacheGet;
}

- (void)setOnImageCacheGet:(JWImageCacheOnGetBlock)onImageCacheGet
{
    mOnImageCacheGet = onImageCacheGet;
}

@synthesize resultImage = mResultImage;

- (id)initWithImageCache:(id<JIImageCache>)imageCache key:(id)key options:(JWImageOptions *)options onImageCacheGet:(JWImageCacheOnGetBlock)onImageCacheGet
{
    self = [super init];
    if(self != nil)
    {
        mImageCache = imageCache;
        mKey = key;
        mOptions = options;
        mOnImageCacheGet = onImageCacheGet;
    }
    return self;
}

+ (id)taskWithImageCache:(id<JIImageCache>)imageCache key:(id)key options:(JWImageOptions *)options onImageCacheGet:(JWImageCacheOnGetBlock)onImageCacheGet
{
    return [[JWImageCacheGetAsyncTask alloc] initWithImageCache:imageCache key:key options:options onImageCacheGet:onImageCacheGet];
}

- (void)onPreExecute
{
    if(mKey == nil)
    {
        [self cancel];
        return;
    }
    
    UIImage* image = [mImageCache queryBy:mKey];
    if(image != nil)
    {
        mResultImage = image;
        if(mOnImageCacheGet != nil)
            mOnImageCacheGet(image);
        [self cancel];
    }
}

- (id)doInBackground:(NSArray *)params
{
    UIImage* image = [[JWCorePluginSystem instance].imageSystem decodeFile:mKey options:mOptions];
    if(image != nil)
        [mImageCache putBy:mKey image:image];
    return image;
}

- (void)onPostExecute:(id)result
{
    if(result != nil)
    {
        if(mOnImageCacheGet != nil)
            mOnImageCacheGet(result);
    }
}

@end
