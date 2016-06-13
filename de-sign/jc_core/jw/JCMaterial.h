//
//  JCMaterial.h
//  June Winter
//
//  Created by GavinLo on 14/10/20.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCMaterial__
#define __jw__JCMaterial__

#include <jw/JCBase.h>
#include <jw/JCFlags.h>
#include <jw/JCColor.h>
#include <jw/JCTexture.h>

JC_BEGIN

typedef enum {
    
    JCBlendFactorOne,
    JCBlendFactorZero,
    JCBlendFactorDstColor,
    JCBlendFactorSrcColor,
    JCBlendFactorOneMinusDstColor,
    JCBlendFactorOneMinusSrcColor,
    JCBlendFactorDstAlpha,
    JCBlendFactorSrcAlpha,
    JCBlendFactorOneMinusDstAlpha,
    JCBlendFactorOneMinusSrcAlpha,
    
    JCBlendFactorSrcDefault = JCBlendFactorOne,
    JCBlendFactorDstDefault = JCBlendFactorZero,
    
}JCBlendFactor;

typedef enum {
    
    JCDepthFuncNever,
    JCDepthFuncEqual,
    JCDepthFuncNotEqual,
    JCDepthFuncLess,
    JCDepthFuncLessEqual,
    JCDepthFuncGreater,
    JCDepthFuncGreaterEqual,
    JCDepthFuncAlways,
    
    JCDepthFuncDefault = JCDepthFuncLess,
    
}JCDepthFunc;

typedef enum {
    
    JCCullFaceNone,
    JCCullFaceBack,
    JCCullFaceFront,
    JCCullFaceFrontAndBack,
    
    JCCullFaceDefault = JCCullFaceBack,
    
}JCCullFace;

typedef enum {
    
    JCColorTypeUnknown = 0,
    JCColorTypeDiffuse,
    JCColorTypeLightmap,
    JCColorTypeSpecular,
    JCColorTypeEmissive,
    JCColorTypeTransparent,
    
}JCColorType;

/**
 * 内置的shader类型
 */
typedef enum {
    
    JCMaterialShaderUnknown = 0,
    JCMaterialShaderConstant,
    JCMaterialShaderLambert,
    JCMaterialShaderPhong,
    JCMaterialShaderBlinn,
    JCMaterialShaderCustom,
    
}JCMaterialShader;

typedef struct {
    
    JCColorType type;
    JCColor color;
    
}JCMaterialColorRef;

JCMaterialColorRef JCMaterialColorRefMake(JCColorType type, JCColor color);

typedef struct {
    
    JCMaterialShader shader;
    
    bool isBlending;
    JCBlendFactor srcBlend;
    JCBlendFactor dstBlend;
    bool isDepthCheck;
    bool isDepthWrite;
    JCDepthFunc depthFunc;
    JCCullFace cullFace;
    
    JCMaterialColorRef diffuseColor;
    JCMaterialColorRef lightmapColor;
    JCMaterialColorRef specularColor;
    JCMaterialColorRef emissiveColor;
    
    JCMaterialTextureRef texture[JCTextureTypeCount];
//    JCMaterialTextureRef diffuseTexture;
//    JCMaterialTextureRef lightmapTexture;
//    JCMaterialTextureRef specularTexture;
//    JCMaterialTextureRef reflectiveTexture;
//    JCMaterialTextureRef normalTexture;
//    JCMaterialTextureRef alphaTexture;
    short texcoordSet;
    
    float shininess;
    
    bool isTransparent;
    JCMaterialColorRef transparentColor;
    float transparency;
    
    // ambient occlusion
    //JCMaterialTextureRef aoTexture;
    
    // 菲尼尔反射
    JCColor rimColor;
    float rimPower;
    
    // 视频YUV
//    JCMaterialTextureRef videoYTexture;
//    JCMaterialTextureRef videoUVTexture;
    
    // 描边
    JCColor outlineColor;
    float outlineWidth;
    
}JCMaterial;

typedef JCMaterial* JCMaterialRef;
typedef const JCMaterial* JCMaterialRefC;

JCMaterial JCMaterialMake();
void JCMaterialSetBlending(JCMaterialRef material, JCBlendFactor srcBlend, JCBlendFactor dstBlend);
void JCMaterialClearBlending(JCMaterialRef material);
void JCMaterialSetColor(JCMaterialRef material, JCColorType type, JCColor color);
void JCMaterialSetTexture(JCMaterialRef material, JCTextureType type, JCTexture* texture);
JCBool JCMaterialHasRim(JCMaterialRefC material);
JCBool JCMaterialHasOutline(JCMaterialRefC material);

/**
 * 材质特征
 */
typedef enum {
    
    JCMaterialFlagOffsetColorDiffuse = 0,
    JCMaterialFlagOffsetColorLightmap,
    JCMaterialFlagOffsetColorSpecular,
    JCMaterialFlagOffsetColorEmissive,
    
    JCMaterialFlagOffsetTextureAny = 0, // 具有任何一种texture
    JCMaterialFlagOffsetTextureDiffuse,
    JCMaterialFlagOffsetTextureLightmap,
    JCMaterialFlagOffsetTextureSpecular,
    JCMaterialFlagOffsetTextureReflective,
    JCMaterialFlagOffsetTextureNormal,
    JCMaterialFlagOffsetTextureAlpha,
    JCMaterialFlagOffsetTextureAO,
    
    JCMaterialFlagOffsetTextureVideo,
    
    JCMaterialFlagOffsetRim = 0,
    JCMaterialFlagOffsetOutline,
    
}JCMaterialFlagOffsets;

typedef enum {
    
    JCMaterialFlagColorDiffuse         = 0x1 << JCMaterialFlagOffsetColorDiffuse,
    JCMaterialFlagColorLightmap        = 0x1 << JCMaterialFlagOffsetColorLightmap,
    JCMaterialFlagColorSpecular        = 0x1 << JCMaterialFlagOffsetColorSpecular,
    JCMaterialFlagColorEmissive        = 0x1 << JCMaterialFlagOffsetColorEmissive,
    
    JCMaterialFlagTextureAny           = 0x1 << JCMaterialFlagOffsetTextureAny,
    JCMaterialFlagTextureDiffuse       = 0x1 << JCMaterialFlagOffsetTextureDiffuse,
    JCMaterialFlagTextureLightmap      = 0x1 << JCMaterialFlagOffsetTextureLightmap,
    JCMaterialFlagTextureSpecular      = 0x1 << JCMaterialFlagOffsetTextureSpecular,
    JCMaterialFlagTextureReflective    = 0x1 << JCMaterialFlagOffsetTextureReflective,
    JCMaterialFlagTextureNormal        = 0x1 << JCMaterialFlagOffsetTextureNormal,
    JCMaterialFlagTextureAlpha         = 0x1 << JCMaterialFlagOffsetTextureAlpha,
    JCMaterialFlagTextureAO            = 0x1 << JCMaterialFlagOffsetTextureAO,
    
    JCMaterialFlagTextureVideo            = 0x1 << JCMaterialFlagOffsetTextureVideo,
    
    JCMaterialFlagRim                  = 0x1 << JCMaterialFlagOffsetRim,
    JCMaterialFlagOutline            = 0x1 << JCMaterialFlagOffsetOutline,
    
}JCMaterialFlags;

typedef struct {
    
    JCFlag colorFlags;
    JCFlag textureFlags;
    JCFlag otherFlags;
    
}JCMaterialFeatures;

JCMaterialFeatures JCMaterialFeaturesMake();
JCMaterialFeatures JCMaterialFeaturesMakeByMaterial(JCMaterialRefC material);
JCBool JCMaterialFeaturesEquals(const JCMaterialFeatures* l, const JCMaterialFeatures* r);

JC_END

#endif /* defined(__jw__JCMaterial__) */
