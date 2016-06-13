//
//  JCTexture.h
//  June Winter
//
//  Created by GavinLo on 14/10/29.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCTexture__
#define __jw__JCTexture__

#include <jw/JCBase.h>
#include <jw/JCTilingOffset.h>
#include <jw/JCImage.h>
#include <jw/JCColor.h>

JC_BEGIN

#define JCTextureInvalidId 0

typedef enum {
    
    JCTextureTypeUnknown = -1,
    JCTextureTypeDiffuse = 0,
    JCTextureTypeLightmap,
    JCTextureTypeSpecular,
    JCTextureTypeReflective,
    JCTextureTypeBump,
    JCTextureTypeAlpha,
    JCTextureTypeAO,
    
    // 视频YUV
    JCTextureTypeVideoY,
    JCTextureTypeVideoUV,
    
    JCTextureTypeCount,
    
}JCTextureType;

typedef enum {
    
    JCTextureTargetUnknown = -1,
    JCTextureTarget2D = 0,
    
}JCTextureTarget;

typedef enum {
    
    JCTextureFilterNone = 0,
    JCTextureFilterPoint,
    JCTextureFilterLinear,
    
}JCTextureFilter;

typedef struct {
    
    JCTextureTarget target;
    unsigned int textureId;
    
    JCImage image;
    JCTilingOffset st;
    JCTextureFilter minFilter;
    JCTextureFilter magFilter;
    JCTextureFilter mipFilter;
    
}JCTexture;

typedef JCTexture* JCTextureRef;
typedef const JCTexture* JCTextureRefC;

JCTexture JCTextureMake();
void JCTextureFree(JCTextureRef texture);
void JCTextureInvalid(JCTextureRef texture);
void JCTextureShallowCopy(JCTextureRefC from, JCTextureRef to);

/** 
 * 检查纹理是否为标准纹理（长宽相等并且为2的n次幂，检查所有mipmap层级）
 */
bool JCTextureIsStandard(JCTextureRefC texture);
bool JCTextureHasFullMipmapChain(JCTextureRefC texture);

typedef struct {
    
    JCTextureType type;
    JCTexture* texture;
    float amount;
    
}JCMaterialTextureRef;

JCMaterialTextureRef JCMaterialTextureRefMake(JCTextureType type, JCTexture* texture);

//typedef struct
//{
//    JCTextureRef texture;
//    JCColor color;
//    bool isTextureOrColor;
//    
//}JCTextureOrColor;
//
//JCTextureOrColor JCMaterialTexture(JCTextureRef texture);
//JCTextureOrColor JCMaterialColor(JCColor color);

JC_END

#endif /* defined(__jw__JCTexture__) */
