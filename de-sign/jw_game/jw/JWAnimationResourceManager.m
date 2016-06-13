//
//  JWAnimationResourceManager.m
//  June Winter
//
//  Created by GavinLo on 14/12/27.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAnimationResourceManager.h"
#import "JWAnimationResource.h"

@implementation JWAnimationResourceManager

- (id<JIResource>)newResource:(id<JIGameContext>)context file:(id<JIFile>)file
{
    return [[JWAnimationResource alloc] initWithFile:file context:context manager:self];
}

@end
