//
//  JWRenderPlugin.m
//  June Winter
//
//  Created by GavinLo on 14-4-30.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWRenderPlugin.h"

@implementation JWRenderPlugin

- (id<JIGameFrame>)createGameFrame:(id<JIGameEngine>)engine
{
    return nil;
}

-(id<JIRenderTimer>)createRenderTimer:(id<JIGameEngine>)engine
{
    return nil;
}

- (id<JIMaterialManager>)createMaterialManager:(id<JIGameEngine>)engine
{
    return nil;
}

- (id<JITextureManager>)createTextureManager:(id<JIGameEngine>)engine
{
    return nil;
}

- (id<JIVideoTextureManager>)createVideoTextureManager:(id<JIGameEngine>)engine {
    return nil;
}

- (id<JIEffectManager>)createEffectManager:(id<JIGameEngine>)engine
{
    return nil;
}

- (id<JIMeshManager>)createMeshManager:(id<JIGameEngine>)engine
{
    return nil;
}

- (id<JICamera>)createCamera:(id<JIGameEngine>)engine
{
    return nil;
}

- (id<JIVRCamera>)createVRCamera:(id<JIGameEngine>)engine {
    return nil;
}

- (id<JIMeshRenderer>)createMeshRenderer:(id<JIGameEngine>)engine
{
    return nil;
}

- (id<JIBoundsRenderer>)createBoundsRenderer:(id<JIGameEngine>)engine
{
    return nil;
}

- (id<JISpotLight>)createSpotLight:(id<JIGameEngine>)engine
{
    return nil;
}

- (id<JIViewTag>)createViewTag:(id<JIGameEngine>)engine {
    return nil;
}

@synthesize MSAA = mMSAA;

@end
