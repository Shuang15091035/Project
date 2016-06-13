//
//  JCLine.h
//  jc_core
//
//  Created by ddeyes on 16/5/23.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef JCLine_h
#define JCLine_h

#include <jw/JCBase.h>
#include <jw/JCVector3.h>

JC_BEGIN

typedef struct {
    
    JCVector3 start;
    JCVector3 end;
    
}JCLine;

typedef JCLine* JCLineRef;
typedef const JCLine* JCLineRefC;

JCLine JCLineMake(JCVector3 start, JCVector3 end);

JC_END

#endif /* JCLine_h */
