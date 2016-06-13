//
//  NSString+JWCoreCategory.h
//  June Winter
//
//  Created by GavinLo on 14/11/11.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JWCoreCategory)

+ (NSString*) newLine;

+ (BOOL) is:(NSString*)l equalsTo:(NSString*)r;
+ (BOOL) is:(NSString*)l equalsTo:(NSString*)r by:(BOOL)caseSensitive;
+ (BOOL) isNilOrBlank:(NSString*)string;
+ (NSNumber*) toNumber:(NSString*)string;
+ (NSString*) urlEncode:(NSString*)string;

- (BOOL) startsWith:(NSString*)prefix;
- (BOOL) endsWith:(NSString*)suffix;
- (BOOL) contains:(NSString*)string;
- (NSUInteger) indexOf:(NSString*)string;
- (NSUInteger) lastIndexOf:(NSString*)string;
- (BOOL) isBlank;
- (NSString*) urlEncode;

/**
 * 这个可以使用stringByDeletingLastPathComponent来实现,不过stringByDeletingLastPathComponent在返回时,
 * 如果源路径没有父路径,如"a.txt",则返回一个奇怪的值(在debug时显示"unable to read data"),故用此方法代替.
 * 此方法上述情况返回空字符串"".
 */
@property (nonatomic, readonly) NSString* stringByGettingDirPath;

+ (NSUInteger) parseHexUInteger:(NSString*)string defaultValue:(NSUInteger)defaultValue;

@end
