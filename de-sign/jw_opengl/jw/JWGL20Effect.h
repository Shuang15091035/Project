//
//  JWGL20Effect.h
//  June Winter
//
//  Created by GavinLo on 14/10/21.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWEffect.h>
#import <jw/JWGLResource.h>
#import <jw/JCGLEffect.h>

@interface JWGL20Effect : JWEffect <JIResource>

@property (nonatomic, readonly) JCGLEffectRefC ceffect;

@end
