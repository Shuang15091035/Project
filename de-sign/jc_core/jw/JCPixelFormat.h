//
//  JCPixelFormat.h
//  June Winter
//
//  Created by GavinLo on 14/12/8.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCPixelFormat__
#define __jw__JCPixelFormat__

#include <jw/JCBase.h>

JC_BEGIN

typedef enum {
    JCPixelFormat_Unknown,
    JCPixelFormat_L8,
    JCPixelFormat_L16,
    JCPixelFormat_LA,
    JCPixelFormat_A8,
    JCPixelFormat_RGB565,
    JCPixelFormat_RGBA5551,
    JCPixelFormat_RGB888,
    JCPixelFormat_RGBX8888,
    JCPixelFormat_RGBA8888,
    JCPixelFormat_RGBA16, // 单通道16位，总64位
    JCPixelFormat_RGBAf16, // 单通道半浮点
    
    // RGB with premultiplied alpha，这种格式的图片，在alpha混合是需要设置为(One, OneMinusSrcAlpha)，
    // 避免alpha重复乘以RGB值而导致效果不正确
    JCPixelFormat_RGBpA8888,
    
    JCPixelFormat_ARGB8888,
    JCPixelFormat_PVRTC_RGBA4,
    JCPixelFormat_PVRTC_RGBA2,
    
    // video
    JCPixelFormat_VideoY,
    JCPixelFormat_VideoUV,
    
}JCPixelFormat;

bool JCPixelFormatHasPremultipliedAlpha(JCPixelFormat pixelFormat);
bool JCPixelFormatIsPVRTC(JCPixelFormat pixelFormat);

JC_END

#endif /* defined(__jw__JCPixelFormat__) */
