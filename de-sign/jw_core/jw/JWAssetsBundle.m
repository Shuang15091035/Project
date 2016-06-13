//
//  JWAssetsBundle.m
//  June Winter
//
//  Created by GavinLo on 14/12/30.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAssetsBundle.h"

@implementation JWAssetsBundle

+ (NSString*) assetsDir
{
    return @"assets";
}

+ (NSString *)nameForPath:(NSString *)assetsPath
{
    NSString* dir = [self assetsDir];
    NSString* name = [NSString stringWithFormat:@"%@/%@", dir, assetsPath];
    return name;
}

@end
