//
//  JWResource.h
//  June Winter
//
//  Created by GavinLo on 14-5-2.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWEntity.h>
#import <jw/JWGameContext.h>
#import <jw/JWAsyncResult.h>

typedef NS_ENUM(NSInteger, JWResourceState)
{
    JWResourceStateInvalid = 0,
    JWResourceStateUnloaded,
    JWResourceStateLoading,
    JWResourceStateValid,
};

typedef void (^JWResourceOnLoadResourceBlock)(id<JIResource> resource);
typedef void (^JWResourceOnFailedToLoadResourceBlock)(id<JIResource> resource);

@protocol JIOnResourceLoadingListener <NSObject>

- (void) onLoadResource:(id<JIResource>)resource;
- (void) onFailedToLoadResource:(id<JIResource>)resource;

@end

@interface JWOnResourceLoadingListener : NSObject <JIOnResourceLoadingListener>

@property (nonatomic, readwrite) JWResourceOnLoadResourceBlock onLoaded;
@property (nonatomic, readwrite) JWResourceOnFailedToLoadResourceBlock onFailed;

@end

@protocol JIResource <JIEntity>

- (BOOL) load;
- (JWAsyncResult*) loadAsync:(BOOL)async;
- (void) unload;

@property (nonatomic, readonly) JWResourceState state;
@property (nonatomic, readonly) BOOL isValid;
@property (nonatomic, readwrite) id<JIFile> file;
@property (nonatomic, readonly) id<JIResourceManager> manager;
@property (nonatomic, readwrite) id<JIOnResourceLoadingListener> onLoad;

@end

@interface JWResource : JWEntity <JIResource>
{
    id<JIGameContext> mContext;
    id<JIResourceManager> mManager;
    JWResourceState mState;
    id<JIFile> mFile;
    id<JIOnResourceLoadingListener> mOnLoad;
}

- (id) initWithFile:(id<JIFile>)file context:(id<JIGameContext>)context manager:(id<JIResourceManager>)manager;

- (BOOL) loadFile:(id<JIFile>)file;
- (void) unloadResource;
- (void) setState:(JWResourceState)state;

@end
