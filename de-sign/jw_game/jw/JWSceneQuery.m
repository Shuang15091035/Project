//
//  JWSceneQuery.m
//  June Winter
//
//  Created by GavinLo on 14/12/10.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWSceneQuery.h"

@implementation JWSceneQuery

- (instancetype)init
{
    self = [super init];
    if(self != nil)
    {
        mMask = JWSceneQueryMask_All;
    }
    return self;
}

@synthesize mask = mMask;

@end
