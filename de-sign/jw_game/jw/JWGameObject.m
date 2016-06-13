//
//  JWGameObject.m
//  June Winter
//
//  Created by GavinLo on 14-4-12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWGameObject.h"
#import "JWTransform.h"
#import "JWGameScene.h"
#import "JWRenderable.h"
#import "JWCamera.h"
#import "JWLight.h"
#import "JWRenderable.h"
#import "JWBehaviour.h"
#import "JWViewTag.h"
#import "JWAnimation.h"
#import "JWAnimationSet.h"
#import "JWPhysicalProperty.h"
#import "JWParticle.h"
#import "JWParticleSystem.h"
#import "JWSceneQuery.h"
#import "JWARSystem.h"
#import "JWARImageTarget.h"
#import "JWARImageTracker.h"
#import "JWMesh.h"
#import "JWMeshManager.h"
#import "JWMaterial.h"
#import "JWMaterialManager.h"
#import "JWMeshRenderer.h"
#import "NSString+JWCoreCategory.h"
#import "JWList.h"
#import <jw/JCFlags.h>
#import <jw/NSArray+JWCoreCategory.h>

@interface JWGameObject () {
    id<JIGameContext> mContext;
    id<JIGameScene> mScene;
    BOOL mEnable;
    
    id<JITransform> mTransform;
    JCBounds3 mBounds;
    BOOL mManualBounds;
    JCBounds3 mTransformBounds;
    
    BOOL mBoundsEnable;
    BOOL mBoundsDirty;
    JCStretch mStretch;
    BOOL mInheritStretch;
    JCBounds3 mBoundsByStretch;
    JCBounds3 mTransformBoundsByStretch;
    
    //id<JIUList> mComponents;
    
    id<JICamera> mCamera;
    id<JILight> mLight;
    id<JIRenderable> mRenderable;
    id<JIBehaviour> mBehaviour;
    id<JIViewTag> mViewTag;
    id<JIAnimationSet> mAnimationSet;
    id<JIPhysicalProperty> mPhysicalProperty;
    id<JIParticle> mParticle;
    id<JIParticleSystem> mParticleSystem;
    id<JIARImageTarget> mARImageTarget;
    id<JIComponentSet> mComponentSet;
    id<JIRenderable> mAxes;
    float mAxisLength;
    
    NSUInteger mQueryMask;
    
    id<JIRenderQueue> mRenderQueue;
    
    id mExtra;
}

//@property (nonatomic, readonly) id<JIUList> componentList;

@end

@implementation JWGameObject

- (id)initWithContext:(id<JIGameContext>)context {
    self = [super init];
    if (self != nil) {
        mContext = context;
        [self onCreate];
    }
    return self;
}

- (void)onCreate {
    [super onCreate];
    mEnable = YES;
    mBoundsEnable = YES;
    mBoundsDirty = YES;
    mStretch = JCStretchMake(JCVector3Zero(), JCVector3Zero());
    mInheritStretch = YES;
    mQueryMask = JWSceneQueryMask_All;
    mAxisLength = 1.0f;
}

- (void)onDestroy {
    // 避免释放的过程中更新对象
    self.enabled = NO;
    // 通知所有组件脱离renderQueue
    [self notifyQueue:nil];
    
    // 释放组件
//    [JWCoreUtils destroyList:mComponents];
//    mComponents = nil;
    [JWCoreUtils destroyObject:mCamera];
    mCamera = nil;
    [JWCoreUtils destroyObject:mLight];
    mLight = nil;
    [JWCoreUtils destroyObject:mRenderable];
    mRenderable = nil;
    [JWCoreUtils destroyObject:mBehaviour];
    mBehaviour = nil;
    [JWCoreUtils destroyObject:mViewTag];
    mViewTag = nil;
    [JWCoreUtils destroyObject:mAnimationSet];
    mAnimationSet = nil;
    [JWCoreUtils destroyObject:mARImageTarget];
    mARImageTarget = nil;
    [JWCoreUtils destroyObject:mComponentSet];
    mComponentSet = nil;
    
    if (mTransform != nil) {
        [mTransform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
            id<JITransform> ct = obj;
            id<JIGameObject> child = ct.host;
            [JWCoreUtils destroyObject:child];
        }];
        [JWCoreUtils destroyObject:mTransform];
        mTransform = nil;
    }
    
    [super onDestroy];
}

//- (id<JIUList>)componentList
//{
//    if (mComponents == nil)
//        mComponents = [JWSafeUList list];
//    return mComponents;
//}

- (id<JIGameContext>)context {
    return mContext;
}

- (id<JIGameScene>)scene {
    id<JIGameObject> parent = self.parent;
    if (parent != nil) {
        id<JIGameScene> parentScene = parent.scene;
        if (parentScene != nil)
            return parentScene;
    }
    return mScene;
}

- (BOOL)isEnabled {
    return mEnable;
}

- (void)setEnabled:(BOOL)enabled {
    mEnable = enabled;
}

- (BOOL)isVisible {
//    __block BOOL visible = NO;
//    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//        id<JIComponent> component = obj;
//        if ([component conformsToProtocol:@protocol(JIRenderable)]) {
//            id<JIRenderable> renderable = (id<JIRenderable>)component;
//            if (renderable.isVisible) {
//                visible = YES;
//                *stop = YES;
//            }
//        }
//    }];
    if (mRenderable != nil && mRenderable.isVisible) {
        return YES;
    }
    if (mViewTag != nil && mViewTag.isVisible) {
        return YES;
    }
    __block BOOL visible = NO;
    [mComponentSet.components enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JIComponent> component = obj;
        if ([component conformsToProtocol:@protocol(JIRenderable)]) {
            id<JIRenderable> renderable = (id<JIRenderable>)component;
            if (renderable.isVisible) {
                visible = YES;
                *stop = YES;
            }
        }
    }];
    [mTransform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        JWTransform* child = obj;
        id<JIGameObject> childObject = child.host;
        if (childObject.isVisible) {
            visible = YES;
            *stop = YES;
        }
    }];
    return NO;
}

- (void)setVisible:(BOOL)visible {
    [self setVisible:visible recursive:YES];
}

- (void)setVisible:(BOOL)visible recursive:(BOOL)recursive {
//    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//        id<JIComponent> component = obj;
//        if ([component conformsToProtocol:@protocol(JIRenderable)])
//        {
//            id<JIRenderable> renderable = (id<JIRenderable>)component;
//            renderable.visible = visible;
//        }
//    }];
    if (mRenderable != nil) {
        [mRenderable setVisible:visible];
    }
    if (mViewTag != nil) {
        [mViewTag setVisible:visible];
    }
    [mComponentSet.components enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JIComponent> component = obj;
        if ([component conformsToProtocol:@protocol(JIRenderable)])
        {
            id<JIRenderable> renderable = (id<JIRenderable>)component;
            renderable.visible = visible;
        }
    }];
    if (recursive) {
        [mTransform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
            JWTransform* child = obj;
            id<JIGameObject> childObject = child.host;
            // TODO isInheritVisible
            [childObject setVisible:visible recursive:recursive];
        }];
    }
}

- (id<JITransform>)transform {
    if (mTransform == nil) {
        mTransform = [[JWTransform alloc] initWithContext:mContext];
        JWTransform* t = (JWTransform*)mTransform;
        [t onAddToHost:self];
    }
    return mTransform;
}

- (id<JIGameObject>)parent {
    if (mTransform == nil) {
        return nil;
    }
    id<JITransform> parentTransform = mTransform.parent;
    if (parentTransform == nil) {
        return nil;
    }
    return parentTransform.host;
}

- (void)setParent:(id<JIGameObject>)parent {
    if (parent == self) {
        return;
    }
    id<JIGameObject> oldParent = self.parent;
    if (oldParent == parent) {
        return;
    }
    
    if (oldParent != nil) {
        [self onDetachFromObject:oldParent];
    }
    id<JITransform> parentTransform = nil;
    if (parent != nil) {
        parentTransform = parent.transform;
    }
    self.transform.parent = parentTransform;
    if (parent != nil) {
        [self onAttachToObject:parent];
    }
}

- (JCBounds3)bounds {
    [self updateBounds];
    return mBounds;
}

- (void)setBounds:(JCBounds3)bounds {
    mBounds = bounds;
    mManualBounds = YES;
}

- (JCBounds3)transformBounds {
    [self updateBounds];
    return mTransformBounds;
}

- (JCBounds3)scaleBounds {
    [self updateBounds];
    JCVector3 scale = mTransform.scale;
    return JCBounds3Scale(&mBounds, scale);
}

- (BOOL)isBoundsEnabled {
    return mBoundsEnable;
}

- (void)setBoundsEnabled:(BOOL)boundsEnabled {
    mBoundsEnable = boundsEnabled;
}

- (void)updateBounds:(BOOL)immediate {
    if (!mBoundsEnable) {
        return;
    }
    if (immediate) {
        [self updateBoundsImmediate];
    } else {
        [self setBoundsDirty];
    }
}

- (JCStretch)stretch {
    return mStretch;
}

- (void)setStretch:(JCStretch)stretch {
    mStretch = stretch;
    // NOTE 影响底下所有子节点
    [mTransform enumChildrenUsing:^(id<JITransform> child, NSUInteger idx, BOOL *stop) {
        id<JIGameObject> childObject = child.host;
        if (childObject.inheritStretch) {
            childObject.stretch = stretch;
        }
    }];
    // NOTE 更新bounds
    [self setBoundsDirty];
}

- (JCStretch)stretchByScale {
    // NOTE 拉伸是基于模型坐标系的，同时加上缩放，以确保拉伸在模型空间按照模型大小变换
    JCVector3 scale = mTransform.scale;
    JCVector3 stretchPivot = JCVector3Mulv(&mStretch.pivot, &scale);
    JCVector3 stretchOffset = JCVector3Mulv(&mStretch.offset, &scale);
    return JCStretchMake(stretchPivot, stretchOffset);
}

@synthesize inheritStretch = mInheritStretch;

- (JCBounds3)boundsByStretch {
    [self updateBounds];
    return mBoundsByStretch;
}

- (JCBounds3)transformBoundsByStretch {
    [self updateBounds];
    return mTransformBoundsByStretch;
}

- (JCBounds3)scaleBoundsByStretch {
    return [self getBounds:self.scaleBounds byStretch:self.stretch];
}

- (BOOL)alignObject:(id<JIGameObject>)object withAlignments:(NSUInteger)alignments {
    if (alignments == JWGameObjectAlignNone) {
        return NO;
    }
    JCBounds3 ab = self.transformBounds;
    JCBounds3 bb = object.transformBounds;
    JCVector3 dp = JCVector3Zero();
    if (JCFlagsTest(alignments, JWGameObjectAlignNX)) {
        dp.x = bb.min.x - ab.min.x;
    }
    if (JCFlagsTest(alignments, JWGameObjectAlignCX)) {
        dp.x = ((bb.min.x + bb.max.x) - (ab.min.x + ab.max.x)) * 0.5f;
    }
    if (JCFlagsTest(alignments, JWGameObjectAlignPX)) {
        dp.x = bb.max.x - ab.max.x;
    }
    if (JCFlagsTest(alignments, JWGameObjectAlignNY)) {
        dp.y = bb.min.y - ab.min.y;
    }
    if (JCFlagsTest(alignments, JWGameObjectAlignCY)) {
        dp.y = ((bb.min.y + bb.max.y) - (ab.min.y + ab.max.y)) * 0.5f;
    }
    if (JCFlagsTest(alignments, JWGameObjectAlignPY)) {
        dp.y = bb.max.y - ab.max.y;
    }
    if (JCFlagsTest(alignments, JWGameObjectAlignNZ)) {
        dp.z = bb.min.z - ab.min.z;
    }
    if (JCFlagsTest(alignments, JWGameObjectAlignCZ)) {
        dp.z = ((bb.min.z + bb.max.z) - (ab.min.z + ab.max.z)) * 0.5f;
    }
    if (JCFlagsTest(alignments, JWGameObjectAlignPZ)) {
        dp.z = bb.max.z - ab.max.z;
    }
    [self.transform translate:dp inSpace:JWTransformSpaceWorld];
    return YES;
}

- (JCBounds3) getBounds:(JCBounds3)bounds byStretch:(JCStretch)stretch {
    JCBounds3 result;
    JCBounds3SetBounds(&result, &bounds);
    if (bounds.min.x < stretch.pivot.x && stretch.pivot.x < bounds.max.x) {
        result.min.x -= stretch.offset.x;
        result.max.x += stretch.offset.x;
    }
    if (stretch.pivot.y < bounds.max.y) {
        result.max.y += stretch.offset.y;
    }
    if (bounds.min.z < stretch.pivot.z && stretch.pivot.z < bounds.max.z) {
        result.min.z -= stretch.offset.z;
        result.max.z += stretch.offset.z;
    }
    return result;
}

- (void) updateBoundsImmediate {
    
    if (!mManualBounds) {
        mBounds.extent = JCBoundsExtentNull;
        if (mRenderable != nil) {
            JCBounds3 rb = mRenderable.bounds;
            mBounds = JCBounds3Mergeb(&mBounds, &rb);
        }
        [mComponentSet.components enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
            id<JIComponent> component = obj;
            if ([component conformsToProtocol:@protocol(JIRenderable)]) {
                id<JIRenderable> renderable = (id<JIRenderable>)component;
                JCBounds3 rb = renderable.bounds;
                mBounds = JCBounds3Mergeb(&mBounds, &rb);
            }
        }];
        // NOTE 加上拉伸
        mBoundsByStretch = [self getBounds:mBounds byStretch:mStretch];
    }
    
    // 进行几何变换
    JCMatrix4 tm = mTransform.matrix;
    JCBounds3SetBounds(&mTransformBounds, &mBounds);
    mTransformBounds = JCBounds3Transform(&mTransformBounds, &tm);
    JCBounds3SetBounds(&mTransformBoundsByStretch, &mBoundsByStretch);
    mTransformBoundsByStretch = JCBounds3Transform(&mTransformBoundsByStretch, &tm);
    
    if (!mManualBounds) {
        // 待自身bounds计算完成,再合并所有子对象的bounds
        [mTransform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
            id<JITransform> ct = obj;
            id<JIGameObject> child = ct.host;
            if (!child.isBoundsEnabled) {
                return;
            }
            
            JCBounds3 cb = child.bounds;
            mBounds = JCBounds3Mergeb(&mBounds, &cb);
            JCBounds3 ctb = child.transformBounds;
            mTransformBounds = JCBounds3Mergeb(&mTransformBounds, &ctb);
            
            JCBounds3 cbs = child.boundsByStretch;
            mBoundsByStretch = JCBounds3Mergeb(&mBoundsByStretch, &cbs);
            JCBounds3 ctbs = child.transformBoundsByStretch;
            mTransformBoundsByStretch = JCBounds3Mergeb(&mTransformBoundsByStretch, &ctbs);
        }];
    }
    
    // TODO 通知所有组件,bounds有变化
    mBoundsDirty = NO;
}

- (void) updateBounds {
    if (!mBoundsDirty) {
        return;
    }
    [self updateBoundsImmediate];
    mBoundsDirty = NO;
}

- (void) setBoundsDirty {
    mBoundsDirty = YES;
    JWGameObject* parent = self.parent;
    if (parent != nil) {
        [parent setBoundsDirty];
    }
}

- (void)addComponent:(id<JIComponent>)component
{
//    if (component == nil) {
//        return;
//    }
//    
//    if ([component conformsToProtocol:@protocol(JICamera)]) {
//        if (mCamera != nil) {
//            return;
//        }
//        mCamera = (id<JICamera>)component;
//    } else if ([component conformsToProtocol:@protocol(JILight)]) {
//        if (mLight != nil) {
//            return;
//        }
//        mLight = (id<JILight>)component;
//    }
//    
//    if ([self.componentList addObject:component likeASet:YES]){
//        if ([component conformsToProtocol:@protocol(JIRenderable)]) {
//            [self updateBounds:NO];
//        } else if ([component conformsToProtocol:@protocol(JIARImageTarget)]) {
//            id<JIARSystem> arSystem = mContext.arSystem;
//            id<JIARImageTarget> arImageTarget = (id<JIARImageTarget>)component;
//            [arSystem.imageTracker registerImageTarget:arImageTarget];
//        }
//        JWComponent* comp = component;
//        [comp onAddToHost:self];
//    }
//    
//    [self addLightAndCameraToScene];
    
    if (component == nil) {
        return;
    }
    if ([component conformsToProtocol:@protocol(JICamera)]) {
        if (mCamera != nil) { // 只能绑定一个Camera
            return;
        }
        mCamera = (id<JICamera>)component;
        [self.scene addCamera:mCamera];
    } else if ([component conformsToProtocol:@protocol(JILight)]) {
        if (mLight != nil) { // 只能绑定一个Light
            return;
        }
        mLight = (id<JILight>)component;
        [self.scene addLight:mLight];
    }  else if ([component conformsToProtocol:@protocol(JIViewTag)]) { // 由于JIViewTag也是JIRenderable，故需要在其之前判断
        if (mViewTag != nil) { // 只能绑定一个ViewTag
            return;
        }
        mViewTag = (id<JIViewTag>)component;
    }  else if ([component conformsToProtocol:@protocol(JIRenderable)]) {
        if (mRenderable != nil) { // 只能绑定一个Renderable
            return;
        }
        mRenderable = (id<JIRenderable>)component;
    }  else if ([component conformsToProtocol:@protocol(JIBehaviour)]) {
        if (mBehaviour != nil) { // 只能绑定一个Behaviour
            return;
        }
        mBehaviour = (id<JIBehaviour>)component;
    }  else if ([component conformsToProtocol:@protocol(JIAnimation)]) {
        id<JIAnimation> animation = (id<JIAnimation>)component;
        if (mAnimationSet == nil) { // 创建animationSet并添加animation
            mAnimationSet = [mContext createAnimationSet];
        }
        [mAnimationSet addAnimation:animation];
    } else if ([component conformsToProtocol:@protocol(JIAnimationSet)]) {
        if (mAnimationSet != nil) { // 只能绑定一个AnimationSet
            return;
        }
        mAnimationSet = (id<JIAnimationSet>)component;
    } else if ([component conformsToProtocol:@protocol(JIPhysicalProperty)]) {
        if (mPhysicalProperty != nil) { // 只能绑定一个PhysicalProperty
            return;
        }
        mPhysicalProperty = (id<JIPhysicalProperty>)component;
    } else if ([component conformsToProtocol:@protocol(JIParticle)]) {
        if (mParticle != nil) { // 只能绑定一个Particle
            return;
        }
        mParticle = (id<JIParticle>)component;
    } else if ([component conformsToProtocol:@protocol(JIParticleSystem)]) {
        if (mParticleSystem != nil) { // 只能绑定一个ParticleSystem
            return;
        }
        mParticleSystem = (id<JIParticleSystem>)component;
    } else if ([component conformsToProtocol:@protocol(JIARImageTarget)]) {
        if (mARImageTarget != nil) { // 只能绑定一个ARImageTarget
            return;
        }
        mARImageTarget = (id<JIARImageTarget>)component;
    } else if ([component conformsToProtocol:@protocol(JIComponentSet)]) {
        if (mComponentSet != nil) { // 只能绑定一个ComponentSet
            return;
        }
        mComponentSet = (id<JIComponentSet>)component;
    } else {
        return;
    }
    JWComponent* comp = component;
    [comp onAddToHost:self];
}

- (void)removeComponent:(id<JIComponent>)component
{
//    if (component == nil)
//        return;
//    
//    if ([self.componentList removeObject:component]) {
//        if ((id<JIComponent>)mCamera == component) {
//            mCamera = nil;
//        } else if ((id<JIComponent>)mLight == component) {
//            mLight = nil;
//        }
//        
//        if ([component conformsToProtocol:@protocol(JIRenderable)]) {
//            [self updateBounds:NO];
//        } else if ([component conformsToProtocol:@protocol(JIARImageTarget)]) {
//            id<JIARSystem> arSystem = mContext.arSystem;
//            id<JIARImageTarget> arImageTarget = (id<JIARImageTarget>)component;
//            [arSystem.imageTracker unregisterImageTarget:arImageTarget];
//        }
//        JWComponent* comp = component;
//        [comp onRemoveFromHost:self];
//    }
//    
//    [self removeLightAndCameraFromScene];
    if (component == nil) {
        return;
    }
    if (component == mCamera) {
        [self.scene removeCamera:mCamera];
        mCamera = nil;
    } else if (component == mLight) {
        [self.scene removeLight:mLight];
        mLight = nil;
    } else if (component == mRenderable) {
        mRenderable = nil;
    } else if (component == mBehaviour) {
        mBehaviour = nil;
    } else if (component == mViewTag) {
        mViewTag = nil;
    } else if ([component conformsToProtocol:@protocol(JIAnimation)]) {
        if (mAnimationSet != nil) {
            id<JIAnimation> animation = (id<JIAnimation>)component;
            [mAnimationSet removeAnimation:animation];
        }
    } else if (component == mAnimationSet) {
        mAnimationSet = nil;
    } else if (component == mPhysicalProperty) {
        mPhysicalProperty = nil;
    } else if (component == mParticle) {
        mParticle = nil;
    } else if (component == mParticleSystem) {
        mParticleSystem = nil;
    } else if (component == mARImageTarget) {
        mARImageTarget = nil;
    } else if (component == mComponentSet) {
        mComponentSet = nil;
    }
    JWComponent* comp = component;
    [comp onRemoveFromHost:self];
}

- (void)removeAllComponents
{
//    __block BOOL needToUpdataBounds = NO;
//    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//        id<JIComponent> component = obj;
//        if ([component conformsToProtocol:@protocol(JIRenderable)])
//            needToUpdataBounds = YES;
//        JWComponent* comp = component;
//        [comp onRemoveFromHost:self];
//    }];
//    [self.componentList clear];
//    mCamera = nil;
//    mLight = nil;
//    
//    if (needToUpdataBounds)
//        [self updateBounds:NO];
    [self.scene removeCamera:mCamera];
    mCamera = nil;
    [self.scene removeLight:mLight];
    mLight = nil;
    mRenderable = nil;
    mBehaviour = nil;
    mViewTag = nil;
    mAnimationSet = nil;
    mPhysicalProperty = nil;
    mParticle = nil;
    mParticleSystem = nil;
    mARImageTarget = nil;
    if (mComponentSet != nil) {
        [mComponentSet.components enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
            JWComponent* comp = obj;
            [comp onRemoveFromHost:self];
        }];
    }
    mComponentSet = nil;
}

- (id<JICamera>)camera {
    return mCamera;
}

- (id<JILight>)light {
    return mLight;
}

- (id<JIRenderable>)renderable {
    return mRenderable;
}

- (id<JIBehaviour>)behaviour {
    return mBehaviour;
}

- (id<JIViewTag>)viewTag {
    return mViewTag;
}

- (id<JIAnimationSet>)animations {
    return mAnimationSet;
}

- (id<JIPhysicalProperty>)physicalProperty {
    return mPhysicalProperty;
}

- (id<JIParticle>)particle {
    return mParticle;
}

- (id<JIParticleSystem>)particleSystem {
    return mParticleSystem;
}

- (id<JIARImageTarget>)arImageTarget {
    return mARImageTarget;
}

- (void)enumRenderableUsing:(void (^)(id<JIRenderable>, NSUInteger, BOOL *))block {
    __block NSUInteger renderableIndex = 0;
    __block BOOL renderableStop = NO;
    if (mRenderable != nil) {
        block(mRenderable, renderableIndex, &renderableStop);
        renderableIndex++;
    }
    if (renderableStop) {
        return;
    }
    [mTransform enumChildrenUsing:^(id<JITransform> child, NSUInteger idx, BOOL *tstop) {
        id<JIGameObject> childObject = child.host;
        [childObject enumRenderableUsing:^(id<JIRenderable> renderable, NSUInteger idx, BOOL *stop) {
            block(renderable, renderableIndex, &renderableStop);
            if (renderableStop) {
                *stop = YES;
                *tstop = YES;
            }
            renderableIndex++;
        }];
    }];
}

- (NSUInteger)queryMask {
    return mQueryMask;
}

- (void)setQueryMask:(NSUInteger)queryMask {
    mQueryMask = queryMask;
}

- (void)setQueryMask:(NSUInteger)queryMask recursive:(BOOL)recursive {
    mQueryMask = queryMask;
    if (recursive) {
        [mTransform enumChildrenUsing:^(id<JITransform> child, NSUInteger idx, BOOL *stop) {
            id<JIGameObject> childObject = child.host;
            [childObject setQueryMask:queryMask recursive:recursive];
        }];
    }
}

- (JCRayBounds3IntersectResult)queryByRay:(JCRay3)ray {
    [self updateBounds];
//    return JCRayBounds3Intersect(&ray, &mTransformBounds);
    return JCRayBounds3Intersect(&ray, &mTransformBoundsByStretch); // NOTE 改为用拉伸过的bounds求交
}

- (BOOL)queryByBounds:(JCBounds3)bounds {
    [self updateBounds];
//    JCBounds3 lb = self.transformBounds;
    JCBounds3 lb = mTransformBoundsByStretch; // NOTE 改为用拉伸过的bounds求交
    JCBounds3 rb = bounds;
    return JCBounds3Collide(&lb, &rb) ? YES : NO;
}

- (BOOL)queryByObject:(id<JIGameObject>)object {
    [self updateBounds];
    [object updateBounds:YES];
//    JCBounds3 lb = self.transformBounds;
//    JCBounds3 rb = object.transformBounds;
    JCBounds3 lb = mTransformBoundsByStretch; // NOTE 改为用拉伸过的bounds求交
    JCBounds3 rb = object.transformBoundsByStretch;
    return JCBounds3Collide(&lb, &rb) ? YES : NO;
}

- (id<JIAnimation>)animationForId:(NSString *)Id recursive:(BOOL)recursive {
    __block id<JIAnimation> animation = nil;
    if (mAnimationSet != nil) {
        animation = [mAnimationSet animationForId:Id];
        if (animation != nil) {
            return animation;
        }
    }
    [mTransform enumChildrenUsing:^(id<JITransform> child, NSUInteger idx, BOOL *stop) {
        id<JIGameObject> childObject = child.host;
        id<JIAnimationSet> animationSet = childObject.animations;
        if (animationSet != nil) {
            animation = [animationSet animationForId:Id];
            if (animation != nil) {
                *stop = YES;
                return;
            }
        }
        if (recursive) {
            animation = [childObject animationForId:Id recursive:recursive];
            if (animation != nil) {
                *stop = YES;
                return;
            }
        }
    }];
    return animation;
}

- (NSArray<id<JIAnimation>> *)allAnimations {
    NSMutableArray* animations = [NSMutableArray array];
    [mTransform enumChildrenUsing:^(id<JITransform> child, NSUInteger idx, BOOL *stop) {
        id<JIGameObject> childObject = child.host;
        id<JIAnimationSet> animationSet = childObject.animations;
        if (animationSet != nil) {
            [animationSet enumAnimationUsing:^(id<JIAnimation> animation, NSUInteger idx, BOOL *stop) {
                [animations addObject:animation];
            }];
        }
        [animations addAll:childObject.allAnimations];
    }];
    return animations;
}

- (id<JIGameObject>)objectForId:(NSString *)Id {
    return [self objectForId:Id recursive:NO];
}

- (id<JIGameObject>)objectForId:(NSString *)Id recursive:(BOOL)recursive
{
    __block id<JIGameObject> object = nil;
    [mTransform enumChildrenUsing:^(id<JITransform> child, NSUInteger idx, BOOL *stop) {
        id<JIGameObject> childObject = child.host;
        if ([NSString is:childObject.Id equalsTo:Id]) {
            object = childObject;
            *stop = YES;
            return;
        }
        if (recursive) {
            object = [childObject objectForId:Id recursive:recursive];
            if (object != nil) {
                *stop = YES;
                return;
            }
        }
    }];
    return object;
}

- (id<JIGameObject>)objectForName:(NSString *)name {
    return [self objectForName:name recursive:NO];
}

- (id<JIGameObject>)objectForName:(NSString *)name recursive:(BOOL)recursive {
    __block id<JIGameObject> object = nil;
    [mTransform enumChildrenUsing:^(id<JITransform> child, NSUInteger idx, BOOL *stop) {
        id<JIGameObject> childObject = child.host;
        if ([NSString is:childObject.name equalsTo:name]) {
            object = childObject;
            *stop = YES;
            return;
        }
        if (recursive) {
            object = [childObject objectForName:name recursive:recursive];
            if (object != nil) {
                *stop = YES;
                return;
            }
        }
    }];
    return object;
}

- (id<JIGameObject>)copyInstanceWithPrefix:(NSString *)prefix {
    return [self copyInstanceUsingFilter:nil withPrefix:prefix];
}

- (id<JIGameObject>)copyInstanceUsingFilter:(JWGameObjectCopyInstanceFilterBlock)filter withPrefix:(NSString *)prefix {
    if (filter != nil && !filter(self, nil)) {
        return nil;
    }
    id<JIGameObject> newObject = [mContext createObject];
    if (prefix == nil) {
        newObject.Id = mId;
        newObject.name = mName;
    } else {
        newObject.Id = [NSString stringWithFormat:@"%@%@", prefix, mId];
        newObject.name = [NSString stringWithFormat:@"%@%@", prefix, mName];
    }
    [newObject.transform copyTransform:mTransform inWorld:NO];
    // TODO 暂时只复制以下组件
    id<JIComponent> component = mRenderable;
    if (component != nil && (filter == nil || filter(self, component))) {
        [newObject addComponent:[component copyInstance]];
    }
    component = mAnimationSet;
    if (component != nil && (filter == nil || filter(self, component))) {
        [newObject addComponent:[component copyInstance]];
    }
    [mTransform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> transform = obj;
        id<JIGameObject> child = transform.host;
        id<JIGameObject> newChild = [child copyInstanceUsingFilter:filter withPrefix:prefix];
        newChild.parent = newObject;
    }];
    return newObject;
}

- (id<JIRenderQueue>)renderQueue {
    return mRenderQueue;
}

@synthesize extra = mExtra;

- (id<JIRenderable>)axes {
    float axisLength = mAxisLength;
    if (mAxes == nil) {
        NSString* meshName = [NSString stringWithFormat:@"axes@%@", self.Id];
        id<JIFile> file = [JWFile fileWithName:meshName content:nil];
        id<JIMesh> mesh = (id<JIMesh>)[mContext.meshManager createFromFile:file];
        mesh.name = meshName;
        [mesh makeWithNumVertices:6 numIndices:6];
        [mesh beginOperation:JCRenderOperationLines update:NO];
        [mesh position:JCVector3Zero()];
        [mesh color:JCColorRed()];
        [mesh positionX:axisLength y:0.0f z:0.0f];
        [mesh position:JCVector3Zero()];
        [mesh color:JCColorGreen()];
        [mesh positionX:0.0f y:axisLength z:0.0f];
        [mesh position:JCVector3Zero()];
        [mesh color:JCColorBlue()];
        [mesh positionX:0.0f y:0.0f z:axisLength];
        [mesh lineStart:0 end:1];
        [mesh lineStart:2 end:3];
        [mesh lineStart:4 end:5];
        [mesh end];
        [mesh load];
        id<JIMeshRenderer> meshRenderer = [mContext createMeshRenderer];
        meshRenderer.mesh = mesh;
        JWComponent* comp = meshRenderer;
        [comp onAddToHost:self];
        mAxes = meshRenderer;
    }
    return mAxes;
}

@synthesize axisLength = mAxisLength;

- (void)setAxesVisible:(BOOL)visible recursive:(BOOL)recursive {
    self.axes.visible = visible;
    [mTransform enumChildrenUsing:^(id<JITransform> child, NSUInteger idx, BOOL *stop) {
        id<JIGameObject> childObject = child.host;
        [childObject setAxesVisible:visible recursive:recursive];
    }];
}

- (void)onUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime {
    if (!mEnable || ![self canToggleEvent]) {
        return;
    }
    //[self.componentList update];
    [mComponentSet.components update];
    [self onObjectUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
}

- (void) onObjectUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime {
    if (mBoundsDirty) {
        [self updateBounds:YES];
        mBoundsDirty = NO;
    }
    
    [self.transform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> child = obj;
        [child.host onUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
    }];
    
//    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//        id<JIComponent> comp = obj;
//        [comp onUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
//    }];
    [mCamera onUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
    [mLight onUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
    [mRenderable onUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
    [mBehaviour onUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
    [mViewTag onUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
    [mAnimationSet onUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
    [mPhysicalProperty onUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
    [mParticle onUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
    [mParticleSystem onUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
    [mComponentSet onUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
}

#pragma events begin

- (BOOL)onTouchDown:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!mEnable || ![self canToggleEvent]) {
        return NO;
    }
    
//    __block BOOL b = NO;
//    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//        id<JIComponent> component = obj;
//        if (!component.isEnabled) {
//            return;
//        }
//        if ([component isKindOfClass:[JWBehaviour class]])
//        {
//            JWBehaviour* behaviour = (JWBehaviour*)component;
//            if ([behaviour onScreenTouchDown:touches withEvent:event])
//            {
//                b = YES;
//                *stop = YES;
//            }
//        }
//    }];
//    if (b)
//        return YES;
    BOOL b = NO;
    if (mBehaviour != nil && mBehaviour.isEnabled) {
        b = [mBehaviour onScreenTouchDown:touches withEvent:event];
        if (b) {
            return YES;
        }
    }
    b = [mComponentSet onTouchDown:touches withEvent:event];
    if (b) {
        return YES;
    }
    
    [mTransform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> ct = obj;
        id<JIGameObject> child = ct.host;
        [child onTouchDown:touches withEvent:event];
    }];
    return NO;
}

- (BOOL)onTouchMove:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!mEnable || ![self canToggleEvent]) {
        return NO;
    }
    
//    __block BOOL b = NO;
//    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//        id<JIComponent> component = obj;
//        if (!component.isEnabled) {
//            return;
//        }
//        if ([component isKindOfClass:[JWBehaviour class]])
//        {
//            JWBehaviour* behaviour = (JWBehaviour*)component;
//            if ([behaviour onScreenTouchMove:touches withEvent:event])
//            {
//                b = YES;
//                *stop = YES;
//            }
//        }
//    }];
//    if (b)
//        return YES;
    BOOL b = NO;
    if (mBehaviour != nil && mBehaviour.isEnabled) {
        b = [mBehaviour onScreenTouchMove:touches withEvent:event];
        if (b) {
            return YES;
        }
    }
    b = [mComponentSet onTouchMove:touches withEvent:event];
    if (b) {
        return YES;
    }
    
    [mTransform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> ct = obj;
        id<JIGameObject> child = ct.host;
        [child onTouchMove:touches withEvent:event];
    }];
    return NO;
}

- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!mEnable || ![self canToggleEvent]) {
        return NO;
    }
    
//    __block BOOL b = NO;
//    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//        id<JIComponent> component = obj;
//        if (!component.isEnabled) {
//            return;
//        }
//        if ([component isKindOfClass:[JWBehaviour class]])
//        {
//            JWBehaviour* behaviour = (JWBehaviour*)component;
//            if ([behaviour onScreenTouchUp:touches withEvent:event])
//            {
//                b = YES;
//                *stop = YES;
//            }
//        }
//    }];
//    if (b)
//        return YES;
    BOOL b = NO;
    if (mBehaviour != nil && mBehaviour.isEnabled) {
        b = [mBehaviour onScreenTouchUp:touches withEvent:event];
        if (b) {
            return YES;
        }
    }
    b = [mComponentSet onTouchUp:touches withEvent:event];
    if (b) {
        return YES;
    }
    
    [mTransform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> ct = obj;
        id<JIGameObject> child = ct.host;
        [child onTouchUp:touches withEvent:event];
    }];
    return NO;
}

- (BOOL)onTouchCancel:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!mEnable || ![self canToggleEvent]) {
        return NO;
    }
    
//    __block BOOL b = NO;
//    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//        id<JIComponent> component = obj;
//        if (!component.isEnabled) {
//            return;
//        }
//        if ([component isKindOfClass:[JWBehaviour class]])
//        {
//            JWBehaviour* behaviour = (JWBehaviour*)component;
//            if ([behaviour onScreenTouchCancel:touches withEvent:event])
//            {
//                b = YES;
//                *stop = YES;
//            }
//        }
//    }];
//    if (b)
//        return YES;
    BOOL b = NO;
    if (mBehaviour != nil && mBehaviour.isEnabled) {
        b = [mBehaviour onScreenTouchCancel:touches withEvent:event];
        if (b) {
            return YES;
        }
    }
    b = [mComponentSet onTouchCancel:touches withEvent:event];
    if (b) {
        return YES;
    }
    
    [mTransform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> ct = obj;
        id<JIGameObject> child = ct.host;
        [child onTouchCancel:touches withEvent:event];
    }];
    return NO;
}

- (void)onPinch:(UIPinchGestureRecognizer *)pinch {
    if (!mEnable || ![self canToggleEvent]) {
        return;
    }
    
//    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//        id<JIComponent> component = obj;
//        if (!component.isEnabled) {
//            return;
//        }
//        if ([component isKindOfClass:[JWBehaviour class]])
//        {
//            JWBehaviour* behaviour = (JWBehaviour*)component;
//            [behaviour onPinch:pinch];
//        }
//    }];
    if (mBehaviour != nil && mBehaviour.isEnabled) {
        [mBehaviour onPinch:pinch];
    }
    [mComponentSet onPinch:pinch];
    
    [mTransform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> ct = obj;
        id<JIGameObject> child = ct.host;
        [child onPinch:pinch];
    }];
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap {
    if (!mEnable || ![self canToggleEvent]) {
        return;
    }
    
//    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//        id<JIComponent> component = obj;
//        if (!component.isEnabled) {
//            return;
//        }
//        if ([component isKindOfClass:[JWBehaviour class]])
//        {
//            JWBehaviour* behaviour = (JWBehaviour*)component;
//            [behaviour onSingleTap:singleTap];
//        }
//    }];
    if (mBehaviour != nil && mBehaviour.isEnabled) {
        [mBehaviour onSingleTap:singleTap];
    }
    [mComponentSet onSingleTap:singleTap];
    
    [mTransform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> ct = obj;
        id<JIGameObject> child = ct.host;
        [child onSingleTap:singleTap];
    }];
}

- (void)onDoubleTap:(UITapGestureRecognizer *)doubleTap {
    if (!mEnable || ![self canToggleEvent]) {
        return;
    }
    
//    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//        id<JIComponent> component = obj;
//        if (!component.isEnabled) {
//            return;
//        }
//        if ([component isKindOfClass:[JWBehaviour class]])
//        {
//            JWBehaviour* behaviour = (JWBehaviour*)component;
//            [behaviour onDoubleTap:doubleTap];
//        }
//    }];
    if (mBehaviour != nil && mBehaviour.isEnabled) {
        [mBehaviour onDoubleTap:doubleTap];
    }
    [mComponentSet onDoubleTap:doubleTap];
    
    [mTransform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> ct = obj;
        id<JIGameObject> child = ct.host;
        [child onDoubleTap:doubleTap];
    }];
}

- (void)onDoubleDrag:(UIPanGestureRecognizer *)doubleDrag {
    if (!mEnable || ![self canToggleEvent]) {
        return;
    }
    
    //    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
    //        id<JIComponent> component = obj;
    //        if (!component.isEnabled) {
    //            return;
    //        }
    //        if ([component isKindOfClass:[JWBehaviour class]])
    //        {
    //            JWBehaviour* behaviour = (JWBehaviour*)component;
    //            [behaviour onDoubleTap:doubleTap];
    //        }
    //    }];
    if (mBehaviour != nil && mBehaviour.isEnabled) {
        [mBehaviour onDoubleDrag:doubleDrag];
    }
    [mComponentSet onDoubleDrag:doubleDrag];
    
    [mTransform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> ct = obj;
        id<JIGameObject> child = ct.host;
        [child onDoubleDrag:doubleDrag];
    }];
}

- (void)onLongPress:(UILongPressGestureRecognizer *)longPress {
    if (!mEnable || ![self canToggleEvent]) {
        return;
    }
    
    //    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
    //        id<JIComponent> component = obj;
    //        if (!component.isEnabled) {
    //            return;
    //        }
    //        if ([component isKindOfClass:[JWBehaviour class]])
    //        {
    //            JWBehaviour* behaviour = (JWBehaviour*)component;
    //            [behaviour onDoubleTap:doubleTap];
    //        }
    //    }];
    if (mBehaviour != nil && mBehaviour.isEnabled) {
        [mBehaviour onLongPress:longPress];
    }
    [mComponentSet onLongPress:longPress];
    
    [mTransform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> ct = obj;
        id<JIGameObject> child = ct.host;
        [child onLongPress:longPress];
    }];
}

- (void)onGamepad:(id<JIGamepad>)gamepad {
    if (!mEnable || ![self canToggleEvent]) {
        return;
    }
    
    if (mBehaviour != nil && mBehaviour.isEnabled) {
        [mBehaviour onGamepad:gamepad];
    }
    [mComponentSet onGamepad:gamepad];
    
    [mTransform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> ct = obj;
        id<JIGameObject> child = ct.host;
        [child onGamepad:gamepad];
    }];
}

- (BOOL) canToggleEvent
{
    id<JIGameScene> scene = self.scene;
    if (mCamera != nil && (scene != nil && mCamera != scene.currentCamera))
        return NO;
    return YES;
}

#pragma events end

- (void) addLightAndCameraToScene {
    id<JIGameScene> scene = self.scene;
    if (scene != nil) {
        [scene addCamera:mCamera];
        [scene addLight:mLight];
    }
}

- (void) removeLightAndCameraFromScene {
    id<JIGameScene> scene = self.scene;
    if (scene != nil) {
        [scene removeCamera:mCamera];
        [scene removeLight:mLight];
    }
}

- (void)onAttachToObject:(id<JIGameObject>)parent
{
    JWGameObject* par = parent;
    [self addLightAndCameraToScene];
    [self notifyQueue:par.renderQueue];
}

- (void)onDetachFromObject:(id<JIGameObject>)parent
{
    [self removeLightAndCameraFromScene];
    [self notifyQueue:nil];
}

- (void)onAddToScene:(id<JIGameScene>)scene
{
    if (scene == nil)
        return;
    
    mScene = scene;
    [self addLightAndCameraToScene];
    [self notifyQueue:scene.renderQueue];
}

- (void)onRemoveFromScene:(id<JIGameScene>)scene
{
    mScene = nil;
    [self removeLightAndCameraFromScene];
    [self notifyQueue:nil];
}

- (void)onTransformChanged:(id<JITransform>)transform {
//    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//        JWComponent* component = obj;
//        [component onTransformChanged:transform];
//    }];
    JWComponent* comp = mCamera;
    [comp onTransformChanged:transform];
    comp = mLight;
    [comp onTransformChanged:transform];
    comp = mRenderable;
    [comp onTransformChanged:transform];
    comp = mBehaviour;
    [comp onTransformChanged:transform];
    comp = mViewTag;
    [comp onTransformChanged:transform];
    comp = mAnimationSet;
    [comp onTransformChanged:transform];
    comp = mARImageTarget;
    [comp onTransformChanged:transform];
    [mComponentSet.components enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        JWComponent* component = obj;
        [component onTransformChanged:transform];
    }];
}

- (void) notifyQueue:(id<JIRenderQueue>)queue;
{
    if (mRenderQueue == queue)
        return;
    
//    [self.componentList enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//        id<JIComponent> component = obj;
//        JWComponent* comp = component;
//        [comp notifyQueue:queue];
//    }];
    JWComponent* comp = mCamera;
    [comp notifyQueue:queue];
    comp = mLight;
    [comp notifyQueue:queue];
    comp = mRenderable;
    [comp notifyQueue:queue];
    comp = mBehaviour;
    [comp notifyQueue:queue];
    comp = mAnimationSet;
    [comp notifyQueue:queue];
    comp = mARImageTarget;
    [comp notifyQueue:queue];
    [mComponentSet.components enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        JWComponent* component = obj;
        [component notifyQueue:queue];
    }];
    
    [mTransform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> child  = obj;
        JWGameObject* childObject = child.host;
        [childObject notifyQueue:queue];
    }];
    
    mRenderQueue = queue;
}

- (NSString *)description
{
    NSString* string = [NSString stringWithFormat:@"obj(%@, %@)", mId, mName];
    return string;
}

- (void)dumpTree {
    NSMutableString* tree = [NSMutableString string];
    [self appendChildDescriptionTo:tree prefix:@"|--"];
    NSLog(@"%@", tree);
}

- (void) appendChildDescriptionTo:(NSMutableString*)description prefix:(NSString*)prefix {
    [description appendFormat:@"\n%@(%@) %@", prefix, @(mTransform.numChildren), self.description];
    NSString* newPrefix = [NSString stringWithFormat:@"|   %@", prefix];
    [mTransform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> child  = obj;
        JWGameObject* childObject = child.host;
        [childObject appendChildDescriptionTo:description prefix:newPrefix];
    }];
}

- (void)dumpDetails {
    NSMutableString* tree = [NSMutableString string];
    [self appendChildDetailsDescriptionTo:tree prefix:@"|--"];
    NSLog(@"%@", tree);
}

- (void) appendChildDetailsDescriptionTo:(NSMutableString*)description prefix:(NSString*)prefix {
    //NSString* desc = self.description;
    NSString* desc = self.renderable.description;
    NSArray* lines = [desc componentsSeparatedByString:@"\n"];
    if (lines.count == 1) {
        [description appendFormat:@"\n%@%@", prefix, desc];
    } else if (lines.count > 1) {
        NSString* line0 = [lines at:0];
        [description appendFormat:@"\n%@%@", prefix, line0];
        for (NSUInteger i = 1; i < lines.count; i++) {
            NSString* line = [lines at:i];
            [description appendFormat:@"\n%@  *%@", prefix, line];
        }
    }
    //[description appendFormat:@"\n%@%@", prefix, self.description];
    NSString* newPrefix = [NSString stringWithFormat:@"|   %@", prefix];
    [mTransform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> child  = obj;
        JWGameObject* childObject = child.host;
        [childObject appendChildDetailsDescriptionTo:description prefix:newPrefix];
    }];
}

@end
