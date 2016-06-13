//
//  JWHttpMethod.m
//  June Winter
//
//  Created by GavinLo on 14-2-22.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWHttpMethod.h"

@implementation JWHttpMethodUtils

+ (NSString *)toString:(JWHttpMethod)method
{
    switch(method)
    {
        case JWHttpMethodGet:
            return @"GET";
        case JWHttpMethodPost:
            return @"POST";
    }
    return @"GET";
}

@end
