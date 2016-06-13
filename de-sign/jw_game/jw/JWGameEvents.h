//
//  JWGameEvents.h
//  June Winter_game
//
//  Created by ddeyes on 16/3/18.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWAppEvents.h>

@protocol JIGameEvents <JIAppEvents>

- (void) onGamepad:(id<JIGamepad>)gamepad;

@end

typedef void (^JWOnGamepadBlock)(id<JIGamepad> gamepad);

@protocol JIGameEventsWithBlock <JIGameEvents, JIAppEventsWithBlocks>

@property (nonatomic, readwrite) JWOnGamepadBlock onGamepad;

@end
