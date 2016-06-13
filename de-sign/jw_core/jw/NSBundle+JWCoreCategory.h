//
//  NSBundle+JWCoreCategory.h
//  June Winter
//
//  Created by GavinLo on 14-3-13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (JWCoreCategory)

+ (NSBundle*) jwBundle;
@property (nonatomic, readonly) NSString* version;
@property (nonatomic, readonly) NSString* build;

@end
