//
//  JWGL20VideoTextureManager.h
//  jw_opengl
//
//  Created by ddeyes on 16/2/15.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWVideoTextureManager.h>

@interface JWGL20VideoTextureManager : JWVideoTextureManager

- (id)initWithContext:(id<JIGameContext>)context glContext:(EAGLContext*)glContext;
@property (nonatomic, readonly) CVOpenGLESTextureCacheRef textureCache;

@end
