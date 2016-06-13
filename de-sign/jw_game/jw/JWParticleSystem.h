//
//  JWParticleSystem.h
//  June Winter_game
//
//  Created by ddeyes on 16/3/2.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWComponent.h>
#import <jw/JWParticleEmitter.h>

typedef void (^JWParticleSystemOnSpawnParticleBlock)(id<JIParticle> particle);

@protocol JIOnParticleSystemListener <NSObject>

- (void) onSpawnParticle:(id<JIParticle>)particle;

@end

@interface JWOnParticleSystemListener : NSObject <JIOnParticleSystemListener>

+ (id) listener;
@property (nonatomic, readwrite) JWParticleSystemOnSpawnParticleBlock onParticleSpawn;

@end

@protocol JIParticleSystem <JIComponent>

/**
 * 粒子实例,其他粒子均由此实例复制而来
 */
@property (nonatomic, readwrite) id<JIGameObject> particleInstance;

/**
 * 粒子发射器
 */
@property (nonatomic, readwrite) id<JIParticleEmitter> emitter;

/**
 * 粒子数目上限
 */
@property (nonatomic, readwrite) NSUInteger quota;

/**
 * 当前显示的粒子数量
 */
@property (nonatomic, readonly) NSUInteger numAliveParticles;

/**
 * 粒子的发射频率
 */
@property (nonatomic, readwrite) float minRate;
@property (nonatomic, readwrite) float maxRate;

/** 
 * 粒子的初始生命时间
 */
@property (nonatomic, readwrite) NSUInteger spawnDeathTime;

/**
 * 粒子出现时的速度
 */
@property (nonatomic, readwrite) JCVector3 spawnMinVelocity;
@property (nonatomic, readwrite) JCVector3 spawnMaxVelocity;

@property (nonatomic, readwrite) id<JIOnParticleSystemListener> listener;

@end

@interface JWParticleSystem : JWComponent <JIParticleSystem>

@end
