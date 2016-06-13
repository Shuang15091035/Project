//
//  JWPlugin.h
//  jw_core
//
//  Created by GavinLo on 15/3/6.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWCorePredef.h>
#import <jw/JWObject.h>

@protocol JIPlugin <JIObject>

- (void) onInit;
- (void) onDeinit;

@end

@interface JWPlugin : JWObject <JIPlugin>

@end
