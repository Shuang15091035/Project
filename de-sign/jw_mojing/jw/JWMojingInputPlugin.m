//
//  JWMojingInputPlugin.m
//  June Winter
//
//  Created by ddeyes on 16/3/18.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWMojingInputPlugin.h"
#import "JWMojingGamepadManager.h"

@implementation JWMojingInputPlugin

- (id<JIGamepadManager>)createGamepadManager:(id<JIGameEngine>)engine {
    return [[JWMojingGamepadManager alloc] initWithEngine:engine];
}

@end
