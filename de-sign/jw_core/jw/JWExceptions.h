//
//  JWExceptions.h
//  June Winter
//
//  Created by GavinLo on 14-2-14.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWException : NSException

@end

@interface JWUnimplementationException : JWException

+ (NSException*) methodDoesNotImplementInFile:(const char*)file atLine:(int)line;

@end

@interface JWStateChangeException : JWException

@end