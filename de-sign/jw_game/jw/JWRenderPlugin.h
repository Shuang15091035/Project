//
//  JWRenderPlugin.h
//  June Winter
//
//  Created by GavinLo on 14-4-30.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JWGameEngine.h>
#import <jw/JWMaterialManager.h>
#import <jw/JWEffectManager.h>
#import <jw/JWMeshManager.h>
#import <jw/JWMeshRenderer.h>

@protocol JIRenderPlugin <JIObject>

- (id<JIRenderTimer>) createRenderTimer:(id<JIGameEngine>)engine;
- (id<JIGameFrame>) createGameFrame:(id<JIGameEngine>)engine;

- (id<JIMaterialManager>) createMaterialManager:(id<JIGameEngine>)engine;
- (id<JITextureManager>) createTextureManager:(id<JIGameEngine>)engine;
- (id<JIVideoTextureManager>) createVideoTextureManager:(id<JIGameEngine>)engine;
- (id<JIEffectManager>) createEffectManager:(id<JIGameEngine>)engine;
- (id<JIMeshManager>) createMeshManager:(id<JIGameEngine>)engine;

- (id<JICamera>) createCamera:(id<JIGameEngine>)engine;
- (id<JIVRCamera>) createVRCamera:(id<JIGameEngine>)engine;
- (id<JIMeshRenderer>) createMeshRenderer:(id<JIGameEngine>)engine;
- (id<JIBoundsRenderer>) createBoundsRenderer:(id<JIGameEngine>)engine;
- (id<JISpotLight>) createSpotLight:(id<JIGameEngine>)engine;
- (id<JIViewTag>) createViewTag:(id<JIGameEngine>)engine;

@property (nonatomic, readwrite) NSUInteger MSAA;

@end

@interface JWRenderPlugin : JWObject <JIRenderPlugin> {
    NSUInteger mMSAA;
}

@end
