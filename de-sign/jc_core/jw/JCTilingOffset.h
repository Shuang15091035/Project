//
//  JCTilingOffset.h
//  June Winter
//
//  Created by GavinLo on 16/1/18.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCTilingOffset__
#define __jw__JCTilingOffset__

#include <jw/JCBase.h>
#include <jw/JCVector2.h>
#include <jw/JCVector4.h>

JC_BEGIN

typedef struct {
    
    JCVector2 tiling;
    JCVector2 offset;
    
}JCTilingOffset;

typedef union {
    
    JCTilingOffset tilingOffset;
    JCVector4 vector;
    
}JCTilingOffsetv;

typedef JCTilingOffset* JCTilingOffsetRef;
typedef const JCTilingOffset* JCTilingOffsetRefC;

JCTilingOffset JCTilingOffsetDefault();

JCTilingOffset JCTilingOffsetMake(JCFloat tilingX, JCFloat tilingY, JCFloat offsetX, JCFloat offsetY);
void JCTilingOffsetSet(JCTilingOffsetRef to, JCTilingOffsetRefC other);
void JCTilingOffsetSetf(JCTilingOffsetRef to, JCFloat tilingX, JCFloat tilingY, JCFloat offsetX, JCFloat offsetY);
bool JCTilingOffsetEquals(JCTilingOffsetRefC lto, JCTilingOffsetRefC rto);
bool JCTilingOffsetIsDefault(JCTilingOffsetRefC to);
JCVector4 JCTilingOffsetToVector4(JCTilingOffset to);
JCTilingOffset JCTilingOffsetFromVector4(JCVector4 v);

JC_END

#endif /* defined(__jw__JCTilingOffset__) */
