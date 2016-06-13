//
//  JWAsyncResultTask.m
//  June Winter
//
//  Created by GavinLo on 14-5-3.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAsyncResultTask.h"

@implementation JWAsyncResultTask

- (id)initWithResult:(JWAsyncResult *)result
{
    self = [super init];
    if(self != nil)
    {
        mAsyncResult = result;
    }
    return self;
}

@end
