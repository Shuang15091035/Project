//
//  JWParticleSystem.m
//  June Winter_game
//
//  Created by ddeyes on 16/3/2.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWParticleSystem.h"
#import "JWGameObject.h"
#import "JWParticle.h"
#import "JWParticleEmitter.h"
#import "JWPhysicalProperty.h"
#import <jw/JWCoreUtils.h>
#import <jw/JCMath.h>

@interface JWOnParticleSystemListener () {
    JWParticleSystemOnSpawnParticleBlock mOnParticleSpawn;
}

@end

@implementation JWOnParticleSystemListener

+ (id)listener {
    return [[self alloc] init];
}

- (JWParticleSystemOnSpawnParticleBlock)onParticleSpawn {
    return mOnParticleSpawn;
}

- (void)setOnParticleSpawn:(JWParticleSystemOnSpawnParticleBlock)onParticleSpawn {
    mOnParticleSpawn = onParticleSpawn;
}

- (void)onSpawnParticle:(id<JIParticle>)particle {
    if (mOnParticleSpawn != nil) {
        mOnParticleSpawn(particle);
    }
}

@end

@interface JWParticleSystem () {
    id<JIGameObject> mParticleInstance;
    id<JIParticleEmitter> mEmitter;
    NSUInteger mQuota;
    NSUInteger mNumAliveParticles;
    float mMinRate;
    float mMaxRate;
    NSUInteger mSpawnDeathTime;
    JCVector3 mSpawnMinVelocity;
    JCVector3 mSpawnMaxVelocity;
    id<JIOnParticleSystemListener> mListener;
    
    NSMutableArray<id<JIGameObject>>* mParticles;
    float mNumParticlesDueToSpawn;
    BOOL mSpawnVelocityIsFixed;
}

@end

@implementation JWParticleSystem

- (id)initWithContext:(id<JIGameContext>)context {
    self = [super initWithContext:context];
    if (self != nil) {
        mMinRate = 1.0f;
        mMaxRate = 1.0f;
        mSpawnDeathTime = 1000;
        mSpawnVelocityIsFixed = YES;
    }
    return self;
}

- (void)onDestroy {
    
    [super onDestroy];
}

@synthesize particleInstance = mParticleInstance;
@synthesize emitter = mEmitter;

- (NSUInteger)quota {
    return mQuota;
}

- (void)setQuota:(NSUInteger)quota {
    [self clearAllParticles];
    mQuota = quota;
    mParticles = [NSMutableArray arrayWithCapacity:mQuota];
    for (NSUInteger i = 0; i < mQuota; i++) {
        [mParticles add:nil];
    }
}

@synthesize numAliveParticles = mNumAliveParticles;
@synthesize minRate = mMinRate;
@synthesize maxRate = mMaxRate;
@synthesize spawnDeathTime = mSpawnDeathTime;

- (JCVector3)spawnMinVelocity {
    return mSpawnMinVelocity;
}

- (void)setSpawnMinVelocity:(JCVector3)spawnMinVelocity {
    mSpawnMinVelocity = spawnMinVelocity;
    mSpawnVelocityIsFixed = JCVector3Equals(&mSpawnMinVelocity, &mSpawnMaxVelocity) ? YES : NO;
}

- (JCVector3)spawnMaxVelocity {
    return mSpawnMaxVelocity;
}

- (void)setSpawnMaxVelocity:(JCVector3)spawnMaxVelocity {
    mSpawnMaxVelocity = spawnMaxVelocity;
    mSpawnVelocityIsFixed = JCVector3Equals(&mSpawnMinVelocity, &mSpawnMaxVelocity) ? YES : NO;
}

@synthesize listener = mListener;

- (void)onComponentUpdateAtTotalTime:(NSUInteger)totalTime elapsedTime:(NSUInteger)elapsedTime {
    [super onComponentUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
    
    if (mParticles == nil || mParticleInstance == nil || mEmitter == nil) {
        return;
    }

    [self spawnParticles:elapsedTime];
    for (NSInteger i = mNumAliveParticles - 1; i >= 0; i--) {
        id<JIGameObject> particleObject = [mParticles at:i];
        id<JIParticle> particle = particleObject.particle;
        [particleObject onUpdateAtTotalTime:totalTime elapsedTime:elapsedTime];
        if (particle.isDead) {
            particleObject.visible = NO;
            mNumAliveParticles--;
            [mParticles set:i object:[mParticles at:mNumAliveParticles]];
            [mParticles set:mNumAliveParticles object:particleObject];
        }
    }
}

- (void) spawnParticles:(NSUInteger)elapsedTime {
    const float currentRate = mMinRate == mMaxRate ? mMinRate : JCRandomf(mMinRate, mMaxRate);
    const float newParticlesThisFrame = currentRate * ((float)elapsedTime / 1000.0f);
    mNumParticlesDueToSpawn += newParticlesThisFrame;
    const NSUInteger numParticlesToSpawnThisFrame = JCMin(mQuota - mNumAliveParticles, JCFloorf(mNumParticlesDueToSpawn));
    mNumParticlesDueToSpawn -= numParticlesToSpawnThisFrame;
    
    for (NSUInteger i = 0; i < numParticlesToSpawnThisFrame; i++) {
        [self spawnParticle];
    }
}

- (void) spawnParticle {
    if (mNumAliveParticles >= mQuota) {
        return;
    }
    JCVector3 spawnPosition = [mEmitter getSpawnPosition];
    
    id<JIGameObject> particleObject = [mParticles at:mNumAliveParticles];
    if (particleObject == nil) {
        particleObject = [mParticleInstance copyInstanceWithPrefix:@"particle_"];
        id<JIParticle> particle = [mContext createParticle];
        [particleObject addComponent:particle];
        id<JIPhysicalProperty> physicalProperty = [mContext createPhysicalProperty];
        [particleObject addComponent:physicalProperty];
        particleObject.parent = mHost;
    }
    id<JIParticle> particle = particleObject.particle;
    [particle reset];
    [self setupParticle:particle];
    particleObject.visible = YES;
    
    [mParticles set:mNumAliveParticles object:particleObject];
    [particleObject.transform setPosition:spawnPosition];
    
    if (mListener != nil) {
        [mListener onSpawnParticle:particle];
    }
    
    mNumAliveParticles++;
}

- (void) setupParticle:(id<JIParticle>)particle {
    id<JIGameObject> particleObject = particle.host;
    id<JIPhysicalProperty> physicalProperty = particleObject.physicalProperty;
    
    particle.deathTime = mSpawnDeathTime;
    physicalProperty.velocity = mSpawnVelocityIsFixed ? mSpawnMinVelocity : JCVector3Random(mSpawnMinVelocity, mSpawnMaxVelocity);
}

- (void) clearAllParticles {
    [JWCoreUtils destroyArray:mParticles];
    mParticles = nil;
    mNumAliveParticles = 0;
}

@end
