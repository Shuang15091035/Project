//
//  JWHttpMethod.h
//  June Winter
//
//  Created by GavinLo on 14-2-19.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * http方法
 */
typedef NS_ENUM(NSInteger, JWHttpMethod)
{
    JWHttpMethodGet,
    JWHttpMethodPost,
    // TODO
};

@interface JWHttpMethodUtils : NSObject

/**
 * JWHttpMethodGet => @"GET"
 * JWHttpMethodPost => @"POST"
 */
+ (NSString*) toString:(JWHttpMethod)method;

@end