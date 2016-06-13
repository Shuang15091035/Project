//
//  JWAsyncUtils.h
//  June Winter
//
//  Created by GavinLo on 14-5-3.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWAsyncUtils : NSObject

+ (void) runOnMainQueue:(dispatch_block_t)block;
+ (void) runOnMainQueue:(dispatch_block_t)block withPriority:(NSInteger)priority;

@end
