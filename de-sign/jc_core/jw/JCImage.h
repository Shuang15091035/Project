//
//  JCImage.h
//  June Winter
//
//  Created by GavinLo on 16/3/10.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCImage__
#define __jw__JCImage__

#include <jw/JCBase.h>
#include <jw/JCBitmap.h>

JC_BEGIN

typedef enum {
    
    JCImageMaxNumBitmaps = 16,
    
}JCImageConstants;

typedef struct {
    
    JCInt width;
    JCInt height;
    JCPixelFormat pixelFormat;
    JCBitmap bitmaps[JCImageMaxNumBitmaps];
    JCUInt numBitmaps;
    
}JCImage;

typedef JCImage* JCImageRef;
typedef const JCImage* JCImageRefC;

JCImage JCImageNull();
JCImage JCImageMake();
//void JCImageInit(JCImageRef image);
void JCImageFree(JCImageRef image);
bool JCImageAddBitmap(JCImageRef image, JCUInt index, JCBitmapRefC bitmap, bool holdBitmap);
JCBitmapRefC JCImageGetBitmap(JCImageRefC image, JCUInt index);
JCBitmapRefC JCImageMainBitmap(JCImageRefC image);
void JCImageArrangeBitmaps(JCImageRef image);
JCUInt JCImageGetNumBitmaps(JCImageRefC image);
JCULong JCImageGetSizeInMemory(JCImageRefC image);
bool JCImageIsNull(JCImageRefC image);
void JCImageShallowCopy(JCImageRefC from, JCImageRef to);

JC_END

#endif /* defined(__jw__JCImage__) */
