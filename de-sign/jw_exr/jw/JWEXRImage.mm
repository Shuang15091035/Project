//
//  JWEXRImage.mm
//  June Winter
//
//  Created by ddeyes on 15/11/24.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWEXRImage.h"

#import <jw/JCHalf.h>
#define TINYEXR_IMPLEMENTATION
#include "tinyexr.h"

JCBitmap JCLoadEXRFromMemory(const JCByte* memory) {
    JCBitmap bitmap = JCBitmapNull();
    if (memory == NULL) {
        return bitmap;
    }

    // 读取exr数据
    EXRImage exrImage;
    InitEXRImage(&exrImage);
    const char* err = NULL;
    if (ParseMultiChannelEXRHeaderFromMemory(&exrImage, memory, &err) != 0) {
        return bitmap;
    }
    // Uncomment if you want reading HALF image as FLOAT.
//    for (int i = 0; i < exrImage.num_channels; i++) {
//      if (exrImage.pixel_types[i] == TINYEXR_PIXELTYPE_HALF) {
//        exrImage.requested_pixel_types[i] = TINYEXR_PIXELTYPE_FLOAT;
//      }
//    }
    if (LoadMultiChannelEXRFromMemory(&exrImage, memory, &err) != 0) {
        return bitmap;
    }
    
    // 寻找RGBA通道，确定PixelFormat
    int idxR = -1;
    int idxG = -1;
    int idxB = -1;
    int idxA = -1;
    int bytesPerPixel = 0;
    for (int c = 0; c < exrImage.num_channels; c++) {
        if (strcmp(exrImage.channel_names[c], "R") == 0) {
            idxR = c;
            if (exrImage.pixel_types[c] == TINYEXR_PIXELTYPE_HALF) {
                bytesPerPixel += sizeof(unsigned short);
            }
        } else if (strcmp(exrImage.channel_names[c], "G") == 0) {
            idxG = c;
            if (exrImage.pixel_types[c] == TINYEXR_PIXELTYPE_HALF) {
                bytesPerPixel += sizeof(unsigned short);
            }
        } else if (strcmp(exrImage.channel_names[c], "B") == 0) {
            idxB = c;
            if (exrImage.pixel_types[c] == TINYEXR_PIXELTYPE_HALF) {
                bytesPerPixel += sizeof(unsigned short);
            }
        } else if (strcmp(exrImage.channel_names[c], "A") == 0) {
            idxA = c;
            if (exrImage.pixel_types[c] == TINYEXR_PIXELTYPE_HALF) {
                bytesPerPixel += sizeof(unsigned short);
            }
        }
    }
    if (bytesPerPixel != 8) { // TODO 暂只支持半浮点格式
        FreeEXRImage(&exrImage);
        return bitmap;
    }
    if (idxR < 0 || idxG < 0 || idxB < 0) {
        FreeEXRImage(&exrImage);
        return bitmap;
    }
    int width = exrImage.width;
    int height = exrImage.height;
    int size = width * height;
    JCPixelFormat pixelFormat = JCPixelFormat_RGBAf16; // 默认使用4通道
    int capacity = size * 4 * bytesPerPixel;

    bitmap.width = width;
    bitmap.height = height;
    bitmap.pixelFormat = pixelFormat;
    bitmap.data = JCBufferMake();
    JCBufferAlloc(&bitmap.data, capacity);
    
    unsigned short* data = (unsigned short*)bitmap.data.data;
    unsigned short** exrData = (unsigned short**)exrImage.images;
    for (int i = 0; i < size; i++) {
        data[4 * i + 0] = exrData[idxR][i];
        data[4 * i + 1] = exrData[idxG][i];
        data[4 * i + 2] = exrData[idxB][i];
        data[4 * i + 3] = idxA < 0 ? JCHalfOne().u : exrData[idxA][i];
    }
    bitmap.data.size = capacity;
    return bitmap;
}

@interface JWEXRImage () {
    id<JIFile> mFile;
    JCBitmap mBitmap;
}

@end

@implementation JWEXRImage

- (void)onDestroy {
    mFile = nil;
    JCBitmapFree(&mBitmap);
    [super onDestroy];
}

@synthesize file = mFile;
@synthesize bitmap = mBitmap;

- (BOOL)loadFile:(id<JIFile>)file {
    if (file == nil) {
        return NO;
    }
    NSData* data = file.data;
    if (data == nil) {
        return NO;
    }
    mBitmap = JCLoadEXRFromMemory((const JCByte*)data.bytes);
    if (JCBitmapIsNull(&mBitmap)) {
        return NO;
    }
    mFile = file;
    return YES;
}

@end
