//
//  JWAsyncResult.m
//  June Winter
//
//  Created by GavinLo on 14-2-20.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAsyncResult.h"

@interface JWAsyncResult ()
{
    id mSyncResult;
}

@end

@implementation JWAsyncResult

+ (id)result
{
    return [[JWAsyncResult alloc] init];
}

- (id)syncResult
{
    return mSyncResult;
}

- (void)setSyncResult:(id)syncResult
{
    mSyncResult = syncResult;
}

@end
