//
//  JWSceneLoaderManager.h
//  June Winter
//
//  Created by GavinLo on 14/11/4.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWObject.h>

@protocol JISceneLoaderManager <JIObject>

- (BOOL) registerLoader:(id<JISceneLoader>)loader overrideExist:(BOOL)overrideExist;
- (void) unregisterLoaderForPattern:(NSString*)pattern;
- (void) unregisterAllLoaders;
- (id<JISceneLoader>) getLoaderForFile:(id<JIFile>)file;
@property (nonatomic, readwrite) JWSceneLoadParams* defaultParams;

@end

@interface JWSceneLoaderManager : JWObject <JISceneLoaderManager>

- (id) initWithContext:(id<JIGameContext>)context;

@end
