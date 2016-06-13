//
//  JCGLTexture.h
//  June Winter
//
//  Created by GavinLo on 15/1/15.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCGLTexture__
#define __jw__JCGLTexture__

#include <jw/JCTexture.h>

JC_BEGIN

/**
 * 创建OpenGL纹理，并把数据传输到GPU
 */
bool JCGLTextureUpload(JCTexture* texture, bool autoMipmap);

JC_END

#endif /* defined(__jw__JCGLTexture__) */
