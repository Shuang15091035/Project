//
//  NSArray+JWCoreCategory.h
//  June Winter
//
//  Created by GavinLo on 14-3-6.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (JWCoreCategory)

- (id) at:(NSUInteger)index;
- (NSUInteger) indexOf:(id)object;
- (void) iterate:(void (^)(id object, NSUInteger index, BOOL* stop))block;
- (void) iterateNonNil:(void (^)(id object, NSUInteger index, BOOL* stop))block;
+ (BOOL) is:(NSArray*)a equalsTo:(NSArray*)b;

@end
