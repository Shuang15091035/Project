//
//  JCMatrix4.h
//  June Winter
//
//  Created by GavinLo on 14-10-13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCMatrix4__
#define __jw__JCMatrix4__

#include <jw/JCBase.h>
#include <jw/JCVector3.h>
#include <jw/JCQuaternion.h>

JC_BEGIN

typedef enum {
    
    JCMatrix4NumRows = 4,
    JCMatrix4NumCols = 4,
    JCMatrix4NumComponents = JCMatrix4NumRows * JCMatrix4NumCols,
    
}JCMatrix4Constants;

typedef struct
{
    JCFloat m[JCMatrix4NumComponents];
    
}JCMatrix4;

typedef struct
{
    JCFloat m[JCMatrix4NumRows][JCMatrix4NumCols];
    
}JCMatrix44;

typedef union
{
    JCMatrix4 m4;
    JCMatrix44 m44;
    
}JCMatrix4U;

typedef JCMatrix4* JCMatrix4Ref;
typedef const JCMatrix4* JCMatrix4RefC;

JCMatrix4 JCMatrix4Identity();
JCMatrix4 JCMatrix4Transpose(JCMatrix4RefC matrix);
JCMatrix4 JCMatrix4Invert(JCMatrix4RefC matrix);
JCMatrix4 JCMatrix4Rmul(JCMatrix4RefC matrix, JCMatrix4RefC rm);
JCVector3 JCMatrix4Rmulv(JCMatrix4RefC matrix, JCVector3RefC rv);
JCVector3 JCMatrix4Lmulv(JCMatrix4RefC matrix, JCVector3RefC lv);
void JCMatrix4ToTransform(JCMatrix4RefC matrix, JCVector3Ref position, JCQuaternionRef orientation, JCVector3Ref scale);
JCMatrix3 JCMatrix4ToMatrix3(JCMatrix4RefC matrix);
void JCMatrix4GetComponents(JCMatrix4RefC matrix, JCFloat* components, JCULong componentOffset);

JC_END

#endif /* defined(__jw__JCMatrix4__) */
