//
//  JWCancellable.m
//  June Winter
//
//  Created by GavinLo on 14-2-20.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWCancellable.h"

@implementation JWCancellable

- (void)cancel
{
    mIsCancelled = YES;
}

- (BOOL)isCancelled
{
    return mIsCancelled;
}

@end
