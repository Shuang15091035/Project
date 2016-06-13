//
//  JWResourceLoaderManager.m
//  June Winter
//
//  Created by GavinLo on 15/1/13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWResourceLoaderManager.h"
#import "NSMutableDictionary+JWCoreCategory.h"
#import "JWCoreUtils.h"
#import "JWFile.h"

@interface JWResourceLoaderManagerEntry : JWObject
{
    NSRegularExpression* mPattern;
    id<JIResourceLoader> mLoader;
}

@property (nonatomic, readwrite) NSRegularExpression* pattern;
@property (nonatomic, readwrite) id<JIResourceLoader> loader;

@end

@implementation JWResourceLoaderManagerEntry

@synthesize pattern = mPattern;
@synthesize loader = mLoader;

- (void)onDestroy
{
    mPattern = nil;
    [JWCoreUtils destroyObject:mLoader];
    mLoader = nil;
    [super onDestroy];
}

@end

@interface JWResourceLoaderManager ()
{
    id<JIGameContext> mContext;
    NSMutableDictionary* mLoaderEntries;
}

@property (nonatomic, readonly) NSMutableDictionary* loaderEntries;

@end

@implementation JWResourceLoaderManager

- (id)initWithContext:(id<JIGameContext>)context
{
    self = [super init];
    if(self != nil)
    {
        mContext = context;
    }
    return self;
}

- (BOOL)registerLoader:(id<JIResourceLoader>)loader overrideExist:(BOOL)overrideExist
{
    if(loader == nil)
        return NO;
    NSString* pattern = loader.pattern;
    JWResourceLoaderManagerEntry* e = [self.loaderEntries get:pattern];
    if(e == nil)
    {
        e = [[JWResourceLoaderManagerEntry alloc] init];
        [self.loaderEntries put:pattern value:e];
    }
    else if(!overrideExist)
        return NO;
    
    NSError* err = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&err];
    if(err != nil)
    {
        NSLog(@"%@", err);
        return NO;
    }
    
    e.pattern = regex;
    e.loader = loader;
    return YES;
}

- (void)unregisterLoaderForPattern:(NSString *)pattern
{
    [self.loaderEntries remove:pattern];
}

- (void)unregisterAllLoaders
{
    [JWCoreUtils destroyDict:self.loaderEntries];
}

- (id<JIResourceLoader>)getLoaderForFile:(id<JIFile>)file
{
    if(file == nil)
        return nil;
    
    id<JIResourceLoader> loader = nil;
    for(JWResourceLoaderManagerEntry* e in self.loaderEntries.allValues)
    {
        if([file isMatchPattern:e.pattern])
        {
            loader = e.loader;
            break;
        }
    }
    return loader;
}

- (NSMutableDictionary *)loaderEntries
{
    if(mLoaderEntries == nil)
        mLoaderEntries = [NSMutableDictionary dictionary];
    return mLoaderEntries;
}

@end
