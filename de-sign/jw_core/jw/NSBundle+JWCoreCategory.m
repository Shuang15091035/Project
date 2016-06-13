//
//  NSBundle+JWCoreCategory.m
//  June Winter
//
//  Created by GavinLo on 14-3-13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "NSBundle+JWCoreCategory.h"

@implementation NSBundle (JWCoreCategory)

static NSBundle* JWBundle = nil;

+ (NSBundle *)jwBundle {
    if (JWBundle == nil) {
        NSString* bundlePath = [[NSBundle mainBundle] pathForResource:@"jw_res" ofType:@"bundle"];
        JWBundle = [NSBundle bundleWithPath:bundlePath];
    }
    return JWBundle;
}

- (NSString *)version
{
    NSString* v = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return v;
}

- (NSString *)build
{
    NSString* b = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return b;
}

@end
