//
//  JCPadding.h
//  June Winter
//
//  Created by GavinLo on 15/3/18.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCPadding__
#define __jw__JCPadding__

#include <jw/JCBase.h>

JC_BEGIN

typedef struct {
    
    float left;
    float top;
    float right;
    float bottom;
    
}JCPadding;

JCPadding JCPaddingZero();
JCPadding JCPaddingMake(float left, float top, float right, float bottom);
JCPadding JCPaddingMakef(float p);
void JCPaddingSetf(JCPadding* padding, float left, float top, float right, float bottom);

JC_END

#endif /* defined(__jw__JCPadding__) */
