//
//  JWMeshRenderer.m
//  June Winter
//
//  Created by GavinLo on 14/10/21.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWMeshRenderer.h"
#import "JWMesh.h"
#import "JWSkeleton.h"
#import "JWEffectManager.h"
#import "JWGameObject.h"
#import "JWGameScene.h"

@implementation JWMeshRenderer

- (id<JIEffect>)effect
{
    if(mWillAutoEffect)
    {
        // TODO 优化查找
        id<JIGameObject> host = self.host;
        id<JIGameScene> scene = host.scene;
        id<NSFastEnumeration> lights = scene.lights;
        mEffect = (id<JIEffect>)[mContext.effectManager createByGameObject:self.host mesh:mMesh material:mMaterial lights:lights];
        if(mEffect != nil)
            return mEffect;
    }
    return mEffect;
}

- (JCBounds3)bounds
{
    if(mMesh == nil)
        return mBounds;
    return mMesh.bounds;
}

- (id<JIMesh>)mesh
{
    return mMesh;
}

- (void)setMesh:(id<JIMesh>)mesh
{
    mMesh = mesh;
}

@synthesize skeleton = mSkeleton;

- (id<JIComponent>)copyInstance {
    JWMeshRenderer* mr = [mContext createMeshRenderer];
    mr.mesh = mMesh;
    // TODO skeleton copy
    mr.material = mMaterial;
    mr.effect = mEffect;
    mr.autoEffect = mWillAutoEffect;
    return mr;
}

@end
