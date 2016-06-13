//
//  JCSize.h
//  June Winter
//
//  Created by GavinLo on 14/12/16.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCSize__
#define __jw__JCSize__

#include <jw/JCBase.h>

JC_BEGIN

typedef struct {
    
    JCInt width;
    JCInt height;
    
}JCSize;

JCSize JCSizeZero();
JCSize JCSizeMake(JCInt width, JCInt height);

typedef struct {
    
    JCFloat width;
    JCFloat height;
    
}JCSizeF;

JCSizeF JCSizeFZero();
JCSizeF JCSizeFMake(JCFloat width, JCFloat height);

JC_END

#endif /* defined(__jw__JCSize__) */
