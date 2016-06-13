//
//  JWSpotLight.m
//  June Winter
//
//  Created by GavinLo on 15/1/10.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWSpotLight.h"

@implementation JWSpotLight

- (id)initWithContext:(id<JIGameContext>)context
{
    self = [super initWithContext:context];
    if(self != nil)
    {
        mSpotLight = JCSpotLightDefault();
    }
    return self;
}

- (float)cutoff
{
    return mSpotLight.cutoff;
}

- (void)setCutoff:(float)cutoff
{
    mSpotLight.cutoff = cutoff;
}

- (float)exponent
{
    return mSpotLight.exponent;
}

- (void)setExponent:(float)exponent
{
    mSpotLight.exponent = exponent;
}

@end
