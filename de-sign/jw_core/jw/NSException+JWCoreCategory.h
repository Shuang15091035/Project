//
//  NSException+JWCoreCategory.h
//  jw_core
//
//  Created by ddeyes on 16/4/18.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSException (JWCoreCategory)

+ (NSException*) notImplementExceptionWithMethod:(NSString*)method;

@end
