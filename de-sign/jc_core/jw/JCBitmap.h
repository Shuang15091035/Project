//
//  JCBitmap.h
//  June Winter
//
//  Created by GavinLo on 14/11/3.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCBitmap__
#define __jw__JCBitmap__

#include <jw/JCBase.h>
#include <jw/JCBuffer.h>
#include <jw/JCPixelFormat.h>

JC_BEGIN

typedef struct {
    
    JCInt width;
    JCInt height;
    JCPixelFormat pixelFormat;
    JCBuffer data;
    
}JCBitmap;

typedef JCBitmap* JCBitmapRef;
typedef const JCBitmap* JCBitmapRefC;

JCBitmap JCBitmapMake(JCInt width, JCInt height);
JCBitmap JCBitmapMakeWithData(JCInt width, JCInt height, JCPixelFormat pixelFormat, JCByte* data, JCULong dataLength, bool holdData);
void JCBitmapFree(JCBitmapRef bitmap);
void JCBitmapReference(JCBitmapRef dst, JCBitmapRefC src);
void JCBitmapAssign(JCBitmapRef dst, JCBitmapRef src);
unsigned long JCBitmapGetSizeInMemory(JCBitmapRefC bitmap);
JCBitmap JCBitmapNull();
bool JCBitmapIsNull(JCBitmapRefC bitmap);
void JCBitmapSetNull(JCBitmapRef bitmap);

JC_END

#endif /* defined(__jw__JCBitmap__) */
