//
//  JCHalf.h
//  June Winter
//
//  Created by ddeyes on 15/11/25.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCHalf__
#define __jw__JCHalf__

#include <jw/JCBase.h>

JC_BEGIN

union JCFloatU {
    unsigned int u;
    float f;
    struct {
#if TARGET_RT_LITTLE_ENDIAN
        unsigned int Mantissa : 23;
        unsigned int Exponent : 8;
        unsigned int Sign : 1;
#else
        unsigned int Sign : 1;
        unsigned int Exponent : 8;
        unsigned int Mantissa : 23;
#endif
    } s;
};

JCFloatU JCFloatZero();
JCFloatU JCFloatOne();
JCFloatU JCFloatMake(float f);

union JCHalf {
    unsigned short u;
    struct {
#if TARGET_RT_LITTLE_ENDIAN
        unsigned int Mantissa : 10;
        unsigned int Exponent : 5;
        unsigned int Sign : 1;
#else
        unsigned int Sign : 1;
        unsigned int Exponent : 5;
        unsigned int Mantissa : 10;
#endif
    } s;
};

JCHalf JCHalfZero();
JCHalf JCHalfOne();
JCHalf JCHalfMake(unsigned short u);

float JCHalf2Float(JCHalf h);
JCHalf JCFloat2Half(float f);

JC_END

#endif /* defined(__jw__JCHalf__) */
