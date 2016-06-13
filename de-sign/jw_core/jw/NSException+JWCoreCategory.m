//
//  NSException+JWCoreCategory.m
//  jw_core
//
//  Created by ddeyes on 16/4/18.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "NSException+JWCoreCategory.h"

@implementation NSException (JWCoreCategory)

+ (NSException *)notImplementExceptionWithMethod:(NSString *)method {
    return [NSException exceptionWithName:@"NotImplement" reason:method userInfo:nil];
}

@end
