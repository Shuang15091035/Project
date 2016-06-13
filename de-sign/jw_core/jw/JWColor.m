//
//  JWColor.m
//  June Winter
//
//  Created by GavinLo on 14/11/20.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWColor.h"
#import "NSArray+JWCoreCategory.h"

@interface JWColor () {
    JCColor mColor;
}

@end

@implementation JWColor

+ (id)color {
    return [[self alloc] init];
}

@synthesize color = mColor;

+ (JCColor)ccolorFromString:(NSString *)string
{
    NSArray* colors = [string componentsSeparatedByString:@" "];
    float r = 0.0f;
    float g = 0.0f;
    float b = 0.0f;
    float a = 0.0f;
    if(colors.count > 0)
        r = [[colors at:0] floatValue];
    if(colors.count > 1)
        g = [[colors at:1] floatValue];
    if(colors.count > 2)
        b = [[colors at:2] floatValue];
    if(colors.count > 3)
        a = [[colors at:3] floatValue];
    JCColor color = JCColorMake(r, g, b, a);
    return color;
}

@end
