//
//  JWResponse.m
//  June Winter
//
//  Created by GavinLo on 14-2-20.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWResponse.h"

@implementation JWResponse

- (JWResponseStatus)status
{
    return mStatus;
}

- (void)setStatus:(JWResponseStatus)status
{
    mStatus = status;
}

- (NSData *)data
{
    return mData;
}

- (void)setData:(NSData *)data
{
    mData = data;
}

@end
