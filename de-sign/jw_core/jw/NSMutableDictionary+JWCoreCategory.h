//
//  NSMutableDictionary+JWCoreCategory.h
//  June Winter
//
//  Created by GavinLo on 14-3-4.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (JWCoreCategory)

- (id) get:(NSString*)key;
- (void) put:(NSString*)key value:(id)value;
- (id) remove:(NSString*)key;
- (void) clear;
- (void) addAll:(NSDictionary*)dictionary;

- (void) iterate:(void (^)(id key, id obj, BOOL *stop))block;
- (void) iterateNonNilKey:(void (^)(id key, id obj, BOOL *stop))block;

@end
