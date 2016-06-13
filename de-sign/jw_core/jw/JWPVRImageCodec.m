//
//  JWPVRImageCodec.m
//  jw_core
//
//  Created by GavinLo on 15/4/20.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWPVRImageCodec.h"
#import <jw/JWCoreUtils.h>
#import <jw/JCUtils.h>

#define PVR_TEXTURE_FLAG_TYPE_MASK	0xff

static const char* gPVRTexIdentifier = "PVR!";

enum {
    kPVRTextureFlagTypePVRTC_2 = 24,
    kPVRTextureFlagTypePVRTC_4
};

typedef struct _PVRTexHeader {
    uint32_t headerLength;
    uint32_t height;
    uint32_t width;
    uint32_t numMipmaps;
    uint32_t flags;
    uint32_t dataLength;
    uint32_t bpp;
    uint32_t bitmaskRed;
    uint32_t bitmaskGreen;
    uint32_t bitmaskBlue;
    uint32_t bitmaskAlpha;
    uint32_t pvrTag;
    uint32_t numSurfs;
} PVRTexHeader;

JCImage JCPVRImageForMemory(const JCByte* data, bool holdData) {
    if (data == NULL) {
        return JCImageNull();
    }
    
    PVRTexHeader* header = NULL;
    uint32_t flags, pvrTag;
    uint32_t dataLength = 0, dataOffset = 0, dataSize = 0;
    uint32_t width = 0, height = 0, bpp = 4;
    uint8_t* bytes = NULL;
    uint32_t formatFlags;
    
    header = (PVRTexHeader*)data;
    
    pvrTag = CFSwapInt32LittleToHost(header->pvrTag);
    if (gPVRTexIdentifier[0] != ((pvrTag >>  0) & 0xff) ||
        gPVRTexIdentifier[1] != ((pvrTag >>  8) & 0xff) ||
        gPVRTexIdentifier[2] != ((pvrTag >> 16) & 0xff) ||
        gPVRTexIdentifier[3] != ((pvrTag >> 24) & 0xff)) {
        return JCImageNull();
    }
    
    flags = CFSwapInt32LittleToHost(header->flags);
    formatFlags = flags & PVR_TEXTURE_FLAG_TYPE_MASK;
    
    if (formatFlags == kPVRTextureFlagTypePVRTC_4 || formatFlags == kPVRTextureFlagTypePVRTC_2) {
        
        JCPixelFormat pixelFormat = JCPixelFormat_Unknown;
        if (formatFlags == kPVRTextureFlagTypePVRTC_4) {
            pixelFormat = JCPixelFormat_PVRTC_RGBA4;
        } else if (formatFlags == kPVRTextureFlagTypePVRTC_2) {
            pixelFormat = JCPixelFormat_PVRTC_RGBA2;
        }
        
        width = CFSwapInt32LittleToHost(header->width);
        height = CFSwapInt32LittleToHost(header->height);
        
        //        if (CFSwapInt32LittleToHost(header->bitmaskAlpha))
        //            _hasAlpha = TRUE;
        //        else
        //            _hasAlpha = FALSE;
        
        dataLength = CFSwapInt32LittleToHost(header->dataLength);
        
        bytes = ((uint8_t*)data) + sizeof(PVRTexHeader);
        
        JCImage image = JCImageMake();
        JCUInt index = 0;
        while (dataOffset < dataLength) {
            if (formatFlags == kPVRTextureFlagTypePVRTC_4) {
                bpp = 4;
            } else {
                bpp = 2;
            }
            dataSize = width * height * bpp / 8;
            
            JCByte* bitmapData = bytes + dataOffset;
            if (!holdData) {
                bitmapData = JCMemoryClone(bytes, dataOffset, dataSize, sizeof(JCByte));
            }
            JCBitmap bitmap = JCBitmapMakeWithData(width, height, pixelFormat, bitmapData, dataSize, false);
            JCImageAddBitmap(&image, index++, &bitmap, holdData);
            
            dataOffset += dataSize;
            
            width = MAX(width >> 1, 1);
            height = MAX(height >> 1, 1);
        }
        return image;
    }
    
    return JCImageNull();
}

@implementation JWPVRImageCodec

- (NSArray *)patterns {
    return @[
             @"[\\w\\W]*.[pP][vV][rR]",
             @"[\\w\\W]*.[pP][vV][rR][tT][cC]",
             ];
}

- (JCImage)decodeFile:(id<JIFile>)file withOptions:(JWImageOptions *)options {
    NSData* fileData = file.data;
    return JCPVRImageForMemory(fileData.bytes, false);
}

@end
