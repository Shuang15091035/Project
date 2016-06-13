//
//  NSDictionary+JWCoreCategory.m
//  June Winter
//
//  Created by GavinLo on 14/11/5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "NSDictionary+JWCoreCategory.h"

@implementation NSDictionary (JWCoreCategory)

- (id)get:(NSString *)key
{
    return [self valueForKey:key];
}

@end
