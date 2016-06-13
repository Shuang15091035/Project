//
//  JWParticle.h
//  June Winter_game
//
//  Created by ddeyes on 16/3/2.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWComponent.h>

@protocol JIParticle <JIComponent>

/** 
 * 设置粒子的生命时间
 */
@property (nonatomic, readwrite) NSUInteger deathTime;

/** 
 * 判断粒子生命是否结束
 */
@property (nonatomic, readwrite, getter=isDead) BOOL dead;

/** 
 * 强制粒子系统回收此粒子
 */
- (void) kill;

///**
// * 设置粒子速度(由粒子系统控制)
// */
//@property (nonatomic, readwrite) JCVector3 velocity;
//
///** 
// * 设置粒子加速度(由粒子系统控制)
// */
//@property (nonatomic, readwrite) JCVector3 angularSpeed;
//
///** 
// * 设置粒子加速度(由粒子系统控制)
// */
//@property (nonatomic, readwrite) JCVector3 acceleration;

- (void) reset;

@end

@interface JWParticle : JWComponent <JIParticle>

@property (nonatomic, readwrite) id<JIGameObject> object;

@end
