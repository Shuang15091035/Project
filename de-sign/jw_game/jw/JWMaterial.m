//
//  JWMaterial.m
//  June Winter
//
//  Created by GavinLo on 14-5-5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWMaterial.h"
#import "JWTexture.h"
#import "JWEffectManager.h"

@implementation JWMaterial

- (void)onCreate
{
    [super onCreate];
    mMaterial = JCMaterialMake();
}

- (JCMaterialShader)shader
{
    return mMaterial.shader;
}

- (void)setShader:(JCMaterialShader)shader
{
    mMaterial.shader = shader;
}

- (BOOL)isBlending
{
    return mMaterial.isBlending ? YES : NO;
}

- (JCBlendFactor)srcBlend
{
    return mMaterial.srcBlend;
}

- (JCBlendFactor)dstBlend
{
    return mMaterial.dstBlend;
}

- (void)setBlendingSrcFactor:(JCBlendFactor)srcFactor andDstFactor:(JCBlendFactor)dstFactor
{
    JCMaterialSetBlending(&mMaterial, srcFactor, dstFactor);
    [self handlePremultipliedAlphaTextureBlend];
}

- (void)clearBlending {
    JCMaterialClearBlending(&mMaterial);
}

- (BOOL)isDepthCheck
{
    return mMaterial.isDepthCheck ? YES : NO;
}

- (void)setDepthCheck:(BOOL)depthCheck
{
    mMaterial.isDepthCheck = depthCheck ? true : false;
}

- (BOOL)isDepthWrite
{
    return mMaterial.isDepthWrite ? YES : NO;
}

- (void)setDepthWrite:(BOOL)depthWrite
{
    mMaterial.isDepthWrite = depthWrite ? true : false;
}

- (JCDepthFunc)depthFunc
{
    return mMaterial.depthFunc;
}

- (void)setDepthFunc:(JCDepthFunc)depthFunc
{
    mMaterial.depthFunc = depthFunc;
}

- (JCCullFace)cullFace
{
    return mMaterial.cullFace;
}

- (void)setCullFace:(JCCullFace)cullFace
{
    mMaterial.cullFace = cullFace;
}

- (JCColor)lightmapColor {
    return mMaterial.lightmapColor.color;
}

- (void)setLightmapColor:(JCColor)lightmapColor {
    mMaterial.lightmapColor.color = lightmapColor;
}

- (JCColor)diffuseColor
{
    return mMaterial.diffuseColor.color;
}

- (void)setDiffuseColor:(JCColor)diffuseColor
{
    mMaterial.diffuseColor.color = diffuseColor;
}

- (JCColor)specularColor
{
    return mMaterial.specularColor.color;
}

- (void)setSpecularColor:(JCColor)specularColor
{
    mMaterial.specularColor.color = specularColor;
}

- (JCColor)emissiveColor
{
    return mMaterial.emissiveColor.color;
}

- (void)setEmissiveColor:(JCColor)emissiveColor
{
    mMaterial.emissiveColor.color = emissiveColor;
}

- (id<JITexture>)lightmapTexture {
    return mLigthmapTexture;
}

- (void)setLightmapTexture:(id<JITexture>)lightmapTexture {
    mLigthmapTexture = lightmapTexture;
    if (mLigthmapTexture != nil) {
        JWTexture* tex = (JWTexture*)mLigthmapTexture;
        JCMaterialSetTexture(&mMaterial, JCTextureTypeLightmap, tex.ctexture);
    } else {
        JCMaterialSetTexture(&mMaterial, JCTextureTypeLightmap, NULL);
    }
}

- (id<JITexture>)diffuseTexture
{
    return mDiffuseTexture;
}

- (void)setDiffuseTexture:(id<JITexture>)diffuseTexture {
    mDiffuseTexture = diffuseTexture;
    if (mDiffuseTexture != nil) {
        JWTexture* tex = (JWTexture*)mDiffuseTexture;
        JCMaterialSetTexture(&mMaterial, JCTextureTypeDiffuse, tex.ctexture);
    } else {
        JCMaterialSetTexture(&mMaterial, JCTextureTypeDiffuse, NULL);
    }
}

- (id<JITexture>)specularTexture
{
    return mSpecularTexture;
}

- (void)setSpecularTexture:(id<JITexture>)specularTexture
{
    mSpecularTexture = specularTexture;
    if(mSpecularTexture != nil)
    {
        JWTexture* tex = (JWTexture*)mSpecularTexture;
        JCMaterialSetTexture(&mMaterial, JCTextureTypeSpecular, tex.ctexture);
    }
    else
    {
        JCMaterialSetTexture(&mMaterial, JCTextureTypeSpecular, NULL);
    }
}

- (id<JITexture>)reflectiveTexture
{
    return mReflectiveTexture;
}

- (void)setReflectiveTexture:(id<JITexture>)reflectiveTexture
{
    mReflectiveTexture = reflectiveTexture;
    if(mReflectiveTexture != nil)
    {
        JWTexture* tex = (JWTexture*)mReflectiveTexture;
        JCMaterialSetTexture(&mMaterial, JCTextureTypeReflective, tex.ctexture);
    }
    else
    {
        JCMaterialSetTexture(&mMaterial, JCTextureTypeReflective, NULL);
    }
}

- (float)reflectiveAmount {
    //return mMaterial.reflectiveTexture.amount;
    return mMaterial.texture[JCTextureTypeReflective].amount;
}

- (void)setReflectiveAmount:(float)reflectiveAmount {
    //mMaterial.reflectiveTexture.amount = reflectiveAmount;
    mMaterial.texture[JCTextureTypeReflective].amount = reflectiveAmount;
}

- (id<JITexture>)normalTexture
{
    return mNormalTexture;
}

- (void)setNormalTexture:(id<JITexture>)normalTexture
{
    mNormalTexture = normalTexture;
    if(mNormalTexture != nil)
    {
        JWTexture* tex = (JWTexture*)mNormalTexture;
        JCMaterialSetTexture(&mMaterial, JCTextureTypeBump, tex.ctexture);
    }
    else
    {
        JCMaterialSetTexture(&mMaterial, JCTextureTypeBump, NULL);
    }
}

- (id<JITexture>)alphaTexture
{
    return mAlphaTexture;
}

- (void)setAlphaTexture:(id<JITexture>)alphaTexture
{
    mAlphaTexture = alphaTexture;
    if (mAlphaTexture != nil) {
        JWTexture* tex = (JWTexture*)mAlphaTexture;
        JCMaterialSetTexture(&mMaterial, JCTextureTypeAlpha, tex.ctexture);
        [self handlePremultipliedAlphaTextureBlend];
    } else {
        JCMaterialSetTexture(&mMaterial, JCTextureTypeAlpha, NULL);
    }
}

- (void) handlePremultipliedAlphaTextureBlend { // NOTE PremultipliedAlpha的透明贴图需要这样处理
//    if (mAlphaTexture.bitmap != NULL && JCPixelFormatHasPremultipliedAlpha(mAlphaTexture.bitmap->pixelFormat)) {
    if (JCPixelFormatHasPremultipliedAlpha(mAlphaTexture.pixelFormat)) {
        if (mMaterial.srcBlend == JCBlendFactorSrcAlpha && mMaterial.dstBlend == JCBlendFactorOneMinusSrcAlpha) {
            mMaterial.srcBlend = JCBlendFactorOne;
        }
    }
}

- (short)texcoordSet {
    return mMaterial.texcoordSet;
}

- (void)setTexcoordSet:(short)texcoordSet {
    mMaterial.texcoordSet = texcoordSet;
}

- (float)shininess
{
    return mMaterial.shininess;
}

- (void)setShininess:(float)shininess
{
    mMaterial.shininess = shininess;
}

- (BOOL)isTransparent
{
    return mMaterial.isTransparent ? YES : NO;
}

- (void)setTransparent:(BOOL)transparent
{
    mMaterial.isTransparent = transparent ? true : false;
}

- (JCColor)transparentColor
{
    return mMaterial.transparentColor.color;
}

- (void)setTransparentColor:(JCColor)transparentColor
{
    //mMaterial.isTransparent = !JCColorIsWhite(&transparentColor);
    mMaterial.transparentColor.color = transparentColor;
}

- (float)transparency
{
    return mMaterial.transparency;
}

- (void)setTransparency:(float)transparency
{
    //mMaterial.isTransparent = (transparency == 1.0f) ? false : true;
    mMaterial.transparency = transparency;
}

- (id<JITexture>)aoTexture {
    return mAOTexture;
}

- (void)setAoTexture:(id<JITexture>)aoTexture {
    mAOTexture = aoTexture;
    if (mAOTexture != nil) {
        JWTexture* tex = (JWTexture*)mAOTexture;
        JCMaterialSetTexture(&mMaterial, JCTextureTypeAO, tex.ctexture);
    } else {
        JCMaterialSetTexture(&mMaterial, JCTextureTypeAO, NULL);
    }
}

- (JCColor)rimColor {
    return mMaterial.rimColor;
}

- (void)setRimColor:(JCColor)rimColor {
    mMaterial.rimColor = rimColor;
}

- (float)rimPower {
    return mMaterial.rimPower;
}

- (void)setRimPower:(float)rimPower {
    mMaterial.rimPower = rimPower;
}

- (float)outlineWidth {
    return mMaterial.outlineWidth;
}

- (void)setOutlineWidth:(float)outlineWidth {
    mMaterial.outlineWidth = outlineWidth;
}

- (JCColor)outlineColor {
    return mMaterial.outlineColor;
}

- (void)setOutlineColor:(JCColor)outlineColor {
    mMaterial.outlineColor = outlineColor;
}

- (id<JIVideoTexture>)videoTexture {
    return mVideoTexture;
}

- (void)setVideoTexture:(id<JIVideoTexture>)videoTexture {
    mVideoTexture = videoTexture;
    // subclass override
}

+ (NSComparisonResult)compareMaterial:(id<JIMaterial>)material toOther:(id<JIMaterial>)other {
    if (material == other || (material == nil && other == nil)) { // 同一个材质
        return NSOrderedSame;
    }
    if (material == nil) {
        return NSOrderedDescending;
    } else if (other == nil) {
        return NSOrderedAscending;
    }
    // 比较hashcode
    NSComparisonResult result = NSOrderedSame;
    if (material.hash < other.hash) {
        result = NSOrderedAscending;
    } else {
        result = NSOrderedDescending;
    }
    // 根据是否透明决定排序
    BOOL t1 = material.transparent;
    BOOL t2 = other.transparent;
    if (t1 == t2) {
        return result;
    } else {
        if (t1) {
            result = NSOrderedDescending;
        } else {
            result = NSOrderedAscending;
        }
    }
    return result;
}

- (id<JIMaterial>)copyInstanceWithName:(NSString *)name {
    id<JIFile> file = [JWFile fileWithName:name content:nil];
    id<JIMaterial> newMaterial = (id<JIMaterial>)[mManager createFromFile:file];
    newMaterial.shader = self.shader;
    [newMaterial setBlendingSrcFactor:self.srcBlend andDstFactor:self.dstBlend];
    newMaterial.depthCheck = self.isDepthCheck;
    newMaterial.depthWrite = self.isDepthWrite;
    newMaterial.depthFunc = self.depthFunc;
    newMaterial.cullFace = self.cullFace;
    newMaterial.lightmapColor = self.lightmapColor;
    newMaterial.diffuseColor = self.diffuseColor;
    newMaterial.specularColor = self.specularColor;
    newMaterial.emissiveColor = self.emissiveColor;
    newMaterial.lightmapTexture = self.lightmapTexture;
    newMaterial.diffuseTexture = self.diffuseTexture;
    newMaterial.specularTexture = self.specularTexture;
    newMaterial.reflectiveTexture = self.reflectiveTexture;
    newMaterial.reflectiveAmount = self.reflectiveAmount;
    newMaterial.normalTexture = self.normalTexture;
    newMaterial.alphaTexture = self.alphaTexture;
    newMaterial.texcoordSet = self.texcoordSet;
    newMaterial.shininess = self.shininess;
    newMaterial.transparent = self.isTransparent;
    newMaterial.transparentColor = self.transparentColor;
    newMaterial.transparency = self.transparency;
    newMaterial.aoTexture = self.aoTexture;
    newMaterial.rimColor = self.rimColor;
    newMaterial.rimPower = self.rimPower;
    newMaterial.videoTexture = self.videoTexture;
    
    return newMaterial;
}

- (NSComparisonResult)compareWith:(id<JIMaterial>)material {
    return [JWMaterial compareMaterial:self toOther:material];
}

- (JCMaterialRefC)cmaterial {
    return &mMaterial;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ l(%@) d(%@) s(%@) r(%@) n(%@), a(%@)", NSStringFromClass([self class]), mLigthmapTexture, mDiffuseTexture, mSpecularTexture, mReflectiveTexture, mNormalTexture, mAlphaTexture];
}

@end
