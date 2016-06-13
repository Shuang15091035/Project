//
//  JWResourceManager.h
//  June Winter
//
//  Created by GavinLo on 14-5-5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JWResource.h>
#import <jw/JWFile.h>
#import <jw/JWGameContext.h>
#import <jw/JWList.h>
#import <jw/JWMutableArray.h>

@protocol JIResourceManager <JIObject>

- (id<JIResource>) createFromFile:(id<JIFile>)file;
- (void) destroyByFile:(id<JIFile>)file;
- (id<JIResource>) getByFile:(id<JIFile>)file;
@property (nonatomic, readwrite) id<JIResource> defaultResource;
- (void) loadAll;
- (void) loadAllAsync:(BOOL)async;
- (void) unloadAll;

@end

@interface JWResourceManager : JWObject <JIResourceManager>
{
    id<JIGameContext> mContext;
    id<JIUList> mResources;
    id<JIResource> mDefaultResource;
}

- (id) initWithContext:(id<JIGameContext>)context;

- (id<JIResource>) newResource:(id<JIGameContext>)context file:(id<JIFile>)file;
- (id<JIResource>) newDefault:(id<JIGameContext>)context;

@end
