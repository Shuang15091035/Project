//
//  JWResourceBundle.m
//  June Winter
//
//  Created by GavinLo on 14/12/22.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWResourceBundle.h"
#import <UIKit/UIKit.h>

@implementation JWResourceBundle

+ (NSString*) drawableDir
{
    return @"res/drawable";
}

+ (NSString*) rawDir
{
    return @"res/raw";
}

+ (NSString *)nameForDrawable:(NSString *)drawable
{
    NSString* dir = [self drawableDir];
    NSString* name = [NSString stringWithFormat:@"%@/%@", dir, drawable];
    return name;
}

+ (NSString *)nameForRaw:(NSString *)raw
{
    NSString* dir = [self rawDir];
    NSString* name = [NSString stringWithFormat:@"%@/%@", dir, raw];
    return name;
}

@end
