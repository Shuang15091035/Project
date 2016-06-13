//
//  JWEffectManager.m
//  June Winter
//
//  Created by GavinLo on 14/10/21.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWEffectManager.h"
#import "JWEffect.h"

@implementation JWEffectManager

- (id<JIResource>)newResource:(id<JIGameContext>)context file:(id<JIFile>)file
{
    return [[JWEffect alloc] initWithFile:file context:context manager:self];
}

- (id<JIEffect>)createByMesh:(id<JIMesh>)mesh material:(id<JIMaterial>)material lights:(id<NSFastEnumeration>)lights
{
    return nil;
}

@end
