//
//  JWMeshManager.m
//  June Winter
//
//  Created by GavinLo on 14/10/21.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWMeshManager.h"
#import "JWMesh.h"

@implementation JWMeshManager

- (id<JIResource>)newResource:(id<JIGameContext>)context file:(id<JIFile>)file
{
    JWMesh* mesh = [[JWMesh alloc] initWithFile:file context:context manager:self];
    return mesh;
}

@end
