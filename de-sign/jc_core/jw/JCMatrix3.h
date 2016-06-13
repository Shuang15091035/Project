//
//  JCMatrix3.h
//  June Winter
//
//  Created by GavinLo on 14-10-13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCMatrix3__
#define __jw__JCMatrix3__

#include <jw/JCBase.h>
#include <jw/JCVector3.h>

JC_BEGIN

typedef enum {
    
    JCMatrix3NumRows = 3,
    JCMatrix3NumCols = 3,
    JCMatrix3NumComponents = JCMatrix3NumRows * JCMatrix3NumCols,
    
}JCMatrix3Constants;

typedef struct
{
    JCFloat m[JCMatrix3NumComponents];
    
}JCMatrix3;

typedef struct
{
    JCFloat m[JCMatrix3NumRows][JCMatrix3NumCols];
    
}JCMatrix33;

typedef union
{
    JCMatrix3 m3;
    JCMatrix33 m33;
    
}JCMatrix3U;

typedef JCMatrix3* JCMatrix3Ref;
typedef const JCMatrix3* JCMatrix3RefC;

JCMatrix3 JCMatrix3Identity();
JCMatrix3 JCMatrix3Transpose(JCMatrix3RefC matrix);
JCMatrix3 JCMatrix3Add(JCMatrix3RefC lm, JCMatrix3RefC rm);
JCMatrix3 JCMatrix3Mul(JCMatrix3RefC lm, JCMatrix3RefC rm);
JCMatrix3 JCMatrix3Muls(JCMatrix3RefC matrix, JCFloat scalar);
JCVector3 JCMatrix3Rmulv(JCMatrix3RefC matrix, JCVector3RefC v);

JC_END

#endif /* defined(__jw__JCMatrix3__) */
