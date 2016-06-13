//
//  JWAppStateMachine.m
//  June Winter
//
//  Created by GavinLo on 14-2-14.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAppStateMachine.h"
#import "JWControllerState.h"

@implementation JWAppStateMachine

- (NSString *)getClassNameFrom:(id<JIState>)state
{
    if(state == nil)
        return @"null";
    Class class = [state class];
    if(class == [JWControllerState class])
    {
        JWControllerState* cs = (JWControllerState*)state;
        return NSStringFromClass([cs controllerClass]);
    }
    return [super getClassNameFrom:state];
}

@end
