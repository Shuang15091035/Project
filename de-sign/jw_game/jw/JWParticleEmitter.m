//
//  JWParticleEmitter.m
//  June Winter_game
//
//  Created by ddeyes on 16/3/2.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWParticleEmitter.h"

@interface JWPointParticleEmitter () {
    JCVector3 mPoint;
}

@end

@implementation JWPointParticleEmitter

+ (id)emitter {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        mPoint = JCVector3Zero();
    }
    return self;
}

@synthesize point = mPoint;

- (JCVector3)getSpawnPosition {
    return mPoint;
}

@end
