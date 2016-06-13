//
//  JWSceneLoader.m
//  June Winter
//
//  Created by GavinLo on 14-5-5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWSceneLoader.h"
#import "JWAsyncResultTask.h"
#import "JWAsyncTaskResult.h"

@interface JWSceneLoaderOnLoadingListener () {
    JWSceneLoaderOnStartBlock mOnStart;
    JWSceneLoaderOnResourceLoadedBlock mOnResourceLoaded;
    JWSceneLoaderOnObjectLoadedBlock mOnObjectLoaded;
    JWSceneLoaderOnFinishBlock mOnFinish;
    JWSceneLoaderOnFailedBlock mOnFailed;
    JWSceneLoaderOnCancelBlock mOnCancel;
    JWSceneLoaderOnProgressBlock mOnProgress;
}

@end

@implementation JWSceneLoaderOnLoadingListener

- (void)onSceneStartLoadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent {
    if (mOnStart != nil) {
        mOnStart(file, parent);
    }
}

- (void)onSceneLoadResource:(id<JIResource>)resource {
    if (mOnResourceLoaded != nil) {
        mOnResourceLoaded(resource);
    }
}

- (void)onSceneLoadObject:(id<JIGameObject>)object {
    if (mOnObjectLoaded != nil) {
        mOnObjectLoaded(object);
    }
}

- (void)onSceneFinishLoadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent object:(id<JIGameObject>)object {
    if (mOnFinish != nil) {
        mOnFinish(file, parent, object);
    }
}

- (void)onSceneFailLoadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent error:(NSError *)error {
    if (mOnFailed != nil) {
        mOnFailed(file, parent, error);
    }
}

- (void)onSceneCancelLoadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent {
    if (mOnCancel != nil) {
        mOnCancel(file, parent);
    }
}

- (void)onSceneLoadingProgress:(float)progress {
    if (mOnProgress != nil) {
        mOnProgress(progress);
    }
}

- (JWSceneLoaderOnStartBlock)onStart {
    return mOnStart;
}

- (void)setOnStart:(JWSceneLoaderOnStartBlock)onStart {
    mOnStart = onStart;
}

- (JWSceneLoaderOnResourceLoadedBlock)onResourceLoaded {
    return mOnResourceLoaded;
}

- (void)setOnResourceLoaded:(JWSceneLoaderOnResourceLoadedBlock)onResourceLoaded {
    mOnResourceLoaded = onResourceLoaded;
}

- (JWSceneLoaderOnObjectLoadedBlock)onObjectLoaded {
    return mOnObjectLoaded;
}

- (void)setOnObjectLoaded:(JWSceneLoaderOnObjectLoadedBlock)onObjectLoaded {
    mOnObjectLoaded = onObjectLoaded;
}

- (JWSceneLoaderOnFinishBlock)onFinish {
    return mOnFinish;
}

- (void)setOnFinish:(JWSceneLoaderOnFinishBlock)onFinish {
    mOnFinish = onFinish;
}

- (JWSceneLoaderOnFailedBlock)onFailed {
    return mOnFailed;
}

- (void)setOnFailed:(JWSceneLoaderOnFailedBlock)onFailed {
    mOnFailed = onFailed;
}

- (JWSceneLoaderOnCancelBlock)onCancel {
    return mOnCancel;
}

- (void)setOnCancel:(JWSceneLoaderOnCancelBlock)onCancel {
    mOnCancel = onCancel;
}

- (JWSceneLoaderOnProgressBlock)onProgress {
    return mOnProgress;
}

- (void)setOnProgress:(JWSceneLoaderOnProgressBlock)onProgress {
    mOnProgress = onProgress;
}

@end

@interface JWSceneLoadParams () {
    BOOL mIndependent;
    NSString* mIndependentName;
    BOOL mUseSkeleton;
    BOOL mCompressTBN;
    BOOL mCompressUV;
    BOOL mCompressVertexColor;
}

@end

@implementation JWSceneLoadParams

+ (id)params {
    return [[self alloc] init];
}

+ (id)paramsWithIndependent:(BOOL)independent andName:(NSString *)independentName {
    return [[self alloc] initWithIndependent:independent andName:independentName];
}

- (id)initWithIndependent:(BOOL)independent andName:(NSString *)independentName {
    self = [super init];
    if (self != nil) {
        mIndependent = independent;
        mIndependentName = independentName;
    }
    return self;
}

+ (id)paramsWithUseSkeleton:(BOOL)useSkeleton {
    return [[self alloc] initWithUseSkeleton:useSkeleton];
}

- (id)initWithUseSkeleton:(BOOL)useSkeleton {
    self = [super init];
    if (self != nil) {
        mUseSkeleton = useSkeleton;
    }
    return self;
}

@synthesize independent = mIndependent;
@synthesize independentName = mIndependentName;
@synthesize useSkeleton = mUseSkeleton;
@synthesize compressTBN = mCompressTBN;
@synthesize compressUV = mCompressUV;
@synthesize compressVertexColor = mCompressVertexColor;

@end

@interface JWSceneLoaderEventHandler () {
    id<JISceneLoaderOnLoadingListener> mOnLoadingListener;
    BOOL mIsFinishLoading;
}

@end

@interface JWSceneLoaderEventHandler () {
    NSError* mError;
}

@end

@implementation JWSceneLoaderEventHandler

- (id)initWithAsync:(BOOL)async onLoadingListener:(id<JISceneLoaderOnLoadingListener>)onLoadingListener {
    self = [super initWithAsync:async];
    if (self != nil) {
        mOnLoadingListener = onLoadingListener;
    }
    return self;
}

- (void)onSceneStartLoadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent {
    if(mOnLoadingListener != nil)
        [mOnLoadingListener onSceneStartLoadFile:file parent:parent];
    mIsFinishLoading = NO;
}

- (void)onSceneLoadResource:(id<JIResource>)resource {
    if (mAsync) {
        if(mOnLoadingListener != nil) {
            [JWAsyncUtils runOnMainQueue:^{
                [mOnLoadingListener onSceneLoadResource:resource];
            }];
        }
    } else {
        if (mOnLoadingListener != nil) {
            [mOnLoadingListener onSceneLoadResource:resource];
        }
    }
}

- (void)onSceneLoadObject:(id<JIGameObject>)object {
    if (mAsync) {
        if (mOnLoadingListener != nil) {
            [JWAsyncUtils runOnMainQueue:^{
                [mOnLoadingListener onSceneLoadObject:object];
            }];
        }
    } else {
        if (mOnLoadingListener != nil) {
            [mOnLoadingListener onSceneLoadObject:object];
        }
    }
}

- (void)onSceneFinishLoadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent object:(id<JIGameObject>)object {
//    if (mOnLoadingListener != nil) {
//        [mOnLoadingListener onSceneFinishLoadFile:file parent:parent object:object];
//        [mOnLoadingListener onSceneLoadingProgress:1.0f];
//        mIsFinishLoading = YES;
//    }
    
    if (mAsync) {
        if (mOnLoadingListener != nil) {
            [JWAsyncUtils runOnMainQueue:^{
                [mOnLoadingListener onSceneFinishLoadFile:file parent:parent object:object];
                [mOnLoadingListener onSceneLoadingProgress:1.0f];
                mIsFinishLoading = YES;
            }];
        }
    } else {
        if (mOnLoadingListener != nil) {
            [mOnLoadingListener onSceneFinishLoadFile:file parent:parent object:object];
            [mOnLoadingListener onSceneLoadingProgress:1.0f];
            mIsFinishLoading = YES;
        }
    }
}

- (void)onSceneFailLoadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent {
    if (mAsync) {
        if (mOnLoadingListener != nil) {
            [JWAsyncUtils runOnMainQueue:^{
                [mOnLoadingListener onSceneFailLoadFile:file parent:parent error:mError];
            }];
        }
    } else {
        if (mOnLoadingListener != nil) {
            [mOnLoadingListener onSceneFailLoadFile:file parent:parent error:mError];
        }
    }
}

- (void)onSceneCancelLoadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent {
    if (mAsync) {
        if(mOnLoadingListener != nil) {
            [JWAsyncUtils runOnMainQueue:^{
                [mOnLoadingListener onSceneCancelLoadFile:file parent:parent];
            }];
        }
    } else {
        if (mOnLoadingListener != nil) {
            [mOnLoadingListener onSceneCancelLoadFile:file parent:parent];
        }
    }
}

- (void)onSceneLoadingProgress:(float)progress {
    if (mAsync) {
        if (mOnLoadingListener != nil) {
            [JWAsyncUtils runOnMainQueue:^{
                if (mIsFinishLoading) {
                    return;
                }
                [mOnLoadingListener onSceneLoadingProgress:progress];
            }];
        }
    } else {
        if (mOnLoadingListener != nil) {
            if (mIsFinishLoading) {
                return;
            }
            [mOnLoadingListener onSceneLoadingProgress:progress];
        }
    }
}

@synthesize error = mError;

@end

@interface JWSceneLoadingTask : JWAsyncResultTask {
    id<JIFile> mFile;
    id<JIGameObject> mParent;
    JWSceneLoaderEventHandler* mHandler;
    JWSceneLoadParams* mParams;
    JWSceneLoader* mLoader;
}

- (id) initWithResult:(JWAsyncResult *)result file:(id<JIFile>)file parent:(id<JIGameObject>)parent params:(JWSceneLoadParams*)params handler:(JWSceneLoaderEventHandler*)handler loader:(JWSceneLoader*)loader;

@end

@implementation JWSceneLoadingTask

- (id)initWithResult:(JWAsyncResult *)result file:(id<JIFile>)file parent:(id<JIGameObject>)parent params:(JWSceneLoadParams *)params handler:(JWSceneLoaderEventHandler *)handler loader:(JWSceneLoader *)loader {
    self = [super initWithResult:result];
    if (self != nil) {
        mFile = file;
        mParent = parent;
        mHandler = handler;
        mParams = params;
        mLoader = loader;
    }
    return self;
}

- (void)onPreExecute {
    if (mFile == nil) {
        mHandler.error = [NSError errorWithDomain:[JWSceneLoader errorDomain] code:0 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"file is nil.", NSLocalizedDescriptionKey, nil]];
        [mHandler onSceneFailLoadFile:mFile parent:mParent];
        [self cancel];
        return;
    }
    [mHandler onSceneStartLoadFile:mFile parent:mParent];
}

- (id)doInBackground:(NSArray *)params {
    if (self.isCancelled) {
        return nil;
    }
    id<JIGameObject> object = [mLoader loadSceneFile:mFile parent:mParent params:mParams handler:mHandler cancellable:self];
    return object;
}

- (void)onPostExecute:(id)result {
    if (self.isCancelled) {
        return;
    }
    mAsyncResult.syncResult = result;
    if (result != nil) {
        [mHandler onSceneFinishLoadFile:mFile parent:mParent object:result];
    } else {
        [mHandler onSceneFailLoadFile:mFile parent:mParent];
    }
}

@end

@implementation JWSceneLoader

+ (NSString *)errorDomain {
    return @"Scene Loader Error";
}

//- (id)initWithContext:(id<JIGameContext>)context {
//    self = [super init];
//    if (self != nil) {
//        mContext = context;
//    }
//    return self;
//}

- (NSString *)pattern {
    return nil;
}

- (id<JIGameObject>)loadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent params:(JWSceneLoadParams *)params {
    JWAsyncResult* result = [self loadFile:file parent:parent params:params async:NO listener:nil];
    return result.syncResult;
}

- (JWAsyncResult *)loadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent params:(JWSceneLoadParams *)params async:(BOOL)async listener:(id<JISceneLoaderOnLoadingListener>)listener {
    JWAsyncTaskResult* result = [JWAsyncTaskResult result];
    JWSceneLoaderEventHandler* handler = [[JWSceneLoaderEventHandler alloc] initWithAsync:async onLoadingListener:listener];
    JWSceneLoadingTask* task = [[JWSceneLoadingTask alloc] initWithResult:result file:file parent:parent params:params handler:handler loader:self];
    result.asyncTask = task;
    if (!async) {
        [task onPreExecute];
        if (task.isCancelled) {
            result.syncResult = nil;
            return result;
        }
        id<JIGameObject> object = [task doInBackground:nil];
        [task onPostExecute:object];
        result.syncResult = object;
    } else {
        [task execute:nil];
        result.syncResult = nil;
    }
    return result;
}

@synthesize context = mContext;
@synthesize manager = mManager;
    
- (id<JIGameObject>)loadSceneFile:(id<JIFile>)file parent:(id<JIGameObject>)parent params:(JWSceneLoadParams *)params handler:(JWSceneLoaderEventHandler *)handler cancellable:(id<JICancellable>)cancellable {
    // subclass override
    return nil;
}

- (void)onRegisterWithContext:(id<JIGameContext>)context manager:(id<JISceneLoaderManager>)manager {
    mContext = context;
    mManager = manager;
}

@end
