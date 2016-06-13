//
//  JWParticleEmitter.h
//  June Winter_game
//
//  Created by ddeyes on 16/3/2.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JCVector3.h>

@protocol JIParticleEmitter <JIObject>

- (JCVector3) getSpawnPosition;

@end

@interface JWPointParticleEmitter : JWObject <JIParticleEmitter>

+ (id) emitter;

@property (nonatomic, readwrite) JCVector3 point;

@end
