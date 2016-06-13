//
//  NSString+JWCoreCategory.m
//  June Winter
//
//  Created by GavinLo on 14/11/11.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "NSString+JWCoreCategory.h"
#import "JCUtils.h"
#import "JWIOS.h"
#import "UIDevice+JWCoreCategory.h"

@implementation NSString (JWCoreCategory)

+ (NSString*)newLine
{
    return @"\n";
}

+ (BOOL)is:(NSString *)l equalsTo:(NSString *)r
{
    return [self is:l equalsTo:r by:YES];
}

+ (BOOL)is:(NSString *)l equalsTo:(NSString *)r by:(BOOL)caseSensitive
{
    if(l == nil && r == nil)
        return YES;
    if(l == nil || r == nil)
        return NO;
    if(caseSensitive)
        return [l isEqual:r];
    return [l caseInsensitiveCompare:r] == NSOrderedSame;
}

+ (BOOL)isNilOrBlank:(NSString *)string
{
    return string == nil || [string isBlank];
}

+ (NSNumber *)toNumber:(NSString *)string
{
    NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
    NSNumber* n = nil;
    if([self is:string equalsTo:@"true" by:NO])
        n = [NSNumber numberWithBool:YES];
    else if([self is:string equalsTo:@"false" by:NO])
        n = [NSNumber numberWithBool:NO];
    else
        n = [nf numberFromString:string];
    return n;
}

+ (NSString *)urlEncode:(NSString *)string
{
    CFStringRef stringRef = CFBridgingRetain(string);
    CFStringRef encodeString = CFURLCreateStringByAddingPercentEscapes(
                                                                       kCFAllocatorDefault,
                                                                       stringRef,
                                                                       NULL,
                                                                       CFSTR(":/?#[]@!$&'()*+,;="),
                                                                       kCFStringEncodingUTF8);
    CFRelease(stringRef);
    return CFBridgingRelease(encodeString);
}

- (BOOL)startsWith:(NSString *)prefix
{
    if(prefix == nil)
        return NO;
    return [self hasPrefix:prefix];
}

- (BOOL)endsWith:(NSString *)suffix
{
    if(suffix == nil)
        return NO;
    return [self hasSuffix:suffix];
}

- (BOOL)contains:(NSString *)string {
    if (string == nil) {
        return NO;
    }
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        return [self containsString:string];
    } else {
        NSRange range = [self rangeOfString:string options:0];
        return range.location != NSNotFound;
    }
}

- (NSUInteger)indexOf:(NSString *)string {
    if (string == nil) {
        return NSNotFound;
    }
    NSRange range = [self rangeOfString:string options:0];
    return range.location;
}

- (NSUInteger)lastIndexOf:(NSString *)string {
    if (string == nil) {
        return NSNotFound;
    }
    NSRange range = [self rangeOfString:string options:NSBackwardsSearch];
    return range.location;
}

- (BOOL)isBlank {
    const NSUInteger strLen = self.length;
    if (strLen == 0)
        return YES;
    
    for (NSUInteger i = 0; i < strLen; i++) {
        unichar c = [self characterAtIndex:i];
        if(!JCIsWhitespace(c))
            return NO;
    }
    return YES;
}

- (NSString *)urlEncode
{
    return [NSString urlEncode:self];
}

- (NSString *)stringByGettingDirPath
{
    NSString* dirPath = [self stringByDeletingLastPathComponent];
    if(dirPath == nil || dirPath.length == 0)
        dirPath = @"";
    return dirPath;
}

+ (NSUInteger)parseHexUInteger:(NSString *)string defaultValue:(NSUInteger)defaultValue {
    if (string == nil) {
        return 0;
    }
    NSScanner* scanner = [NSScanner scannerWithString:string];
    unsigned int i = 0;
    if (![scanner scanHexInt:&i]) {
        return defaultValue;
    }
    return (NSUInteger)i;
}

@end
