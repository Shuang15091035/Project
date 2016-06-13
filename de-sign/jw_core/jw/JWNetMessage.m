//
//  JWNetMessage.m
//  June Winter
//
//  Created by GavinLo on 14-2-19.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWNetMessage.h"
#import "JWJson.h"
#import "JWFile.h"
#import "NSString+JWCoreCategory.h"

@implementation JWNetMessage

+ (NSInteger)SerializeParamsMethodId
{
    return 1;
}

- (id)init
{
    self = [super init];
    if(self != nil)
        [self onCreate];
    return self;
}

- (void)dealloc
{
    [self onDestroy];
}

- (JWNetFormatter *)formatter
{
    return mFormatter;
}

- (void)setFormatter:(JWNetFormatter *)formatter
{
    mFormatter = formatter;
}

- (NSString *)serializeString
{
    if(mFormatter == nil)
        return [self serializeJson];
    switch(mFormatter.format)
    {
        case JWNetFormatJson:
            return [self serializeJson];
    }
    return nil;
}

- (NSString*) serializeJson
{
    NSError* jsonError = nil;
    NSString* string = [JWJson toJson:self serializeMethod:[JWNetMessage SerializeParamsMethodId] encoding:JWEncodingUTF8 error:&jsonError];
    if(jsonError != nil)
        return nil;
    return string;
}

- (BOOL)deserializeString:(NSString *)string
{
    if(mFormatter == nil)
        [self deserializeJson:string];
    switch(mFormatter.format)
    {
        case JWNetFormatJson:
            return [self deserializeJson:string];
    }
    return NO;
}

- (BOOL) deserializeJson:(NSString*)string
{
    NSError* jsonError = nil;
    [JWJson fromJson:self serializeMethod:[JWNetMessage SerializeParamsMethodId] withString:string encoding:JWEncodingUTF8 error:&jsonError];
    if(jsonError != nil)
        return YES;
    return NO;
}

- (void)getParams:(NSMutableDictionary *)outParams
{
    NSDictionary* members = [self serializeParams];
    if(members == nil)
        return;
    
    if(mFormatter == nil)
    {
        for(NSString* key in members)
        {
            id value = [self valueForKey:key];
            NSString* valueString = [value stringValue];
            [outParams setObject:valueString forKey:key];
        }
    }
    else
    {
        NSString* string = [self serializeString];
        if(string != nil)
            [outParams setObject:string forKey:mFormatter.key];
    }
}

- (void)setParams:(NSDictionary *)inParams
{
    NSDictionary* members = [self serializeParams];
    if(members == nil)
        return;
    
    if(mFormatter == nil)
    {
        for(NSString* key in inParams.allKeys)
        {
            JWSerializeInfo* info = [members objectForKey:key];
            if(info != nil)
            {
                NSString* value = [inParams objectForKey:key];
                [self setStringValue:value withClass:info.objClass forKey:key];
            }
        }
    }
    else
    {
        NSString* string = [inParams objectForKey:mFormatter.key];
        if(string != nil)
            [self deserializeString:string];
    }
}

- (void)getHeaders:(NSMutableDictionary *)outHeaders
{
    NSArray* headers = [self serializeHeaders];
    if(headers == nil)
        return;
    
    for(NSString* key in headers)
    {
        id value = [self valueForKey:key];
        NSString* valueString = [value stringValue];
        [outHeaders setObject:valueString forKey:key];
    }
    
    NSString* cookie = [self getCookie];
    if(cookie != nil)
        [outHeaders setObject:cookie forKey:@"cookie"];
}

- (void)setHeaders:(NSDictionary *)inHeaders
{
    NSArray* headers = [self serializeHeaders];
    if(headers == nil)
        return;
    
    for(NSString* key in inHeaders)
    {
        if([headers containsObject:key])
        {
            NSString* value = [inHeaders objectForKey:key];
            [self setValue:value forKey:key];
        }
    }
    
    NSString* cookie = [inHeaders objectForKey:@"cookie"];
    [self setCookie:cookie];
}

- (NSString*)getCookie
{
    NSArray* cookies = [self serializeCookies];
    if(cookies == nil)
        return nil;
    
    NSMutableString* cookie = nil;
    for(NSString* key in cookies)
    {
        if(cookie == nil)
            cookie = [[NSMutableString alloc] init];
        id value = [self valueForKey:key];
        NSString* valueString = [value stringValue];
        [cookie appendFormat:@"%@=%@;", key, valueString];
    }
    return cookie;
}

- (void)setCookie:(NSString*)cookie
{
    if(cookie == nil)
        return;
    NSArray* cookies = [self serializeCookies];
    if(cookies == nil)
        return;
    
    NSArray* cookieKeyValues = [cookie componentsSeparatedByString:@";"];
    for(NSString* cookieKeyValueString in cookieKeyValues)
    {
        NSArray* cookieKeyValue = [cookieKeyValueString componentsSeparatedByString:@"="];
        if(cookieKeyValue.count > 1)
        {
            NSString* key = [cookieKeyValue objectAtIndex:0];
            NSString* value = [cookieKeyValue objectAtIndex:1];
            if([cookies containsObject:key])
                [self setValue:value forKey:key];
        }
    }
}

- (void)getFiles:(NSMutableDictionary *)outFiles
{
    [JWNetMessage toFiles:outFiles withObject:self andPrefix:nil];
}

- (void)setFiles:(NSDictionary *)inFiles
{
    // TODO
}

+ (void) toFiles:(NSMutableDictionary*) outFiles withObject:(JWNetMessage*)object andPrefix:(NSString*)prefix
{
    NSArray* files = [object serializeFiles];
    if(files == nil)
        return;
    
    NSString* nameSeperator = @"/";
    NSString* numSeperator = @"#";
    
    [files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(obj == [NSNull null])
            return;
        
        NSString* file = obj;
        if([NSString isNilOrBlank:file])
            return;
        
        id value = [object valueForKey:file];
        if(value == nil)
            return;
        
        // 获取名字,并组合成最终名字
        NSString* name = file;
        if(prefix != nil)
            name = [NSString stringWithFormat:@"%@%@%@", prefix, nameSeperator, file];
        
        // 处理文件对象
        if([[value class] conformsToProtocol:@protocol(JIFile)])
            [outFiles setObject:value forKey:name];
        // 处理数组
        else if([value isKindOfClass:[NSArray class]])
        {
            NSArray* fileItems = (NSArray*)value;
            for(NSUInteger i = 0; i < fileItems.count; i++)
            {
                id fileItem = [fileItems objectAtIndex:i];
                if([[fileItem class] conformsToProtocol:@protocol(JIFile)])
                {
                    name = [NSString stringWithFormat:@"%@%@%@", name, numSeperator, [NSNumber numberWithUnsignedLong:i]];
                    [outFiles setObject:fileItem forKey:name];
                }
            }
        }
        // 处理map
        else if([value isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* fileItems = (NSDictionary*)value;
            for(id key in fileItems.allKeys)
            {
                value = [fileItems objectForKey:key];
                if([key isKindOfClass:[NSString class]] && [[value class] conformsToProtocol:@protocol(JIFile)])
                {
                    name = [NSString stringWithFormat:@"%@%@%@", name, nameSeperator, (NSString*)key];
                    [outFiles setObject:value forKey:name];
                }
            }
        }
        // 处理子对象
        else if([value isKindOfClass:[JWNetMessage class]])
        {
            NSString* pf = name;
            if(prefix != nil)
                pf = [NSString stringWithFormat:@"%@%@%@", prefix, nameSeperator, name];
            [self toFiles:outFiles withObject:value andPrefix:pf];
        }
    }];
}

- (NSDictionary *)serializeMethod:(NSInteger)methodId
{
    if(methodId == [JWNetMessage SerializeParamsMethodId])
        return [self serializeParams];
    return [super serializeMethod:methodId];
}

- (NSDictionary *)serializeParams
{
    return nil;
}

- (NSArray *)serializeHeaders
{
    return nil;
}

- (NSArray *)serializeCookies
{
    return nil;
}

- (NSArray *)serializeFiles
{
    return nil;
}

@end
