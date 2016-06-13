//
//  JWResourceLoader.m
//  June Winter
//
//  Created by GavinLo on 15/1/13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWResourceLoader.h"

@implementation JWResourceLoader

- (NSString *)pattern
{
    return nil;
}

- (id)initWithContext:(id<JIGameContext>)context
{
    self = [super init];
    if(self != nil)
    {
        mContext = context;
    }
    return self;
}

- (BOOL)loadFile:(id<JIFile>)file forResource:(id<JIResource>)resource
{
    return NO;
}

- (BOOL)saveFile:(id<JIFile>)file forResource:(id<JIResource>)resource
{
    return NO;
}

@end
