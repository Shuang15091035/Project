//
//  JWFileUtils.h
//  June Winter
//
//  Created by GavinLo on 14-2-23.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWFileUtils : NSObject

+ (NSString*) documentDirPath;
+ (NSString*) libraryDirPath;
+ (NSString*) cachesDirPath;
+ (NSString*) preferencesDirPath;
+ (NSString*) fullPathForDocument:(NSString*)path;
+ (NSString*) mimeTypeForFileExtension:(NSString*)extension;
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString*)filePathString;

@end
