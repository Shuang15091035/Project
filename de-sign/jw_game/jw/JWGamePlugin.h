//
//  JWGamePlugin.h
//  June Winter
//
//  Created by GavinLo on 14-4-30.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JWGameWorld.h>
#import <jw/JWGameScene.h>
#import <jw/JWGameObject.h>
#import <jw/JWGameContext.h>

@protocol JIGamePlugin <JIObject>

- (id<JIGameWorld>) createWorld:(id<JIGameContext>)context;
- (id<JIGameScene>) createScene:(id<JIGameContext>)context;
- (id<JIGameObject>) createObject:(id<JIGameContext>)context;

@end

@interface JWGamePlugin : JWObject <JIGamePlugin>

@end
