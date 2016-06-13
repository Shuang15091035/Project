//
//  JWGLRenderer.h
//  June Winter
//
//  Created by GavinLo on 14-5-4.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGLPredef.h>
#import <jw/JWGamePredef.h>
#import <jw/JWObject.h>

@protocol JIGLRenderer <JIObject>

- (void) onPreDraw;
- (void) onDrawFrame;
- (void) onPostDraw;
- (void) onSurfaceCreated;
- (void) onSurfaceChangedWidth:(NSUInteger)width height:(NSUInteger)height;

@end

@interface JWGLRenderer : JWObject <JIGLRenderer>

- (id) initWithEngine:(id<JIGameEngine>)engine;

- (void) onPreRender:(id<JIGameScene>)scene;
- (void) onRenderBackgrounds:(id<JICamera>)camera renderQueue:(id<JIRenderQueue>)renderQueue;
- (void) onCameraProjection:(id<JICamera>)camera;
- (void) onCameraTransform:(id<JICamera>)camera;
- (void) onRenderObjects:(id<JICamera>)camera renderQueue:(id<JIRenderQueue>)renderQueue;
- (void) onRenderUi:(id<JICamera>)camera renderQueue:(id<JIRenderQueue>)renderQueue;
- (void) onPostRender;

@end
