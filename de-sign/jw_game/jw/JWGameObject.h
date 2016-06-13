//
//  JWGameObject.h
//  June Winter
//
//  Created by GavinLo on 14-4-12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWEntity.h>
#import <jw/JWTimer.h>
#import <jw/JWMutableArray.h>
#import <jw/JWTransform.h>
#import <jw/JCBounds3.h>
#import <jw/JCStretch.h>
#import <jw/JWGameContext.h>
#import <jw/JWGameEvents.h>
#import <jw/JCGeometryUtils.h>

typedef NS_OPTIONS(NSUInteger, JWGameObjectAlignment) {
    JWGameObjectAlignNone = 0,
    /**
     * 物件bounds的左对齐
     */
    JWGameObjectAlignNX = 0x1 << 0,
    /**
     * 物件bounds的右对齐
     */
    JWGameObjectAlignPX = 0x1 << 1,
    /**
     * 物件bounds的水品居中
     */
    JWGameObjectAlignCX = 0x1 << 2,
    /**
     * 物件bounds的下对齐
     */
    JWGameObjectAlignNY = 0x1 << 3,
    /**
     * 物件bounds的上对齐
     */
    JWGameObjectAlignPY = 0x1 << 4,
    /**
     * 物件bounds的垂直居中
     */
    JWGameObjectAlignCY = 0x1 << 5,
    /**
     * 物件bounds的里对齐
     */
    JWGameObjectAlignNZ = 0x1 << 6,
    /**
     * 物件bounds的外对齐
     */
    JWGameObjectAlignPZ = 0x1 << 7,
    /**
     * 物件bounds的里外居中
     */
    JWGameObjectAlignCZ = 0x1 << 8,
    
    // XY平面
    JWGameObjectAlignNXNY = JWGameObjectAlignNX | JWGameObjectAlignNY,
    JWGameObjectAlignPXNY = JWGameObjectAlignPX | JWGameObjectAlignNY,
    JWGameObjectAlignPXPY = JWGameObjectAlignPX | JWGameObjectAlignPY,
    JWGameObjectAlignNXPY = JWGameObjectAlignNX | JWGameObjectAlignPY,
    JWGameObjectAlignCXNY = JWGameObjectAlignCX | JWGameObjectAlignNY,
    JWGameObjectAlignPXCY = JWGameObjectAlignPX | JWGameObjectAlignCY,
    JWGameObjectAlignCXPY = JWGameObjectAlignCX | JWGameObjectAlignPY,
    JWGameObjectAlignNXCY = JWGameObjectAlignNX | JWGameObjectAlignCY,
    JWGameObjectAlignCXCY = JWGameObjectAlignCX | JWGameObjectAlignCY,
    // YZ平面
    JWGameObjectAlignNYNZ = JWGameObjectAlignNY | JWGameObjectAlignNZ,
    JWGameObjectAlignPYNZ = JWGameObjectAlignPY | JWGameObjectAlignNZ,
    JWGameObjectAlignPYPZ = JWGameObjectAlignPY | JWGameObjectAlignPZ,
    JWGameObjectAlignNYPZ = JWGameObjectAlignNY | JWGameObjectAlignPZ,
    JWGameObjectAlignCYNZ = JWGameObjectAlignCY | JWGameObjectAlignNZ,
    JWGameObjectAlignPYCZ = JWGameObjectAlignPY | JWGameObjectAlignCZ,
    JWGameObjectAlignCYPZ = JWGameObjectAlignCY | JWGameObjectAlignPZ,
    JWGameObjectAlignNYCZ = JWGameObjectAlignNY | JWGameObjectAlignCZ,
    JWGameObjectAlignCYCZ = JWGameObjectAlignCY | JWGameObjectAlignCZ,
    // ZX平面
    JWGameObjectAlignNZNX = JWGameObjectAlignNZ | JWGameObjectAlignNX,
    JWGameObjectAlignPZNX = JWGameObjectAlignPZ | JWGameObjectAlignNX,
    JWGameObjectAlignPZPX = JWGameObjectAlignPZ | JWGameObjectAlignPX,
    JWGameObjectAlignNZPX = JWGameObjectAlignNZ | JWGameObjectAlignPX,
    JWGameObjectAlignCZNX = JWGameObjectAlignCZ | JWGameObjectAlignNX,
    JWGameObjectAlignPZCX = JWGameObjectAlignPZ | JWGameObjectAlignCX,
    JWGameObjectAlignCZPX = JWGameObjectAlignCZ | JWGameObjectAlignPX,
    JWGameObjectAlignNZCX = JWGameObjectAlignNZ | JWGameObjectAlignCX,
    JWGameObjectAlignCZCX = JWGameObjectAlignCZ | JWGameObjectAlignCX,
    // XYZ
    JWGameObjectAlignCXNYCZ = JWGameObjectAlignCX | JWGameObjectAlignNY | JWGameObjectAlignCZ,
    JWGameObjectAlignCXCYCZ = JWGameObjectAlignCX | JWGameObjectAlignCY | JWGameObjectAlignCZ,
};

typedef BOOL (^JWGameObjectCopyInstanceFilterBlock)(id<JIGameObject> object, id<JIComponent> component);

@protocol JIGameObject <JIEntity, JITimeUpdatable, JIGameEvents>

@property (nonatomic, readonly) id<JIGameContext> context;
@property (nonatomic, readonly) id<JIGameScene> scene;
@property (nonatomic, readwrite, getter=isEnabled) BOOL enabled;
@property (nonatomic, readwrite, getter=isVisible) BOOL visible;
- (void) setVisible:(BOOL)visible recursive:(BOOL)recursive;

@property (nonatomic, readonly) id<JITransform> transform;
@property (nonatomic, readwrite) id<JIGameObject> parent;
@property (nonatomic, readwrite) JCBounds3 bounds;
@property (nonatomic, readonly) JCBounds3 transformBounds;
@property (nonatomic, readonly) JCBounds3 scaleBounds;

/**
 * 对象的{@link #bounds()}是否可用,不可用代表在父对象更新{@link #bounds()}的时候,忽略该对象的{@link #bounds()}
 */
@property (nonatomic, readwrite, getter=isBoundsEnabled) BOOL boundsEnabled;
- (void) updateBounds:(BOOL)immediate;

/**
 * 拉伸
 */
@property (nonatomic, readwrite) JCStretch stretch;
@property (nonatomic, readwrite) BOOL inheritStretch;
@property (nonatomic, readonly) JCStretch stretchByScale;
@property (nonatomic, readonly) JCBounds3 boundsByStretch;
@property (nonatomic, readonly) JCBounds3 transformBoundsByStretch;
@property (nonatomic, readonly) JCBounds3 scaleBoundsByStretch;

/**
 * 基于对象bounds的对齐
 */
- (BOOL) alignObject:(id<JIGameObject>)object withAlignments:(NSUInteger)alignments;

- (void) addComponent:(id<JIComponent>)component;
- (void) removeComponent:(id<JIComponent>)component;
- (void) removeAllComponents;
@property (nonatomic, readonly) id<JICamera> camera;
@property (nonatomic, readonly) id<JILight> light;
@property (nonatomic, readonly) id<JIRenderable> renderable;
@property (nonatomic, readonly) id<JIBehaviour> behaviour;
@property (nonatomic, readonly) id<JIViewTag> viewTag;
@property (nonatomic, readonly) id<JIAnimationSet> animations;
@property (nonatomic, readonly) id<JIPhysicalProperty> physicalProperty;
@property (nonatomic, readonly) id<JIParticle> particle;
@property (nonatomic, readonly) id<JIParticleSystem> particleSystem;
@property (nonatomic, readonly) id<JIARImageTarget> arImageTarget;
- (void) enumRenderableUsing:(void (^)(id<JIRenderable> renderable, NSUInteger idx, BOOL* stop))block;

@property (nonatomic, readwrite) NSUInteger queryMask;
- (void) setQueryMask:(NSUInteger)queryMask recursive:(BOOL)recursive;
- (JCRayBounds3IntersectResult) queryByRay:(JCRay3)ray;
- (BOOL) queryByBounds:(JCBounds3)bounds;
- (BOOL) queryByObject:(id<JIGameObject>)object;

- (id<JIAnimation>) animationForId:(NSString*)Id recursive:(BOOL)recursive;
@property (nonatomic, readonly) NSArray<id<JIAnimation>>* allAnimations;
- (id<JIGameObject>) objectForId:(NSString*)Id;
- (id<JIGameObject>) objectForId:(NSString*)Id recursive:(BOOL)recursive;
- (id<JIGameObject>) objectForName:(NSString*)name;
- (id<JIGameObject>) objectForName:(NSString*)name recursive:(BOOL)recursive;
- (id<JIGameObject>) copyInstanceWithPrefix:(NSString*)prefix;
- (id<JIGameObject>) copyInstanceUsingFilter:(JWGameObjectCopyInstanceFilterBlock)filter withPrefix:(NSString*)prefix;

@property (nonatomic, readonly) id<JIRenderQueue> renderQueue;
@property (nonatomic, readwrite) id extra;

// debug相关
@property (nonatomic, readonly) id<JIRenderable> axes;
@property (nonatomic, readwrite) float axisLength;
- (void) setAxesVisible:(BOOL)visible recursive:(BOOL)recursive;

/**
 * 打印该节点下的场景结构，调试用
 */
- (void) dumpTree;
- (void) dumpDetails;

@end

@interface JWGameObject : JWEntity <JIGameObject>

- (id) initWithContext:(id<JIGameContext>)context;

- (void) onAttachToObject:(id<JIGameObject>)parent;
- (void) onDetachFromObject:(id<JIGameObject>)parent;
- (void) onAddToScene:(id<JIGameScene>)scene;
- (void) onRemoveFromScene:(id<JIGameScene>)scene;
- (void) onTransformChanged:(id<JITransform>)transform;

@end
