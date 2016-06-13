//
//  JWImageCache.h
//  June Winter
//
//  Created by GavinLo on 14-3-5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JWObject.h>
#import <jw/JWFile.h>
#import <jw/JWImageSystem.h>
#import <jw/JWAsyncResult.h>

typedef void (^JWImageCacheOnGetBlock)(UIImage* image);

/**
 * 图片缓存
 */
@protocol JIImageCache <JIObject>

@property (nonatomic, readwrite) NSUInteger sizeOfBytes;

- (UIImage*) getBy:(id)key options:(JWImageOptions*)options;
- (JWAsyncResult*) getBy:(id)key options:(JWImageOptions*)options async:(BOOL)async onGet:(JWImageCacheOnGetBlock)onGet;
- (void) putBy:(id)key image:(UIImage*)image;
- (UIImage*) removeBy:(id)key;
- (UIImage*) queryBy:(id)key;
- (NSUInteger) sizeOf:(UIImage*)image key:(id)key;

- (void) clear;

@end

@interface JWImageCache : JWObject <JIImageCache, NSCacheDelegate>
{
    NSCache* mMemoryCache;
}

+ (id) cache;

@end


/**
 * 简单的本地文件图片缓存实现
 * 这个可能是更好的实现,https://github.com/path/FastImageCache#what-fast-image-cache-does
 * 原理是内存映射和缓存解码后的图片对象,对于小图片比较合适
 */
@interface JWFileImageCache : JWImageCache
{
    NSCache* mFileCache;
}

@end
