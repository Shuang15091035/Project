//
//  JWResourceManager.m
//  June Winter
//
//  Created by GavinLo on 14-5-5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWResourceManager.h"
#import "JWList.h"

@interface JWResourceManager ()

@property (nonatomic, readonly) id<JIUList> resources;

@end

@implementation JWResourceManager

- (id<JIUList>)resources
{
    if(mResources == nil)
        mResources = [JWSafeUList list];
    return mResources;
}

- (id)initWithContext:(id<JIGameContext>)context
{
    self = [super init];
    if(self != nil)
    {
        mContext = context;
    }
    return self;
}

- (void)onCreate
{
    [super onCreate];
}

- (void)onDestroy
{
    __block BOOL needToDestroyDefault = YES;
    if(mResources != nil)
    {
        [mResources enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
            id<JIResource> resource = obj;
            if(resource == mDefaultResource)
                needToDestroyDefault = NO;
            [resource unload];
            [resource onDestroy];
        }];
        [mResources clear];
        mResources = nil;
    }
    if(needToDestroyDefault)
    {
        [mDefaultResource unload];
        [mDefaultResource onDestroy];
    }
    mDefaultResource = nil;
    [super onDestroy];
}

- (id<JIResource>)createFromFile:(id<JIFile>)file
{
    id<JIResource> resource = [self findByFile:file];
    if(resource != nil)
        return resource;
    resource = [self newResource:mContext file:file];
    [resource onCreate];
    [self.resources addObject:resource];
    return resource;
}

- (void)destroyByFile:(id<JIFile>)file {
    id<JIResource> resource = [self findByFile:file];
    if (resource != nil) {
        [resource unload];
    }
    [self.resources removeObject:resource];
}

- (id<JIResource>)getByFile:(id<JIFile>)file
{
    id<JIResource> res = [self findByFile:file];
    if(res == nil)
        return self.defaultResource;
    return res;
}

- (id<JIResource>)findByFile:(id<JIFile>)file
{
    __block id<JIResource> found = nil;
    [self.resources enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JIResource> resource = obj;
        id<JIFile> f = resource.file;
        if (f != nil && [f isEqual:file]) {
            found = resource;
            *stop = YES;
        }
    }];
    return found;
}

- (id<JIResource>)defaultResource
{
    if(mDefaultResource == nil)
    {
        mDefaultResource = [self newDefault:mContext];
        [mDefaultResource load];
    }
    return mDefaultResource;
}

- (void)setDefaultResource:(id<JIResource>)defaultResource
{
    mDefaultResource = defaultResource;
}

- (id<JIResource>)newResource:(id<JIGameContext>)context file:(id<JIFile>)file
{
    // override this
    return nil;
}

- (id<JIResource>)newDefault:(id<JIGameContext>)context
{
    // override this
    return nil;
}

- (void)loadAll {
    [self loadAllAsync:NO];
}

- (void)loadAllAsync:(BOOL)async {
    [self.resources enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JIResource> resource = obj;
        [resource loadAsync:async];
    }];
}

- (void)unloadAll {
    [self.resources enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JIResource> resource = obj;
        [resource unload];
    }];
}

@end
