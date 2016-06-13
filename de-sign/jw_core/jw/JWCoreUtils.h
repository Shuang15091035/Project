//
//  JWCoreUtils.h
//  June Winter
//
//  Created by GavinLo on 14-2-13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <jw/JWCorePredef.h>

@interface JWCoreUtils : NSObject

+ (void) destroyObject:(id)object;
+ (void) destroyList:(id<JIUList>)list;
+ (void) destroyArray:(NSArray*)array;
+ (void) destroyDict:(NSDictionary*)dict;

+ (void) playCameraSound;

@end
