//
//  JWHashcode.h
//  June Winter
//
//  Created by GavinLo on 14-3-12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWHashcode : NSObject

+ (JWHashcode*) beginWith:(NSUInteger)i;
+ (JWHashcode*) begin;
- (JWHashcode*) atObject:(id)object;
- (NSUInteger) end;

@end
