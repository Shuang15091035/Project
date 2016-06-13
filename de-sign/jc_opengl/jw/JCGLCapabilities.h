//
//  JCGLCapabilities.h
//  June Winter
//
//  Created by GavinLo on 15/1/12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCGLCapabilities__
#define __jw__JCGLCapabilities__

#include <jw/JCBase.h>

JC_BEGIN

typedef struct {
    
    int maxSamples;
    int maxTextureSize;
    int maxCombinedTextureImageUnits;
    int maxCubeMapTextureSize;
    int maxFragmentUniformVectors;
    int maxRenderbufferSize;
    int maxTextureImageUnits;
    int maxVaryingVectors;
    int maxVertexAttribs;
    int maxVertexTextureImageUnits;
    int maxVertexUniformVectors;
    int maxViewportWidth;
    int maxViewportHeight;
    int minAliasedLineWidth;
    int maxAliasedLineWidth;
    int minAliasedPointSize;
    int maxAliasedPointSize;
    
    char description[1024];
    
}JCGLCapabilities;

JCGLCapabilities JCGLCapabilitiesMake();

JC_END

#endif /* defined(__jw__JCGLCapabilities__) */
