//
//  JWAsyncEventHandler.m
//  June Winter
//
//  Created by GavinLo on 14-5-3.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAsyncEventHandler.h"

@implementation JWAsyncEventHandler

- (id)initWithAsync:(BOOL)async {
    self = [super init];
    if (self != nil) {
        mAsync = async;
        [self onCreate];
    }
    return self;
}

- (BOOL)async {
    return mAsync;
}

- (void)setAsync:(BOOL)async {
    mAsync = async;
}

@end
