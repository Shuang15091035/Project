//
//  JWResource.m
//  June Winter
//
//  Created by GavinLo on 14-5-2.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWResource.h"
#import "JWResourceManager.h"
#import "JWAsyncResultTask.h"
#import "JWAsyncEventHandler.h"
#import "JWGameContext.h"
#import "JWResourceLoaderManager.h"
#import "JWResourceLoader.h"

@interface JWOnResourceLoadingListener ()
{
    JWResourceOnLoadResourceBlock mOnLoaded;
    JWResourceOnFailedToLoadResourceBlock mOnFailed;
}

@end

@implementation JWOnResourceLoadingListener

- (void)onLoadResource:(id<JIResource>)resource
{
    if(mOnLoaded != nil)
        mOnLoaded(resource);
}

- (void)onFailedToLoadResource:(id<JIResource>)resource
{
    if(mOnFailed != nil)
        mOnFailed(resource);
}

- (JWResourceOnLoadResourceBlock)onLoaded
{
    return mOnLoaded;
}

- (void)setOnLoaded:(JWResourceOnLoadResourceBlock)onLoaded
{
    mOnLoaded = onLoaded;
}

- (JWResourceOnFailedToLoadResourceBlock)onFailed
{
    return mOnFailed;
}

- (void)setOnFailed:(JWResourceOnFailedToLoadResourceBlock)onFailed
{
    mOnFailed = onFailed;
}

@end

@interface JWResourceEventHandler : JWAsyncEventHandler
{
    id<JIOnResourceLoadingListener> mOnResourceLoadingListener;
}

- (id) initWithAsync:(BOOL)async onResourceLoadingListener:(id<JIOnResourceLoadingListener>)onResourceLoadingListener;
- (void) onLoadResource:(id<JIResource>)resource;
- (void) onFailedToLoadResource:(id<JIResource>)resource;

@end

@implementation JWResourceEventHandler

- (id)initWithAsync:(BOOL)async onResourceLoadingListener:(id<JIOnResourceLoadingListener>)onResourceLoadingListener
{
    self = [super initWithAsync:async];
    if(self != nil)
    {
        mOnResourceLoadingListener = onResourceLoadingListener;
    }
    return self;
}

- (void)onLoadResource:(id<JIResource>)resource
{
//    if(mAsync)
//    {
//        if(mOnResourceLoadingListener != nil)
//        {
//            [JWAsyncUtils runOnMainQueue:^{
//                [mOnResourceLoadingListener onLoadResource:resource];
//            }];
//        }
//    }
//    else
    {
        if(mOnResourceLoadingListener != nil)
            [mOnResourceLoadingListener onLoadResource:resource];
    }
}

- (void)onFailedToLoadResource:(id<JIResource>)resource
{
    if(mOnResourceLoadingListener != nil)
        [mOnResourceLoadingListener onFailedToLoadResource:resource];
}

@end

@interface JWResourceLoadTask : JWAsyncResultTask
{
    JWResource* mResource;
    id<JIFile> mFile;
    JWResourceEventHandler* mResourceEventHandler;
}

- (id) initWithResult:(JWAsyncResult *)result resource:(JWResource*)resource file:(id<JIFile>)file resourceEventHandler:(JWResourceEventHandler*)resourceEventHandler;

@end

@implementation JWResourceLoadTask

- (id)initWithResult:(JWAsyncResult *)result resource:(JWResource *)resource file:(id<JIFile>)file resourceEventHandler:(JWResourceEventHandler *)resourceEventHandler
{
    self = [super initWithResult:result];
    if(self != nil)
    {
        mResource = resource;
        mFile = file;
        mResourceEventHandler = resourceEventHandler;
    }
    return self;
}

- (void)onPreExecute
{
    if(mResource.state == JWResourceStateUnloaded)
        [mResource setState:JWResourceStateLoading];
    else
        [self cancel];
}

- (id)doInBackground:(NSArray *)params
{
    if(self.isCancelled)
        return [NSNumber numberWithBool:NO];
    
    BOOL b = [mResource loadFile:mFile];
    return [NSNumber numberWithBool:b];
}

- (void)onPostExecute:(id)result
{
    NSNumber* num = result;
    BOOL r = num.boolValue;
    if(r)
    {
        [mResource setState:JWResourceStateValid];
        [mResourceEventHandler onLoadResource:mResource];
    }
    else
    {
        [mResource setState:JWResourceStateUnloaded];
        [mResourceEventHandler onFailedToLoadResource:mResource];
    }
}

@end

@interface JWResource ()
{
    JWAsyncResult* mCurrentResult;
}

@end

@implementation JWResource

- (id)initWithFile:(id<JIFile>)file context:(id<JIGameContext>)context manager:(id<JIResourceManager>)manager
{
    self = [super init];
    if(self != nil)
    {
        //[self onCreate]; // 由manager调用
        mContext = context;
        mManager = manager;
        mFile = file;
    }
    return self;
}

- (void)onCreate
{
    [super onCreate];
    mState = JWResourceStateUnloaded;
}

- (void)onDestroy
{
    mContext = nil;
    mManager = nil;
    mFile = nil;
    [super onDestroy];
}

- (BOOL)load
{
    JWAsyncResult* result = [self loadAsync:NO];
    NSNumber* num = result.syncResult;
    return num.boolValue;
}

- (JWAsyncResult *)loadAsync:(BOOL)async {
    JWAsyncResult* result = [JWAsyncResult result];
    if (self.state == JWResourceStateValid) { // 资源可用（表示资源加载过），返回加载成功
        result.syncResult = [NSNumber numberWithBool:YES];
        return result;
    }
    if (self.state != JWResourceStateUnloaded) {
        result.syncResult = [NSNumber numberWithBool:NO];
        return result;
    }
    [self cancelCurrent];
    
    JWResourceEventHandler* resourceEventHandler = [[JWResourceEventHandler alloc] initWithAsync:async onResourceLoadingListener:mOnLoad];
    JWResourceLoadTask* loadTask = [[JWResourceLoadTask alloc] initWithResult:result resource:self file:mFile resourceEventHandler:resourceEventHandler];
    if (!async) {
        [loadTask onPreExecute];
        if(loadTask.isCancelled) {
            result.syncResult = [NSNumber numberWithBool:NO];
            return result;
        }
        NSNumber* b = [loadTask doInBackground:nil];
        [loadTask onPostExecute:b];
        result.syncResult = b;
    } else {
        [loadTask execute:nil];
        result.syncResult = [NSNumber numberWithBool:NO];
    }
    mCurrentResult = result;
    return result;
}

- (BOOL)loadFile:(id<JIFile>)file {
    id<JIResourceLoader> loader = [mContext.resourceLoaderManager getLoaderForFile:file];
    if (loader == nil) {
        return NO;
    }
    return [loader loadFile:file forResource:self];
}

- (void)unload
{
    if (self.state == JWResourceStateUnloaded) {
        return;
    }
    switch(self.state)
    {
        case JWResourceStateLoading:
        {
            [self cancelCurrent];
            [self setState:JWResourceStateUnloaded];
            break;
        }
        case JWResourceStateValid:
        {
            [self unloadResource];
            [self setState:JWResourceStateUnloaded];
            break;
        }
        default:
            break;
    }
    [mManager destroyByFile:mFile];
}

- (void)unloadResource
{
    
}

@synthesize onLoad = mOnLoad;

- (void) cancelCurrent
{
    if(mCurrentResult != nil)
    {
        [mCurrentResult cancel];
        mCurrentResult = nil;
    }
}

- (JWResourceState)state
{
    return mState;
}

- (void)setState:(JWResourceState)state
{
    mState = state;
}

- (BOOL)isValid
{
    return self.state == JWResourceStateValid;
}

- (id<JIFile>)file
{
    return mFile;
}

- (void)setFile:(id<JIFile>)file
{
    if(file == nil)
    {
        [self unload];
        return;
    }
    if(mFile == file)
        return;
    [self unload];
    mFile = file;
}

- (id<JIResourceManager>)manager
{
    return mManager;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[%@] %@", NSStringFromClass([self class]), mFile];
}

@end
