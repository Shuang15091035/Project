//
//  JWRenderable.h
//  June Winter
//
//  Created by GavinLo on 14-5-2.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWComponent.h>
#import <jw/JCBounds3.h>

typedef NS_ENUM(NSInteger, JWRenderOrder) {
    JWRenderOrderBackgroundBegin       = 0,
    JWRenderOrderBackgroundDefault     = JWRenderOrderBackgroundBegin + 1,
    JWRenderOrderBackgroundEnd         = JWRenderOrderBackgroundBegin + 10,
    JWRenderOrderLightBegin            = JWRenderOrderBackgroundEnd + 1,
    JWRenderOrderLightDefault          = JWRenderOrderLightBegin + 1,
    JWRenderOrderLightEnd              = JWRenderOrderLightBegin + 10,
    JWRenderOrderObjectBegin           = JWRenderOrderLightEnd + 1,
    JWRenderOrderObjectDefault         = JWRenderOrderObjectBegin + 1,
    JWRenderOrderObjectEnd             = JWRenderOrderObjectBegin + 10000,
    JWRenderOrderUiBegin               = JWRenderOrderObjectEnd + 1,
    JWRenderOrderUiDefault             = JWRenderOrderUiBegin + 1,
    JWRenderOrderUiEnd                 = JWRenderOrderUiBegin + 10000,
};

@protocol JIRenderable <JIComponent>

- (void) render:(id<JICamera>)camera;

@property (nonatomic, readwrite) NSInteger renderOrder;
@property (nonatomic, readwrite, getter=isVisible) BOOL visible;

@property (nonatomic, readonly) id<JIRenderQueue> renderQueue;
@property (nonatomic, readonly) JCBounds3 bounds;
- (void) updateBounds:(BOOL)immediate;

@property (nonatomic, readwrite) id<JIMaterial> material;
@property (nonatomic, readwrite) id<JIEffect> effect;
@property (nonatomic, readwrite, getter=willAutoEffect) BOOL autoEffect;

@end

@interface JWRenderable : JWComponent <JIRenderable> {
    NSInteger mRenderOrder;
    BOOL mVisible;
    
    id<JIRenderQueue> mRenderQueue;
    JCBounds3 mBounds;
    BOOL mBoundsDirty;
    
    id<JIMaterial> mMaterial;
    id<JIEffect> mEffect;
    BOOL mWillAutoEffect;
}

- (void) updateBoundsImmediate;
- (void) notifyQueue:(id<JIRenderQueue>)queue;

@end
