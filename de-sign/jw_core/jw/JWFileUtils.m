//
//  JWFileUtils.m
//  June Winter
//
//  Created by GavinLo on 14-2-23.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWFileUtils.h"

#import <MobileCoreServices/UTType.h>

@implementation JWFileUtils

+ (NSString *)fullPathForResource:(NSString *)path withType:(NSString *)type {
    if (path == nil) {
        return nil;
    }
    NSString* fullPath = [[NSBundle mainBundle] pathForResource:path ofType:type];
    return fullPath;
}

+ (NSString *)documentDirPath {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if(paths == nil || paths.count == 0)
        return nil;
    NSString* dir = [paths objectAtIndex:0];
    return dir;
}

+ (NSString *)libraryDirPath {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if(paths == nil || paths.count == 0)
        return nil;
    NSString* dir = [paths objectAtIndex:0];
    return dir;
}

+ (NSString *)cachesDirPath {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if(paths == nil || paths.count == 0)
        return nil;
    NSString* dir = [paths objectAtIndex:0];
    return dir;
}

+ (NSString *)preferencesDirPath {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if(paths == nil || paths.count == 0)
        return nil;
    NSString* dir = [paths objectAtIndex:0];
    return [dir stringByAppendingPathComponent:@"Preferences"];
}

+ (NSString *)fullPathForDocument:(NSString *)path {
    NSString* docDir = [self documentDirPath];
    if (docDir == nil) {
        return path;
    }
    NSString* fullPath = [docDir stringByAppendingPathComponent:path];
    return fullPath;
}

+ (NSString *)mimeTypeForFileExtension:(NSString *)extension {
    if (extension == nil) {
        return nil;
    }
    
    CFStringRef extensionRef = CFBridgingRetain(extension);
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extensionRef, NULL);
    CFStringRef mimeType = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    CFRelease(extensionRef);
    if (!mimeType) {
        return nil;
    }
    return CFBridgingRelease(mimeType);
}

+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)filePathString {
    NSURL* URL= [NSURL fileURLWithPath: filePathString];
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

@end
