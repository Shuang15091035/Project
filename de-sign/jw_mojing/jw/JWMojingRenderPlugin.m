//
//  JWMojingRenderPlugin.m
//  June Winter
//
//  Created by mac zdszkj on 16/3/4.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWMojingRenderPlugin.h"
#import "JWMojingCamera.h"

@implementation JWMojingRenderPlugin

- (id<JIVRCamera>)createVRCamera:(id<JIGameEngine>)engine {
    return [[JWMojingCamera alloc] initWithContext:engine.context];
}

@end
