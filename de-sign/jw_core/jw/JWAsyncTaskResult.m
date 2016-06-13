//
//  JWAsyncTaskResult.m
//  June Winter
//
//  Created by GavinLo on 14/11/4.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAsyncTaskResult.h"

@implementation JWAsyncTaskResult

+ (id)result
{
    return [[JWAsyncTaskResult alloc] init];
}

- (JWAsyncTask *)asyncTask
{
    return mAsyncTask;
}

- (void)setAsyncTask:(JWAsyncTask *)asyncTask
{
    mAsyncTask = asyncTask;
}

- (void)cancel
{
    [mAsyncTask cancel];
    [super cancel];
}

@end
