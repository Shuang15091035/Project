//
//  JCViewport.h
//  June Winter
//
//  Created by GavinLo on 14/11/13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCViewport__
#define __jw__JCViewport__

#include <jw/JCBase.h>

JC_BEGIN

typedef enum {
    
    JCViewportTypeScale,
    JCViewportTypeReal, // unit: pixels
    
}JCViewportType;

typedef struct {
    
    JCViewportType type;
    
    float left;
    float top;
    float width;
    float height;
    
    int pLeft;
    int pTop;
    int pWidth;
    int pHeight;
    
}JCViewport;

JCViewport JCViewportDefault();
JCViewport JCViewportMake(float left, float top, float width, float height);
JCViewport JCViewportMakeReal(int left, int top, int width, int height);

JC_END

#endif /* defined(__jw__JCViewport__) */
