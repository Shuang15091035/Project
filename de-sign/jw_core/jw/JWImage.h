//
//  CCVImage.h
//  ctrlcv_core
//
//  Created by ddeyes on 16/3/10.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <ctrlcv/CCVObject.h>
#import <ctrlcv/CCCBitmap.h>

@interface CCVBitmap : CCVObject

+ (id)bitmapWithWidth:(NSInteger)width height:(NSInteger)height;
+ (id)bitmapWithWidth:(NSInteger)width height:(NSInteger)height pixelFormat:(CCCPixelFormat)pixelFormat data:(CCCByte*)data dataLength:(NSUInteger)dataLength;
- (id)initWithWidth:(NSInteger)width height:(NSInteger)height;
- (id)initWithWidth:(NSInteger)width height:(NSInteger)height pixelFormat:(CCCPixelFormat)pixelFormat data:(CCCByte*)data dataLength:(NSUInteger)dataLength;

@property (nonatomic, readwrite) NSInteger width;
@property (nonatomic, readwrite) NSInteger height;
@property (nonatomic, readwrite) CCCPixelFormat pixelFormat;
@property (nonatomic, readwrite) CCCBufferRef data;

@end

@protocol ICVImage <ICVObject>

@property (nonatomic, readwrite) CCVBitmap* mainBitmap;
- (void) addBitmap:(CCVBitmap*)bitmap;
//- (void) addBitmap:(CCVBitmap*)bitmap forIndex:(NSUInteger)index;
//- (void) removeBitmapAtIndex:(NSUInteger)index;
//- (void) getBitmapAtIndex:(NSUInteger)index;
- (void) enumBitmapUsing:(void (^)(CCVBitmap* bitmap, NSUInteger idx, BOOL* stop))block;

@end

@interface CCVImage : CCVObject <ICVImage>

+ (id)image;

@end
