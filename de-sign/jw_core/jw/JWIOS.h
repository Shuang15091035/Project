//
//  JWIOS.h
//  June Winter
//
//  Created by GavinLo on 14/12/16.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef JW_IOS_VERSION_MIN_REQUIRED
#   define JW_IOS_VERSION_MIN_REQUIRED __IPHONE_OS_VERSION_MIN_REQUIRED
#endif

//#ifndef JW_IOS_API
//#   define JW_IOS_API(major,minor) NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_##major_##minor
//#endif

#ifndef JW_IOS_API
#   define JW_IOS_API(major,minor) JW_IOS_VERSION_MIN_REQUIRED >= __IPHONE_##major_##minor
#endif

@interface JWIOS : NSObject

@end
