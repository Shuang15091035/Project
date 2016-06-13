//
//  JWImageCodecManager.h
//  June Winter
//
//  Created by GavinLo on 15/1/16.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <jw/JWImageCodec.h>

@protocol JIImageCodecManager <NSObject>

- (BOOL) registerCodec:(id<JIImageCodec>)codec overrideExist:(BOOL)overrideExist;
- (void) unregisterCodecForPattern:(NSString*)pattern;
- (void) unregisterAllCodecs;
- (id<JIImageCodec>) codecForFile:(id<JIFile>)file;

@end

@interface JWImageCodecManager : NSObject <JIImageCodecManager>

@end
