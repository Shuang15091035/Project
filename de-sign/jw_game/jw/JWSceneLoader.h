//
//  JWSceneLoader.h
//  June Winter
//
//  Created by GavinLo on 14-5-5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JWSceneLoaderManager.h>
#import <jw/JWGameObject.h>
#import <jw/JWAsyncResult.h>
#import <jw/JWAsyncEventHandler.h>

typedef void (^JWSceneLoaderOnStartBlock)(id<JIFile> file, id<JIGameObject> parent);
typedef void (^JWSceneLoaderOnResourceLoadedBlock)(id<JIResource> resource);
typedef void (^JWSceneLoaderOnObjectLoadedBlock)(id<JIGameObject> object);
typedef void (^JWSceneLoaderOnFinishBlock)(id<JIFile> file, id<JIGameObject> parent, id<JIGameObject> object);
typedef void (^JWSceneLoaderOnFailedBlock)(id<JIFile> file, id<JIGameObject> parent, NSError* error);
typedef void (^JWSceneLoaderOnCancelBlock)(id<JIFile> file, id<JIGameObject> parent);
typedef void (^JWSceneLoaderOnProgressBlock)(float progress);

@protocol JISceneLoaderOnLoadingListener <NSObject>

- (void) onSceneStartLoadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent;
- (void) onSceneLoadResource:(id<JIResource>)resource;
- (void) onSceneLoadObject:(id<JIGameObject>)object;
- (void) onSceneFinishLoadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent object:(id<JIGameObject>)object;
- (void) onSceneFailLoadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent error:(NSError*)error;
- (void) onSceneCancelLoadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent;
- (void) onSceneLoadingProgress:(float)progress;

@end

@interface JWSceneLoaderOnLoadingListener : NSObject <JISceneLoaderOnLoadingListener>

@property (nonatomic, readwrite) JWSceneLoaderOnStartBlock onStart;
@property (nonatomic, readwrite) JWSceneLoaderOnResourceLoadedBlock onResourceLoaded;
@property (nonatomic, readwrite) JWSceneLoaderOnObjectLoadedBlock onObjectLoaded;
@property (nonatomic, readwrite) JWSceneLoaderOnFinishBlock onFinish;
@property (nonatomic, readwrite) JWSceneLoaderOnFailedBlock onFailed;
@property (nonatomic, readwrite) JWSceneLoaderOnCancelBlock onCancel;
@property (nonatomic, readwrite) JWSceneLoaderOnProgressBlock onProgress;

@end

@interface JWSceneLoadParams : NSObject

+ (id) params;
+ (id) paramsWithIndependent:(BOOL)independent andName:(NSString*)independentName;
- (id) initWithIndependent:(BOOL)independent andName:(NSString*)independentName;
+ (id) paramsWithUseSkeleton:(BOOL)useSkeleton;
- (id) initWithUseSkeleton:(BOOL)useSkeleton;

/**
 * 是否独立加载<br>
 * 所谓独立加载,表示在文件加载的时候,里面的mesh名字和材质名字都以{@link #independentName}为基础进行修改,如"mesha"改为"mesha@independentName",
 * 避免命名重复导致的模型和材质显示错误问题
 */
@property (nonatomic, readwrite) BOOL independent;

/**
 * 结合{@link #independent}使用
 * @see #independent
 */
@property (nonatomic, readwrite) NSString* independentName;

/**
 * 是否加载骨骼信息
 */
@property (nonatomic, readwrite) BOOL useSkeleton;

@property (nonatomic, readwrite) BOOL compressTBN;
@property (nonatomic, readwrite) BOOL compressUV;
@property (nonatomic, readwrite) BOOL compressVertexColor;

@end

@interface JWSceneLoaderEventHandler : JWAsyncEventHandler

- (id) initWithAsync:(BOOL)async onLoadingListener:(id<JISceneLoaderOnLoadingListener>)onLoadingListener;
- (void) onSceneStartLoadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent;
- (void) onSceneLoadResource:(id<JIResource>)resource;
- (void) onSceneLoadObject:(id<JIGameObject>)object;
- (void) onSceneFinishLoadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent object:(id<JIGameObject>)object;
- (void) onSceneFailLoadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent;
- (void) onSceneCancelLoadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent;
- (void) onSceneLoadingProgress:(float)progress;

@property (nonatomic, readwrite) NSError* error;

@end

@protocol JISceneLoader <JIObject>

@property (nonatomic, readonly) NSString* pattern;
- (id<JIGameObject>) loadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent params:(JWSceneLoadParams*)params;
- (JWAsyncResult*) loadFile:(id<JIFile>)file parent:(id<JIGameObject>)parent  params:(JWSceneLoadParams*)params async:(BOOL)async listener:(id<JISceneLoaderOnLoadingListener>)listener;

@property (nonatomic, readonly) id<JIGameContext> context;
@property (nonatomic, readonly) id<JISceneLoaderManager> manager;

@end

@interface JWSceneLoader : JWObject <JISceneLoader> {
    id<JIGameContext> mContext;
    id<JISceneLoaderManager> mManager;
}

+ (NSString*) errorDomain;
- (id<JIGameObject>) loadSceneFile:(id<JIFile>)file parent:(id<JIGameObject>)parent params:(JWSceneLoadParams*)params handler:(JWSceneLoaderEventHandler*)handler cancellable:(id<JICancellable>)cancellable;

- (void) onRegisterWithContext:(id<JIGameContext>)context manager:(id<JISceneLoaderManager>)manager;

@end
