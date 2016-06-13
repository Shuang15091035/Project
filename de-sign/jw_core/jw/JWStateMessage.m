//
//  JWStateMessage.m
//  June Winter
//
//  Created by GavinLo on 14-3-12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWStateMessage.h"

@implementation JWStateMessage

@synthesize message = mMessage;
@synthesize extra = mExtra;
@synthesize handle = mHandle;

- (id)initWithMessage:(NSInteger)message extra:(id)extra
{
    self = [super init];
    if(self != nil)
    {
        mMessage = message;
        mExtra = extra;
        mHandle = YES;
    }
    return self;
}

+ (id)messageWithMessage:(NSInteger)message extra:(id)extra
{
    return [[JWStateMessage alloc] initWithMessage:message extra:extra];
}

@end
