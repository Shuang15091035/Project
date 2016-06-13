//
//  JCStretch.h
//  jc_core
//
//  Created by ddeyes on 16/5/26.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef JCStretch_h
#define JCStretch_h

#include <jw/JCBase.h>
#include <jw/JCVector3.h>

JC_BEGIN

typedef struct {
    
    JCVector3 pivot;
    JCVector3 offset;
    
}JCStretch;

typedef JCStretch* JCStretchRef;
typedef const JCStretch* JCStretchRefC;

JCStretch JCStretchZero();
JCStretch JCStretchMake(JCVector3 pivot, JCVector3 offset);

JC_END

#endif /* JCStretch_h */
