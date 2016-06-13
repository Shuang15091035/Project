//
//  JCRect.h
//  June Winter
//
//  Created by GavinLo on 15/4/4.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCRect__
#define __jw__JCRect__

#include <jw/JCBase.h>

JC_BEGIN

typedef struct {
    
    JCInt x;
    JCInt y;
    JCInt width;
    JCInt height;
    
}JCRect;

JCRect JCRectZero();
JCRect JCRectMake(JCInt x, JCInt y, JCInt width, JCInt height);

typedef struct {
    
    JCFloat x;
    JCFloat y;
    JCFloat width;
    JCFloat height;
    
}JCRectF;

JCRectF JCRectFZero();
JCRectF JCRectFMake(JCFloat x, JCFloat y, JCFloat width, JCFloat height);

JC_END

#endif /* defined(__jw__JCRect__) */
