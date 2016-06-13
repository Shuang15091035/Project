//
//  JWARPlugin.m
//  June Winter
//
//  Created by GavinLo on 14-4-30.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWARPlugin.h"

@implementation JWARPlugin

- (id<JIARSystem>)createSystem:(id<JIGameEngine>)engine {
    return nil;
}

- (id<JIRenderTimer>)createRenderTimer:(id<JIGameEngine>)engine {
    return nil;
}

- (id<JIGameFrame>)createGameFrame:(id<JIGameEngine>)engine {
    return nil;
}

- (id<JIARDataSetManager>)createDataSetManager:(id<JIGameEngine>)engine {
    return nil;
}

- (id<JIARCamera>)createCamera:(id<JIGameEngine>)engine {
    return nil;
}

- (id<JIARImageTarget>)createImageTarget:(id<JIGameEngine>)engine {
    return nil;
}

@end
