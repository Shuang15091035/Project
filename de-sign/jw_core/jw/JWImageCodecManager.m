//
//  JWImageCodecManager.m
//  June Winter
//
//  Created by GavinLo on 15/1/16.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWImageCodecManager.h"
#import "NSMutableDictionary+JWCoreCategory.h"
#import "JWCoreUtils.h"
#import "JWFile.h"

@interface JWImageCodecManagerEntry : JWObject
{
    NSRegularExpression* mPattern;
    id<JIImageCodec> mCodec;
}

@property (nonatomic, readwrite) NSRegularExpression* pattern;
@property (nonatomic, readwrite) id<JIImageCodec> codec;

@end

@implementation JWImageCodecManagerEntry

@synthesize pattern = mPattern;
@synthesize codec = mCodec;

- (void)onDestroy
{
    mPattern = nil;
    [JWCoreUtils destroyObject:mCodec];
    mCodec = nil;
    [super onDestroy];
}

@end

@interface JWImageCodecManager ()
{
    NSMutableDictionary* mCodecEntries;
}

@property (nonatomic, readonly) NSMutableDictionary* codecEntries;

@end

@implementation JWImageCodecManager

- (BOOL)registerCodec:(id<JIImageCodec>)codec overrideExist:(BOOL)overrideExist
{
    if(codec == nil)
        return NO;
    NSArray* patterns = codec.patterns;
    if(patterns == nil)
        return NO;
    for(NSString* pattern in patterns)
    {
        JWImageCodecManagerEntry* e = [self.codecEntries get:pattern];
        if(e == nil)
        {
            e = [[JWImageCodecManagerEntry alloc] init];
            [self.codecEntries put:pattern value:e];
        }
        else if(!overrideExist)
            continue;
        
        NSError* err = nil;
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&err];
        if(err != nil)
        {
            NSLog(@"%@", err);
            return NO;
        }
        
        e.pattern = regex;
        e.codec = codec;
    }
    return YES;
}

- (void)unregisterCodecForPattern:(NSString *)pattern
{
    [self.codecEntries remove:pattern];
}

- (void)unregisterAllCodecs
{
    [JWCoreUtils destroyDict:self.codecEntries];
}

- (id<JIImageCodec>)codecForFile:(id<JIFile>)file
{
    if(file == nil)
        return nil;
    
    id<JIImageCodec> codec = nil;
    for(JWImageCodecManagerEntry* e in self.codecEntries.allValues)
    {
        if([file isMatchPattern:e.pattern])
        {
            codec = e.codec;
            break;
        }
    }
    return codec;
}

- (NSMutableDictionary *)codecEntries
{
    if(mCodecEntries == nil)
        mCodecEntries = [NSMutableDictionary dictionary];
    return mCodecEntries;
}

@end
