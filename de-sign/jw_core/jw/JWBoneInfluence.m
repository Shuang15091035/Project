//
//  JWBoneInfluence.m
//  jw_core
//
//  Created by GavinLo on 15/5/1.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWBoneInfluence.h"

@interface JWBoneInfluence () {
    JCBoneInfluence mBoneInfluence;
}

@end

@implementation JWBoneInfluence

+ (id)boneInfluence {
    return [[self alloc] init];
}

@synthesize boneInfluence = mBoneInfluence;

@end
