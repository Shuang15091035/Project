//
//  JWInputPlugin.h
//  June Winter_game
//
//  Created by ddeyes on 16/3/18.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWPlugin.h>

@protocol JIInputPlugin <JIPlugin>

- (id<JIGamepadManager>) createGamepadManager:(id<JIGameEngine>)engine;

@end
