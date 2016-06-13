//
//  JWImageCacheGetAsyncTask.h
//  June Winter
//
//  Created by GavinLo on 14-3-5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWAsyncTask.h>
#import <jw/JWImageSystem.h>
#import <jw/JWImageCache.h>

@interface JWImageCacheGetAsyncTask : JWAsyncTask

@property (nonatomic, readwrite) id<JIImageCache> imageCache;
@property (nonatomic, readwrite) id key;
@property (nonatomic, readwrite) JWImageOptions* options;
@property (nonatomic, readwrite) JWImageCacheOnGetBlock onImageCacheGet;
@property (nonatomic, readwrite) UIImage* resultImage;

- (id) initWithImageCache:(id<JIImageCache>)imageCache key:(id)key options:(JWImageOptions*)options onImageCacheGet:(JWImageCacheOnGetBlock)onImageCacheGet;
+ (id) taskWithImageCache:(id<JIImageCache>)imageCache key:(id)key options:(JWImageOptions*)options onImageCacheGet:(JWImageCacheOnGetBlock)onImageCacheGet;

@end
