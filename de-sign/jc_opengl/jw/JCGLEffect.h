//
//  JCGLEffect.h
//  June Winter
//
//  Created by GavinLo on 14/10/21.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCGLEffect__
#define __jw__JCGLEffect__

#include <jw/JCBase.h>

#include <jw/JCGLAttribute.h>
#include <jw/JCGLUniform.h>
#include <jw/JCMatrix4.h>
#include <jw/JCMesh.h>
#include <jw/JCCamera.h>
#include <jw/JCMaterial.h>
#include <jw/JCLight.h>
#include <jw/JCSkeleton.h>
#include <jw/JCVertex3.h>
#include <jw/JCStretch.h>

JC_BEGIN

#define JCSpotLightMaxCount 8

typedef struct {
    
    unsigned int lightId;
    JCGLUniform position;
    JCGLUniform direction;
    JCGLUniform cutoff;
    
}JCGLEffectSpotLight;

JCGLEffectSpotLight JCGLEffectSpotLightMake(unsigned int lightId);
void JCGLEffectSpotLightInit(JCGLEffectSpotLight* effect);
bool JCGLEffectSpotLightSetup(JCGLEffectSpotLight* effect, const JCGLProgram* program);
bool JCGLEffectSpotLightApply(const JCGLEffectSpotLight* effect, JCSpotLight spotLight);

typedef struct {
    
    JCGLUniform position;
    
}JCGLEffectCamera;

JCGLEffectCamera JCGLEffectCameraMake();
void JCGLEffectCameraInit(JCGLEffectCamera* effect);
bool JCGLEffectCameraSetup(JCGLEffectCamera* effect, const JCGLProgram* program);
bool JCGLEffectCameraApply(const JCGLEffectCamera* effect, JCCameraRefC camera);

#define JCGLEffectTextureNameMaxLength 16

typedef struct {
    
    //char name[JCGLEffectTextureNameMaxLength];
    JCGLUniform texture;
    JCGLUniform tilingOffset;
    JCGLUniform size;
    
}JCGLEffectTexture;

JCGLEffectTexture JCGLEffectTextureMake();
void JCGLEffectTextureInit(JCGLEffectTexture* effect, const char* name);
bool JCGLEffectTextureSetup(JCGLEffectTexture* effect, const JCGLProgram* program);
bool JCGLEffectTextureApply(const JCGLEffectTexture* effect, JCMaterialTextureRef texture);

typedef struct {
    
    JCGLUniform diffuseColor;
    JCGLUniform lightmapColor;
    JCGLUniform specularColor;
    JCGLUniform emissiveColor;
    JCGLEffectTexture diffuseTexture;
    JCGLUniform lightmapTexture;
    JCGLUniform specularTexture;
    JCGLUniform reflectiveTexture;
    JCGLUniform reflectiveAmount;
    JCGLEffectTexture normalTexture;
    JCGLEffectTexture alphaTexture;
    JCGLUniform shininess;
    //JCGLUniform transparent;
    JCGLUniform transparentColor;
    JCGLUniform transparency;
    
    // ambient occlusion
    JCGLEffectTexture aoTexture;
    
    // 菲尼尔反射
    JCGLUniform rimColor;
    JCGLUniform rimPower;
    
    // 视频YUV
    JCGLUniform videoYTexture;
    JCGLUniform videoUVTexture;
    JCGLUniform videoTilingOffset;
    JCGLUniform videoSize;
    
    // 描边
    JCGLUniform outlineColor;
    JCGLUniform outlineWidth;
    
}JCGLEffectMaterial;

JCGLEffectMaterial JCGLEffectMaterialMake();
void JCGLEffectMaterialInit(JCGLEffectMaterial* effect);
bool JCGLEffectMaterialSetup(JCGLEffectMaterial* effect, const JCGLProgram* program);
bool JCGLEffectMaterialApply(const JCGLEffectMaterial* effect, JCMaterialRefC material);

typedef struct {
    
    JCGLAttribute boneWeights[JCMaxBonesPreVertex];
    JCGLUniform bones;
    
}JCGLEffectSkeleton;

JCGLEffectSkeleton JCGLEffectSkeletonMake();
void JCGLEffectSkeletonInit(JCGLEffectSkeleton* effect);
bool JCGLEffectSkeletonSetup(JCGLEffectSkeleton* effect, const JCGLProgram* program);
bool JCGLEffectSkeletonApply(const JCGLEffectSkeleton* effect, JCSkeletonRefC skeleton);

typedef struct {
    
    JCGLUniform stretchPivot;
    JCGLUniform stretch;
    
}JCGLEffectStretch;

JCGLEffectStretch JCGLEffectStretchMake();
void JCGLEffectStretchInit(JCGLEffectStretch* effect);
bool JCGLEffectStretchSetup(JCGLEffectStretch* effect, const JCGLProgram* program);
bool JCGLEffectStretchApply(const JCGLEffectStretch* effect, JCStretch stretch);

typedef struct {
    
    JCGLProgram program;
    
    JCGLAttribute position;
    JCGLAttribute normal;
    JCGLAttribute tangent;
    JCGLAttribute binormal;
    JCGLAttribute texCoords[JCMaxTexCoordSetsPreVertex];
    JCGLAttribute vertexColor;
    
    JCGLUniform modelviewMatrix;
    JCGLUniform modelMatrix;
    JCGLUniform viewMatrix;
    JCGLUniform projectionMatrix;
    JCGLUniform normalMatrix;
    
    JCGLEffectCamera camera;
    JCGLEffectMaterial material;
    JCGLEffectSkeleton skeleton;
    JCGLEffectStretch stretch;
    
    JCGLEffectSpotLight spotLight;
    
}JCGLEffect;

typedef JCGLEffect* JCGLEffectRef;
typedef const JCGLEffect* JCGLEffectRefC;

JCGLEffect JCGLEffectMake();
void JCGLEffectInit(JCGLEffectRef effect);
bool JCGLEffectSetup(JCGLEffectRef effect, JCGLProgram program);
bool JCGLEffectApplyTransform(JCGLEffectRefC effect, JCMatrix4 transform);
bool JCGLEffectApplyViewTransform(JCGLEffectRefC effect, JCMatrix4 transform);

JC_END

#endif /* defined(__jw__JCGLEffect__) */
