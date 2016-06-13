//
//  NSMutableArray+JWArrayList.h
//  June Winter
//
//  Created by GavinLo on 14-3-4.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (JWArrayList)

- (void) add:(id)object;
- (BOOL) remove:(id)object;
- (id) removeFirst;
- (id) removeLast;
- (void) pop;
- (void) clear;
- (id) at:(NSUInteger)index;
- (NSUInteger) indexOf:(id)object;
- (void) set:(NSUInteger)index object:(id)object;
- (BOOL) contains:(id)object;
- (BOOL) isEmpty;
- (void) addAll:(NSArray*)array;
- (void) iterate:(void (^)(id object, NSUInteger index, BOOL* stop))block;
- (void) iterateNonNil:(void (^)(id object, NSUInteger index, BOOL* stop))block;

@end
