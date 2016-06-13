//
//  JWResourceLoader.h
//  June Winter
//
//  Created by GavinLo on 15/1/13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWObject.h>
#import <jw/JWFile.h>

@protocol JIResourceLoader <JIObject>

@property (nonatomic, readonly) NSString* pattern;
- (BOOL) loadFile:(id<JIFile>)file forResource:(id<JIResource>)resource;
- (BOOL) saveFile:(id<JIFile>)file forResource:(id<JIResource>)resource;

@end

@interface JWResourceLoader : JWObject <JIResourceLoader>
{
    id<JIGameContext> mContext;
}

- (id) initWithContext:(id<JIGameContext>)context;

@end
