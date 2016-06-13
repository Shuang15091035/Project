//
//  CCVImage.m
//  ctrlcv_core
//
//  Created by ddeyes on 16/3/10.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "CCVImage.h"

@interface CCVBitmap () {
    CCCBitmap mBitmap;
}

@end

@implementation CCVBitmap

+ (id)bitmapWithWidth:(NSInteger)width height:(NSInteger)height {
    return [[self alloc] initWithWidth:width height:height];
}

+ (id)bitmapWithWidth:(NSInteger)width height:(NSInteger)height pixelFormat:(CCCPixelFormat)pixelFormat data:(CCCByte *)data dataLength:(NSUInteger)dataLength {
    return [[self alloc] initWithWidth:width height:height pixelFormat:pixelFormat data:data dataLength:dataLength];
}

- (id)initWithWidth:(NSInteger)width height:(NSInteger)height {
    self = [super init];
    if (self != nil) {
        mBitmap = CCCBitmapMake((CCCInt)width, (CCCInt)height);
    }
    return self;
}

- (id)initWithWidth:(NSInteger)width height:(NSInteger)height pixelFormat:(CCCPixelFormat)pixelFormat data:(CCCByte *)data dataLength:(NSUInteger)dataLength {
    self = [super init];
    if (self != nil) {
        //mBitmap = CCCBitmapMakeWithData((CCCInt)width, (CCCInt)height, pixelFormat, data, dataLength);
    }
    return self;
}

- (NSInteger)width  {
    return mBitmap.width;
}

- (void)setWidth:(NSInteger)width {
    mBitmap.width = (CCCInt)width;
}

- (NSInteger)height {
    return mBitmap.height;
}

- (void)setHeight:(NSInteger)height {
    mBitmap.height = (CCCInt)height;
}

- (CCCPixelFormat)pixelFormat {
    return mBitmap.pixelFormat;
}

- (void)setPixelFormat:(CCCPixelFormat)pixelFormat {
    mBitmap.pixelFormat = pixelFormat;
}

- (CCCBufferRef)data {
    return &mBitmap.data;
}

- (void)setData:(CCCBufferRef)data {
    CCCBufferShallowCopy(&mBitmap.data, data);
}

@end

@interface CCVImage () {
    CCVBitmap* mMainBitmap;
    NSMutableArray<CCVBitmap*>* mBitmaps;
}

@end

@implementation CCVImage

+ (id)image {
    return [[self alloc] init];
}

- (CCVBitmap *)mainBitmap {
    return mMainBitmap;
}

- (void)setMainBitmap:(CCVBitmap *)mainBitmap {
    mMainBitmap = mainBitmap;
}

- (void)addBitmap:(CCVBitmap *)bitmap {
    if (bitmap == nil) {
        return;
    }
    if (mMainBitmap == nil) {
        mMainBitmap = bitmap;
        return;
    }
    if (bitmap == mMainBitmap) {
        return;
    }
    if (mBitmaps == nil) {
        mBitmaps = [NSMutableArray array];
    }
    [mBitmaps addObject:bitmap];
}

- (void)enumBitmapUsing:(void (^)(CCVBitmap *, NSUInteger, BOOL *))block {
    if (mMainBitmap == nil) {
        return;
    }
    BOOL stop = NO;
    block(mMainBitmap, 0, &stop);
    if (stop) {
        return;
    }
    if (mBitmaps != nil) {
        [mBitmaps enumerateObjectsUsingBlock:^(CCVBitmap * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            block(obj, idx + 1, stop);
        }];
    }
}

@end
