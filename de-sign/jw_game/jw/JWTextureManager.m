//
//  JWTextureManager.m
//  June Winter
//
//  Created by GavinLo on 14/10/30.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWTextureManager.h"
#import "JWTexture.h"

@implementation JWTextureManager

- (id<JIResource>)newResource:(id<JIGameContext>)context file:(id<JIFile>)file
{
    return [[JWTexture alloc] initWithFile:file context:context manager:self];
}

@end
