//
//  JWSceneLoaderManager.m
//  June Winter
//
//  Created by GavinLo on 14/11/4.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWSceneLoaderManager.h"
#import "NSMutableDictionary+JWCoreCategory.h"
#import "JWCoreUtils.h"
#import "JWFile.h"
#import "JWSceneLoader.h"

@interface JWSceneLoaderManagerEntry : JWObject {
    NSRegularExpression* mPattern;
    id<JISceneLoader> mLoader;
}

@property (nonatomic, readwrite) NSRegularExpression* pattern;
@property (nonatomic, readwrite) id<JISceneLoader> loader;

@end

@implementation JWSceneLoaderManagerEntry

@synthesize pattern = mPattern;
@synthesize loader = mLoader;

- (void)onDestroy {
    mPattern = nil;
    [JWCoreUtils destroyObject:mLoader];
    mLoader = nil;
    [super onDestroy];
}

@end

@interface JWSceneLoaderManager () {
    id<JIGameContext> mContext;
    NSMutableDictionary* mLoaderEntries;
    JWSceneLoadParams* mDefaultParams;
}

@property (nonatomic, readonly) NSMutableDictionary* loaderEntries;

@end

@implementation JWSceneLoaderManager

- (id)initWithContext:(id<JIGameContext>)context {
    self = [super init];
    if (self != nil) {
        mContext = context;
    }
    return self;
}

- (BOOL)registerLoader:(id<JISceneLoader>)loader overrideExist:(BOOL)overrideExist {
    if (loader == nil) {
        return NO;
    }
    NSString* pattern = loader.pattern;
    JWSceneLoaderManagerEntry* e = [self.loaderEntries get:pattern];
    if (e == nil) {
        e = [[JWSceneLoaderManagerEntry alloc] init];
        [self.loaderEntries put:pattern value:e];
    } else if(!overrideExist) {
        return NO;
    }
    
    NSError* err = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&err];
    if (err != nil) {
        NSLog(@"%@", err);
        return NO;
    }
    
    e.pattern = regex;
    e.loader = loader;
    JWSceneLoader* l = loader;
    [l onRegisterWithContext:mContext manager:self];
    return YES;
}

- (void)unregisterLoaderForPattern:(NSString *)pattern {
    [self.loaderEntries remove:pattern];
}

- (void)unregisterAllLoaders {
    [JWCoreUtils destroyDict:self.loaderEntries];
}

- (id<JISceneLoader>)getLoaderForFile:(id<JIFile>)file {
    if (file == nil) {
        return nil;
    }
    
    id<JISceneLoader> loader = nil;
    for (JWSceneLoaderManagerEntry* e in self.loaderEntries.allValues) {
        if ([file isMatchPattern:e.pattern]) {
            loader = e.loader;
            break;
        }
    }
    return loader;
}

- (NSMutableDictionary *)loaderEntries {
    if (mLoaderEntries == nil) {
        mLoaderEntries = [NSMutableDictionary dictionary];
    }
    return mLoaderEntries;
}

@synthesize defaultParams = mDefaultParams;

@end
