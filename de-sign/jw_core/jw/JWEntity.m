//
//  JWEntity.m
//  June Winter
//
//  Created by GavinLo on 14-5-2.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWEntity.h"

@implementation JWEntity

@synthesize Id = mId;
@synthesize name = mName;

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        mId = [NSNumber numberWithUnsignedInteger:self.hash].stringValue;
    }
    return self;
}

@end
