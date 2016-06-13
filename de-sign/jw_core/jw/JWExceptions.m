//
//  JWExceptions.m
//  June Winter
//
//  Created by GavinLo on 14-2-14.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWExceptions.h"

@implementation JWException

@end

@implementation JWUnimplementationException

+ (NSException *)methodDoesNotImplementInFile:(const char *)file atLine:(int)line
{
    return [JWUnimplementationException exceptionWithName:@"Method does not implement!!!" reason:[NSString stringWithFormat:@"Method does not implement in file[%s(line:%d)]", file, line] userInfo:nil];
}

@end

@implementation JWStateChangeException

@end