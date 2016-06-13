//
//  JWGameContext.h
//  June Winter
//
//  Created by GavinLo on 14-5-3.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import <jw/JWGamePredef.h>
#import <jw/JWObject.h>
#import <jw/JWCameraCapturer.h>

@protocol JIGameContext <JIObject>

@property (nonatomic, readonly) id<JIGameEngine> engine;

- (id<JIGameWorld>) createWorld;
- (id<JIGameScene>) createScene;
- (id<JIGameObject>) createObject;

@property (nonatomic, readonly) id<JIMaterialManager> materialManager;
@property (nonatomic, readonly) id<JITextureManager> textureManager;
@property (nonatomic, readonly) id<JIVideoTextureManager> videoTextureManager;
@property (nonatomic, readonly) id<JIImageCodecManager> imageCodecManager;
@property (nonatomic, readonly) id<JIEffectManager> effectManager;
@property (nonatomic, readonly) id<JIMeshManager> meshManager;
@property (nonatomic, readonly) id<JIAnimationResourceManager> animationResourceManager;
@property (nonatomic, readonly) id<JIResourceLoaderManager> resourceLoaderManager;
@property (nonatomic, readonly) id<JISceneLoaderManager> sceneLoaderManager;
@property (nonatomic, readonly) id<JIARSystem> arSystem;
@property (nonatomic, readonly) id<JIARDataSetManager> arDataSetManager;
@property (nonatomic, readonly) CMMotionManager* motionManager;
@property (nonatomic, readonly) JWCameraCapturer* cameraCapturer;

- (id<JICamera>) createCamera;
- (id<JIVRCamera>) createVRCamera;
- (id<JIMeshRenderer>) createMeshRenderer;
- (id<JIBoundsRenderer>) createBoundsRenderer;
- (id<JISpotLight>) createSpotLight;
- (id<JIViewTag>) createViewTag;
- (id<JIAnimation>) createAnimation;
- (id<JIAnimationSet>) createAnimationSet;
- (id<JIPhysicalProperty>) createPhysicalProperty;
- (id<JIParticle>) createParticle;
- (id<JIParticleSystem>) createParticleSystem;
- (id<JIComponentSet>) createComponentSet;
- (id<JIARCamera>) createARCamera;
- (id<JIARImageTarget>) createARImageTarget;

@end

@interface JWGameContext : JWObject <JIGameContext>

+ (id) contextWithEngine:(id<JIGameEngine>)engine;
- (id) initWithEngine:(id<JIGameEngine>)engine;

@end
