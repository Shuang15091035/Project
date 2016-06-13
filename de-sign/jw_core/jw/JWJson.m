//
//  JWJson.m
//  June Winter
//
//  Created by GavinLo on 14-2-20.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWJson.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

@implementation JWJson

+ (NSDictionary *)deserializeData:(NSData *)data error:(NSError *__autoreleasing *)error
{
    NSDictionary* jsonObject = [[CJSONDeserializer deserializer] deserializeAsDictionary:data error:error];
    return jsonObject;
}

+ (void)fromJson:(id<JISerializeObject>)object serializeMethod:(NSInteger)methodId withString:(NSString *)string encoding:(JWEncoding)encoding error:(NSError *__autoreleasing *)error
{
    if(object == nil)
        return;
    NSDictionary* members = [object serializeMethod:methodId];
    if(members == nil)
        return;
    
    NSData* data = [string dataUsingEncoding:[JWEncodingUtils toNSStringEncoding:encoding]];
    NSDictionary* jsonObject = [[CJSONDeserializer deserializer] deserializeAsDictionary:data error:error];
    [JWJson fromJsonImpl:object withMembers:members serializeMethod:methodId withJsonObject:jsonObject error:error];
}

+ (void) fromJsonImpl:(id<JISerializeObject>)object withMembers:(NSDictionary*)members serializeMethod:(NSInteger)methodId withJsonObject:(NSDictionary *)jsonObject error:(NSError *__autoreleasing *)error
{
    if(object == nil)
        return;
    if(members == nil)
        members = [object serializeMethod:methodId];
    if(members == nil)
        return;
    
    for(NSString* key in jsonObject.allKeys)
    {
        JWSerializeInfo* info = [members objectForKey:key];
        if(info != nil)
        {
            id value = [jsonObject objectForKey:key];
            if(value == nil)
                continue;
            
            NSString* name = info.name;
            if(name == nil)
                name = key;
            
            if(info.arrayClass != nil && [value isKindOfClass:[NSArray class]])
            {
                Class arrayClass = info.arrayClass;
                Class itemClass = info.objClass;
                NSMutableArray* array = [NSMutableArray array];
                
                NSArray* jsonArray = (NSArray*)value;
                for(id jsonItem in jsonArray)
                {
                    if([jsonItem isKindOfClass:[NSDictionary class]] && [itemClass conformsToProtocol:@protocol(JISerializeObject)])
                    {
                        id<JISerializeObject> item = [[itemClass alloc] init];
                        [self fromJsonImpl:item withMembers:nil serializeMethod:methodId withJsonObject:jsonItem error:error];
                        [array addObject:item];
                    }
                    else
                    {
                        [array addObject:jsonItem];
                    }
                }
                if(array.count == 0)
                    array = nil;
                
                if(arrayClass == [NSMutableArray class])
                    [object setValue:array forKey:name];
                else if(arrayClass == [NSArray class])
                {
                    NSArray* arr = [NSArray arrayWithArray:array];
                    [object setValue:arr forKey:name];
                }
                    
            }
            else if([info.objClass conformsToProtocol:@protocol(JISerializeObject)])
            {
                NSDictionary* d = (NSDictionary*)value;
                id<JISerializeObject> child = [[info.objClass alloc] init];
                [self fromJsonImpl:child withMembers:nil serializeMethod:methodId withJsonObject:d error:error];
                [object setValue:child forKey:name];
            }
            else
            {
                if([value isKindOfClass:[NSString class]])
                {
                    NSString* v = (NSString*)value;
                    [object setStringValue:v withClass:info.objClass forKey:name];
                }
                else
                {
                    [object setValue:value forKey:name];
                }
            }
        }
    }
}

+ (NSString *)toJson:(id<JISerializeObject>)object serializeMethod:(NSInteger)methodId encoding:(JWEncoding)encoding error:(NSError *__autoreleasing *)error
{
    if(object == nil)
        return nil;
    NSDictionary* members = [object serializeMethod:methodId];
    if(members == nil)
        return nil;
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [self toJsonImpl:object withMembers:members serializeMethod:methodId withJsonObject:dict error:error];
    NSData* data = [[CJSONSerializer serializer] serializeDictionary:dict error:error];
    NSString* string = [[NSString alloc] initWithData:data encoding:[JWEncodingUtils toNSStringEncoding:encoding]];
    return string;
}

+ (void) toJsonImpl:(id<JISerializeObject>)object withMembers:(NSDictionary*)members serializeMethod:(NSInteger)methodId withJsonObject:(NSMutableDictionary*)jsonObject error:(NSError *__autoreleasing *)error
{
    if(object == nil)
        return;
    if(members == nil)
        members = [object serializeMethod:methodId];
    if(members == nil)
        return;
    
    for(NSString* key in members.allKeys)
    {
        JWSerializeInfo* info = [members objectForKey:key];
        if(info != nil)
        {
            NSString* name = info.name;
            if(name == nil)
                name = key;
            
            id value = [object valueForKey:name];
            if(value == nil)
                continue;
            
            if([value isKindOfClass:[NSArray class]])
            {
                NSMutableArray* jsonArray = [NSMutableArray array];
                NSArray* array = (NSArray*)value;
                for(id item in array)
                {
                    if([item conformsToProtocol:@protocol(JISerializeObject)])
                    {
                        id<JISerializeObject> child = (id<JISerializeObject>)item;
                        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
                        [self toJsonImpl:child withMembers:nil serializeMethod:methodId withJsonObject:dict error:error];
                        [jsonArray addObject:dict];
                    }
                    else
                    {
                        [jsonArray addObject:item];
                    }
                }
                [jsonObject setObject:jsonArray forKey:key];
            }
            else if([value conformsToProtocol:@protocol(JISerializeObject)])
            {
                id<JISerializeObject> child = (id<JISerializeObject>)value;
                NSMutableDictionary* dict = [NSMutableDictionary dictionary];
                [self toJsonImpl:child withMembers:nil serializeMethod:methodId withJsonObject:dict error:error];
                [jsonObject setObject:dict forKey:key];
            }
            else
            {
                [jsonObject setObject:value forKey:key];
            }
        }
    }

}

@end
