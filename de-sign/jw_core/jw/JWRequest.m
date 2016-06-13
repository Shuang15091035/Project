//
//  JWRequest.m
//  June Winter
//
//  Created by GavinLo on 14-2-19.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWRequest.h"

@implementation JWRequest

- (NSString *)url
{
    return mUrl;
}

- (void)setUrl:(NSString *)url
{
    mUrl = url;
}

- (JWHttpMethod)method
{
    return mMethod;
}

- (void)setMethod:(JWHttpMethod)method
{
    mMethod = method;
}

- (Class)responseClass
{
    return mResponseClass;
}

@end
