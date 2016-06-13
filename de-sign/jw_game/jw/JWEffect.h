//
//  JWEffect.h
//  June Winter
//
//  Created by GavinLo on 14/10/21.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWResource.h"

@protocol JIEffect <JIResource>

- (BOOL) bind;
- (void) unbind;

@end

@interface JWEffect : JWResource <JIEffect>

@end
