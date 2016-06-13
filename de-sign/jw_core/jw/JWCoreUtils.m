//
//  JWCoreUtils.m
//  June Winter
//
//  Created by GavinLo on 14-2-13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWCoreUtils.h"
#import "JWObject.h"
#import "JWList.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation JWCoreUtils

+ (void)destroyObject:(id)object
{
    if(object == nil)
        return;
    if([object conformsToProtocol:@protocol(JIObject)])
        [self _destroyObject:object];
    else if([object conformsToProtocol:@protocol(JIUList)])
        [self _destoryArray:object];
    else if([object isKindOfClass:[NSArray class]])
        [self _destoryArray:object];
    else if([object isKindOfClass:[NSDictionary class]])
        [self _destroyDict:object];
}

+ (void)destroyList:(id<JIUList>)list
{
    if(list == nil)
        return;
    [self _destroyList:list];
}

+ (void)destroyArray:(NSArray *)array
{
    if(array == nil)
        return;
    [self _destoryArray:array];
}

+ (void)destroyDict:(NSDictionary *)dict
{
    if(dict == nil)
        return;
    [self _destroyDict:dict];
}

+ (void) _destroyObject:(id<JIObject>)object
{
    [object onDestroy];
}

+ (void) _destroyList:(id<JIUList>)list
{
    if ([list isKindOfClass:[JWSafeUList class]]) {
        JWSafeUList* sl = list;
        [sl enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
            if([obj conformsToProtocol:@protocol(JIObject)]) {
                id<JIObject> object = (id<JIObject>)obj;
                [self _destroyObject:object];
            }
        }];
    } else {
        for (id obj in list) {
            if([obj conformsToProtocol:@protocol(JIObject)]) {
                id<JIObject> object = (id<JIObject>)obj;
                [self _destroyObject:object];
            }
        }
    }
}

+ (void) _destoryArray:(NSArray*)array
{
    for(id obj in array)
    {
        if([obj conformsToProtocol:@protocol(JIObject)])
        {
            id<JIObject> object = (id<JIObject>)obj;
            [self _destroyObject:object];
        }
    }
    if([array isKindOfClass:[NSMutableArray class]])
    {
        NSMutableArray* ma = (NSMutableArray*)array;
        [ma removeAllObjects];
    }
}

+ (void) _destroyDict:(NSDictionary*)dict
{
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if([obj conformsToProtocol:@protocol(JIObject)])
        {
            id<JIObject> object = (id<JIObject>)obj;
            [self _destroyObject:object];
        }
    }];
    if([dict isKindOfClass:[NSMutableDictionary class]])
    {
        NSMutableDictionary* md = (NSMutableDictionary*)dict;
        [md removeAllObjects];
    }
}

+ (void)playCameraSound {
    SystemSoundID soundId = 1108;
    AudioServicesPlaySystemSound(soundId);
}

@end
