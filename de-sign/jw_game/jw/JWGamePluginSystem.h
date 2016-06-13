//
//  JWGamePluginSystem.h
//  June Winter
//
//  Created by GavinLo on 14-4-30.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JWGamePlugin.h>
#import <jw/JWRenderPlugin.h>
#import <jw/JWInputPlugin.h>
#import <jw/JWArPlugin.h>

@protocol JIGamePluginSystem <JIObject>

@property (nonatomic, readwrite) id<JIGamePlugin> gamePlugin;
@property (nonatomic, readwrite) id<JIRenderPlugin> renderPlugin;
@property (nonatomic, readwrite) id<JIInputPlugin> inputPlugin;
@property (nonatomic, readwrite) id<JIARPlugin> arPlugin;

@end

@interface JWGamePluginSystem : JWObject <JIGamePluginSystem>

@end
