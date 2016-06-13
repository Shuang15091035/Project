//
//  NSMapTable+JWCoreCategory.h
//  June Winter
//
//  Created by GavinLo on 14/12/29.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMapTable (JWCoreCategory)

- (id) get:(id)key;
- (void) put:(id)key value:(id)value;
- (void) clear;

@end
