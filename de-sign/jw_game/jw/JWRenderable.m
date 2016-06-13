//
//  JWRenderable.m
//  June Winter
//
//  Created by GavinLo on 14-5-2.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWRenderable.h"
#import "JWGameObject.h"
#import "JWRenderQueue.h"
#import "JWMaterialManager.h"
#import "JWEffectManager.h"
#import "JWMaterial.h"

@implementation JWRenderable

- (void)onCreate
{
    [super onCreate];
    mVisible = YES;
    mRenderOrder = JWRenderOrderObjectDefault;
    mBounds = JCBounds3Null();
    mBoundsDirty = YES;
    mWillAutoEffect = YES;
}

- (void)onDestroy
{
    if (mRenderQueue != nil) {
        [mRenderQueue remove:self];
        mRenderQueue = nil;
    }
    [super onDestroy];
}

- (void)render:(id<JICamera>)camera {
    // nothing to do
}

- (NSInteger)renderOrder {
    return mRenderOrder;
}

- (void)setRenderOrder:(NSInteger)renderOrder {
    if (mRenderOrder != renderOrder) {
        mRenderOrder = renderOrder;
        if (mRenderQueue != nil) {
            //[mRenderQueue notifyResort];
            [mRenderQueue notifyChangedByRenderable:self];
        }
    }
}

- (BOOL)isVisible
{
    return mVisible;
}

- (void)setVisible:(BOOL)visible
{
    mVisible = visible;
}

- (id<JIRenderQueue>)renderQueue
{
    return mRenderQueue;
}

- (JCBounds3)bounds
{
    [self updateBounds];
    return mBounds;
}

- (void)updateBounds:(BOOL)immediate
{
    if(immediate)
        [self updateBoundsImmediate];
    else
        [self setBoundsDirty];
}

- (void)updateBoundsImmediate
{
    // subclass override
}

- (BOOL) updateBounds
{
    if(!mBoundsDirty)
        return NO;
    [self updateBoundsImmediate];
    mBoundsDirty = NO;
    return YES;
}

- (void) setBoundsDirty
{
    mBoundsDirty = YES;
    [mHost updateBounds:NO];
}

- (id<JIMaterial>)material
{
    if(mMaterial == nil)
        mMaterial = (id<JIMaterial>)mContext.materialManager.defaultResource;
    return mMaterial;
}

- (void)setMaterial:(id<JIMaterial>)material
{
    mMaterial = material;
}

- (id<JIEffect>)effect
{
    if(mEffect == nil)
        mEffect = (id<JIEffect>)mContext.effectManager.defaultResource;
    return mEffect;
}

- (void)setEffect:(id<JIEffect>)effect
{
    mEffect = effect;
}

- (BOOL)willAutoEffect
{
    return mWillAutoEffect;
}

- (void)setAutoEffect:(BOOL)autoEffect
{
    mWillAutoEffect = autoEffect;
}

- (id<JIRenderable>)copyInstance {
    // subclass override
    return nil;
}

- (void)onUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime
{
    // nothing to do
}

- (void)onAddToHost:(id<JIGameObject>)host {
    [super onAddToHost:host];
    if (host != nil) {
        JWGameObject* obj = host;
        id<JIRenderQueue> rq = obj.renderQueue;
        [self notifyQueue:rq];
        [host updateBounds:NO];
    }
}

- (void)onRemoveFromHost:(id<JIGameObject>)host {
    if (host != nil) {
        [self notifyQueue:nil];
        [host updateBounds:NO];
    }
    [super onRemoveFromHost:host];
}

- (void)notifyQueue:(id<JIRenderQueue>)queue {
    if (queue != nil) { // add
        if (queue != mRenderQueue) {
            [mRenderQueue remove:self];
            [queue add:self];
        }
    } else { // remove
        [mRenderQueue remove:self];
    }
    mRenderQueue = queue;
}

//- (void)onTransformChanged:(id<JITransform>)transform {
- (void)onComponentTransformChanged:(id<JITransform>)transform {
    [self requestRender];
}

- (NSString *)description {
    NSString* baseInfo = [NSString stringWithFormat:@"%@#%@(host=%@)", NSStringFromClass([self class]), @(self.renderOrder), mHost.Id];
    id<JIMaterial> material = self.material;
    if (material == nil) {
        return baseInfo;
    }
    return [NSString stringWithFormat:@"%@\nlightmap=%@\ndiffuse=%@\nspecular=%@\nreflective=%@\nnormal=%@\nalpha=%@\nao=%@\ntransparent=%@", baseInfo,
            material.lightmapTexture,
            material.diffuseTexture,
            material.specularTexture,
            material.reflectiveTexture,
            material.normalTexture,
            material.alphaTexture,
            material.aoTexture,
            material.isTransparent ? @"true" : @"false"];
}

@end
