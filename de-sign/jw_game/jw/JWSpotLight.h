//
//  JWSpotLight.h
//  June Winter
//
//  Created by GavinLo on 15/1/10.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWLight.h>
#import <jw/JCLight.h>

@protocol JISpotLight <JILight>

@property (nonatomic, readwrite) float cutoff;
@property (nonatomic, readwrite) float exponent;

@end

@interface JWSpotLight : JWLight <JISpotLight>
{
    JCSpotLight mSpotLight;
}

@end
