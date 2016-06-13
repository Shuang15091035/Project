//
//  JCMargin.h
//  June Winter
//
//  Created by GavinLo on 14/12/19.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCMargin__
#define __jw__JCMargin__

#include <jw/JCBase.h>

JC_BEGIN

typedef struct
{
    float left;
    float top;
    float right;
    float bottom;
    
}JCMargin;

JCMargin JCMarginZero();
JCMargin JCMarginMake(float left, float top, float right, float bottom);
void JCMarginSetf(JCMargin* margin, float left, float top, float right, float bottom);

JC_END

#endif /* defined(__jw__JCMargin__) */
