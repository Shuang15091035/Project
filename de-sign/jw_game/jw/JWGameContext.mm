//
//  JWGameContext.m
//  June Winter
//
//  Created by GavinLo on 14-5-3.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWGameContext.h"

#import "JWGameEngine.h"
#import "JWGamePluginSystem.h"
#import "JWMaterialManager.h"
#import "JWEffectManager.h"
#import "JWMeshManager.h"
#import "JWAnimationResourceManager.h"
#import "JWResourceLoaderManager.h"
#import "JWSceneLoaderManager.h"
#import "JWGameWorld.h"
#import "JWGameScene.h"
#import "JWGameObject.h"
#import "JWMeshRenderer.h"
#import "JWAnimation.h"
#import "JWAnimationSet.h"
#import "JWPhysicalProperty.h"
#import "JWParticle.h"
#import "JWParticleSystem.h"
//#import "JWAnimationLoader.h"
//#import "JWDaeLoader.h"
//#import "JWDaxLoader.h"
#import "JWImageCodecManager.h"
#import "UIImageImageCodec.h"
#import <jw/JWPVRImageCodec.h>
#import <jw/JWEXRImageCodec.h>

@interface JWGameContext ()
{
    id<JIGameEngine> mEngine;
    
    id<JIMaterialManager> mMaterialManager;
    id<JITextureManager> mTextureManager;
    id<JIVideoTextureManager> mVideoTextureManager;
    id<JIImageCodecManager> mImageCodecManager;
    id<JIEffectManager> mEffectManager;
    id<JIMeshManager> mMeshManager;
    id<JIAnimationResourceManager> mAnimationResourceManager;
    id<JIResourceLoaderManager> mResourceLoaderManager;
    id<JISceneLoaderManager> mSceneLoaderManager;
    id<JIARSystem> mARSystem;
    id<JIARDataSetManager> mARDataSetManager;
    CMMotionManager* mMotionManager;
    JWCameraCapturer* mCameraCapturer;
}

@end

@implementation JWGameContext

+ (id)contextWithEngine:(id<JIGameEngine>)engine
{
    return [[JWGameContext alloc] initWithEngine:engine];
}

- (id)initWithEngine:(id<JIGameEngine>)engine
{
    self = [super init];
    if(self != nil)
    {
        mEngine = engine;
    }
    return self;
}

- (void)onDestroy
{
    [JWCoreUtils destroyObject:mMaterialManager];
    mMaterialManager = nil;
    [JWCoreUtils destroyObject:mTextureManager];
    mTextureManager = nil;
    [JWCoreUtils destroyObject:mEffectManager];
    mEffectManager = nil;
    [JWCoreUtils destroyObject:mMeshManager];
    mMeshManager = nil;
    [JWCoreUtils destroyObject:mAnimationResourceManager];
    mAnimationResourceManager = nil;
    [JWCoreUtils destroyObject:mResourceLoaderManager];
    mResourceLoaderManager = nil;
    [JWCoreUtils destroyObject:mSceneLoaderManager];
    mSceneLoaderManager = nil;
    [JWCoreUtils destroyObject:mARSystem];
    mARSystem = nil;
    [JWCoreUtils destroyObject:mARDataSetManager];
    mARDataSetManager = nil;
    if (mMotionManager != nil) {
        [mMotionManager stopAccelerometerUpdates];
        [mMotionManager stopDeviceMotionUpdates];
        [mMotionManager stopGyroUpdates];
        [mMotionManager stopMagnetometerUpdates];
        mMotionManager = nil;
    }
    
    [super onDestroy];
}

- (id<JIGameEngine>)engine
{
    return mEngine;
}

- (id<JIGameWorld>)createWorld
{
    return [mEngine.pluginSystem.gamePlugin createWorld:self];
}

- (id<JIGameScene>)createScene
{
    return [mEngine.pluginSystem.gamePlugin createScene:self];
}

- (id<JIGameObject>)createObject
{
    return [mEngine.pluginSystem.gamePlugin createObject:self];
}

- (id<JIMaterialManager>)materialManager
{
    if(mMaterialManager == nil)
        mMaterialManager = [mEngine.pluginSystem.renderPlugin createMaterialManager:mEngine];
    return mMaterialManager;
}

- (id<JITextureManager>)textureManager
{
    if(mTextureManager == nil)
        mTextureManager = [mEngine.pluginSystem.renderPlugin createTextureManager:mEngine];
    return mTextureManager;
}

- (id<JIVideoTextureManager>)videoTextureManager {
    if (mVideoTextureManager == nil) {
        mVideoTextureManager = [mEngine.pluginSystem.renderPlugin createVideoTextureManager:mEngine];
    }
    return mVideoTextureManager;
}

- (id<JIImageCodecManager>)imageCodecManager
{
    if(mImageCodecManager == nil)
    {
        mImageCodecManager = [[JWImageCodecManager alloc] init];
        [mImageCodecManager registerCodec:[UIImageImageCodec codec] overrideExist:NO];
        [mImageCodecManager registerCodec:[JWPVRImageCodec codec] overrideExist:NO];
        [mImageCodecManager registerCodec:[JWEXRImageCodec codec] overrideExist:NO];
    }
    return mImageCodecManager;
}

- (id<JIEffectManager>)effectManager
{
    if(mEffectManager == nil)
        mEffectManager = [mEngine.pluginSystem.renderPlugin createEffectManager:mEngine];
    return mEffectManager;
}

- (id<JIMeshManager>)meshManager
{
    if(mMeshManager == nil)
        mMeshManager = [mEngine.pluginSystem.renderPlugin createMeshManager:mEngine];
    return mMeshManager;
}

- (id<JIAnimationResourceManager>)animationResourceManager
{
    if(mAnimationResourceManager == nil)
    {
        mAnimationResourceManager = [[JWAnimationResourceManager alloc] initWithContext:self];
        [mAnimationResourceManager onCreate];
    }
    return mAnimationResourceManager;
}

- (id<JIResourceLoaderManager>)resourceLoaderManager {
    if (mResourceLoaderManager == nil) {
        mResourceLoaderManager = [[JWResourceLoaderManager alloc] initWithContext:self];
//        [mResourceLoaderManager registerLoader:[[JWAnimationLoader alloc] initWithContext:self] overrideExist:NO];
    }
    return mResourceLoaderManager;
}

- (id<JISceneLoaderManager>)sceneLoaderManager {
    if (mSceneLoaderManager == nil) {
        mSceneLoaderManager = [[JWSceneLoaderManager alloc] initWithContext:self];
//        [mSceneLoaderManager registerLoader:[[JWDaeLoader alloc] initWithContext:self] overrideExist:NO];
//        [mSceneLoaderManager registerLoader:[[JWDaxLoader alloc] initWithContext:self] overrideExist:NO];
    }
    return mSceneLoaderManager;
}

- (id<JIARSystem>)arSystem {
    if (mARSystem == nil) {
        mARSystem = [mEngine.pluginSystem.arPlugin createSystem:mEngine];
    }
    return mARSystem;
}

- (id<JIARDataSetManager>)arDataSetManager {
    if (mARDataSetManager == nil) {
        mARDataSetManager = [mEngine.pluginSystem.arPlugin createDataSetManager:mEngine];
    }
    return mARDataSetManager;
}

- (CMMotionManager *)motionManager {
    if (mMotionManager == nil) {
        mMotionManager = [[CMMotionManager alloc] init];
    }
    return mMotionManager;
}

- (JWCameraCapturer *)cameraCapturer {
    if (mCameraCapturer == nil) {
        mCameraCapturer = [JWCameraCapturer capturer];
    }
    return mCameraCapturer;
}

- (id<JICamera>)createCamera {
    id<JICamera> camera = [mEngine.pluginSystem.renderPlugin createCamera:mEngine];
    if (camera == nil) {
        NSLog(@"Render Plugin[%@] returns a null Camera.", mEngine.pluginSystem.renderPlugin);
        return nil;
    }
    return camera;
}

- (id<JIVRCamera>)createVRCamera {
    id<JIVRCamera> camera = [mEngine.pluginSystem.renderPlugin createVRCamera:mEngine];
    if (camera == nil) {
        NSLog(@"Render Plugin[%@] returns a null VR Camera.", mEngine.pluginSystem.renderPlugin);
        return nil;
    }
    return camera;
}

- (id<JIMeshRenderer>)createMeshRenderer
{
    id<JIMeshRenderer> meshRenderer = [mEngine.pluginSystem.renderPlugin createMeshRenderer:mEngine];
    if(meshRenderer == nil)
    {
        NSLog(@"Render Plugin[%@] returns a null MeshRenderer.", mEngine.pluginSystem.renderPlugin);
        return nil;
    }
    return meshRenderer;
}

- (id<JIBoundsRenderer>)createBoundsRenderer
{
    id<JIBoundsRenderer> boundsRenderer = [mEngine.pluginSystem.renderPlugin createBoundsRenderer:mEngine];
    if(boundsRenderer == nil)
    {
        NSLog(@"Render Plugin[%@] returns a null BoundsRenderer.", mEngine.pluginSystem.renderPlugin);
        return nil;
    }
    return boundsRenderer;
}

- (id<JISpotLight>)createSpotLight
{
    id<JISpotLight> spotLight = [mEngine.pluginSystem.renderPlugin createSpotLight:mEngine];
    if(spotLight == nil)
    {
        NSLog(@"Render Plugin[%@] returns a null SpotLight.", mEngine.pluginSystem.renderPlugin);
        return nil;
    }
    return spotLight;
}

- (id<JIViewTag>)createViewTag {
    id<JIViewTag> viewTag = [mEngine.pluginSystem.renderPlugin createViewTag:mEngine];
    if (viewTag == nil) {
        NSLog(@"Render Plugin[%@] returns a null ViewTag.", mEngine.pluginSystem.renderPlugin);
        return nil;
    }
    return viewTag;
}

- (id<JIAnimation>)createAnimation
{
    id<JIAnimation> animation = [[JWAnimation alloc] initWithContext:self];
    return animation;
}

- (id<JIAnimationSet>)createAnimationSet {
    id<JIAnimationSet> animationSet = [[JWAnimationSet alloc] initWithContext:self];
    return animationSet;
}

- (id<JIPhysicalProperty>)createPhysicalProperty {
    id<JIPhysicalProperty> physicalProperty = [[JWPhysicalProperty alloc] initWithContext:self];
    return physicalProperty;
}

- (id<JIParticle>)createParticle {
    id<JIParticle> particle = [[JWParticle alloc] initWithContext:self];
    return particle;
}

- (id<JIParticleSystem>)createParticleSystem {
    id<JIParticleSystem> particleSystem = [[JWParticleSystem alloc] initWithContext:self];
    return particleSystem;
}

- (id<JIComponentSet>)createComponentSet {
    id<JIComponentSet> cs = [[JWComponentSet alloc] initWithContext:self];
    return cs;
}

- (id<JIARCamera>)createARCamera {
    id<JIARCamera> arCamera = [mEngine.pluginSystem.arPlugin createCamera:mEngine];
    if (arCamera == nil) {
        NSLog(@"AR Plugin[%@] returns a null Camera.", mEngine.pluginSystem.arPlugin);
    }
    return arCamera;
}

- (id<JIARImageTarget>)createARImageTarget {
    id<JIARImageTarget> arImageTarget = [mEngine.pluginSystem.arPlugin createImageTarget:mEngine];
    if (arImageTarget == nil) {
        NSLog(@"AR Plugin[%@] returns a null ImageTarget.", mEngine.pluginSystem.arPlugin);
    }
    return arImageTarget;
}

@end
