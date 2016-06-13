//
//  JWResourceLoaderManager.h
//  June Winter
//
//  Created by GavinLo on 15/1/13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JWResourceLoader.h>

@protocol JIResourceLoaderManager <JIObject>

- (BOOL) registerLoader:(id<JIResourceLoader>)loader overrideExist:(BOOL)overrideExist;
- (void) unregisterLoaderForPattern:(NSString*)pattern;
- (void) unregisterAllLoaders;
- (id<JIResourceLoader>) getLoaderForFile:(id<JIFile>)file;

@end

@interface JWResourceLoaderManager : JWObject <JIResourceLoaderManager>

- (id) initWithContext:(id<JIGameContext>)context;

@end
