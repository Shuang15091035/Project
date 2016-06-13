//
//  JWMaterial.h
//  June Winter
//
//  Created by GavinLo on 14-5-5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWResource.h>
#import <jw/JCMaterial.h>

@protocol JIMaterial <JIResource>

/**
 * 内置的shader类型
 */
@property (nonatomic, readwrite) JCMaterialShader shader;

@property (nonatomic, readonly) BOOL isBlending;
@property (nonatomic, readonly) JCBlendFactor srcBlend;
@property (nonatomic, readonly) JCBlendFactor dstBlend;
- (void) setBlendingSrcFactor:(JCBlendFactor)srcFactor andDstFactor:(JCBlendFactor)dstFactor;
- (void) clearBlending;
@property (nonatomic, readwrite, getter=isDepthCheck) BOOL depthCheck;
@property (nonatomic, readwrite, getter=isDepthWrite) BOOL depthWrite;
@property (nonatomic, readwrite) JCDepthFunc depthFunc;
@property (nonatomic, readwrite) JCCullFace cullFace;

@property (nonatomic, readwrite) JCColor lightmapColor;
@property (nonatomic, readwrite) JCColor diffuseColor;
@property (nonatomic, readwrite) JCColor specularColor;
@property (nonatomic, readwrite) JCColor emissiveColor;
@property (nonatomic, readwrite) id<JITexture> lightmapTexture;
@property (nonatomic, readwrite) id<JITexture> diffuseTexture;
@property (nonatomic, readwrite) id<JITexture> specularTexture;
@property (nonatomic, readwrite) id<JITexture> reflectiveTexture;
@property (nonatomic, readwrite) float reflectiveAmount;
@property (nonatomic, readwrite) id<JITexture> normalTexture;
@property (nonatomic, readwrite) id<JITexture> alphaTexture;
@property (nonatomic, readwrite) short texcoordSet;
@property (nonatomic, readwrite) float shininess;

@property (nonatomic, readwrite, getter=isTransparent) BOOL transparent; // TODO 此属性可能会被废除
@property (nonatomic, readwrite) JCColor transparentColor;
@property (nonatomic, readwrite) float transparency;

@property (nonatomic, readwrite) id<JITexture> aoTexture;

@property (nonatomic, readwrite) JCColor rimColor;
@property (nonatomic, readwrite) float rimPower;

@property (nonatomic, readwrite) float outlineWidth;
@property (nonatomic, readwrite) JCColor outlineColor;

@property (nonatomic, readwrite) id<JIVideoTexture> videoTexture;

- (id<JIMaterial>) copyInstanceWithName:(NSString*)name;
- (NSComparisonResult) compareWith:(id<JIMaterial>)material;

@end

@interface JWMaterial : JWResource <JIMaterial>
{
    JCMaterial mMaterial;
    id<JITexture> mLigthmapTexture;
    id<JITexture> mDiffuseTexture;
    id<JITexture> mSpecularTexture;
    id<JITexture> mReflectiveTexture;
    id<JITexture> mNormalTexture;
    id<JITexture> mAlphaTexture;
    id<JITexture> mAOTexture;
    id<JIVideoTexture> mVideoTexture;
}

+ (NSComparisonResult) compareMaterial:(id<JIMaterial>)material toOther:(id<JIMaterial>)other;
@property (nonatomic, readonly) JCMaterialRefC cmaterial;

@end
