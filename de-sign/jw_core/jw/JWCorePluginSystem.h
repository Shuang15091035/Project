//
//  JWCorePluginSystem.h
//  June Winter
//
//  Created by GavinLo on 14-3-5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JWImageSystem.h>
#import <jw/JWImageCache.h>
#import <jw/JWLog.h>

@protocol JICorePluginSystem <JIObject>

@property (nonatomic, readwrite) id<JIImageSystem> imageSystem;
@property (nonatomic, readwrite) id<JIImageCache> imageCache;
@property (nonatomic, readwrite) id<JILog> log;

@end

@interface JWCorePluginSystem : JWObject <JICorePluginSystem>
{
    id<JIImageSystem> mImageSystem;
    id<JIImageCache> mImageCache;
    id<JILog> mLog;
}

+ (id<JICorePluginSystem>) instance;
+ (void) dispose;

@end
