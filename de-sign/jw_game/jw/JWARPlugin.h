//
//  JWARPlugin.h
//  June Winter
//
//  Created by GavinLo on 14-4-30.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWPlugin.h>

@protocol JIARPlugin <JIPlugin>

- (id<JIARSystem>) createSystem:(id<JIGameEngine>)engine;
- (id<JIRenderTimer>) createRenderTimer:(id<JIGameEngine>)engine;
- (id<JIGameFrame>) createGameFrame:(id<JIGameEngine>)engine;
- (id<JIARDataSetManager>) createDataSetManager:(id<JIGameEngine>)engine;
- (id<JIARCamera>) createCamera:(id<JIGameEngine>)engine;
- (id<JIARImageTarget>) createImageTarget:(id<JIGameEngine>)engine;

@end

@interface JWARPlugin : JWPlugin <JIARPlugin>

@end
