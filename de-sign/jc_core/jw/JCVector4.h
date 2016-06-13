//
//  JCVector4.h
//  June Winter
//
//  Created by GavinLo on 14/11/7.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCVector4__
#define __jw__JCVector4__

#include <jw/JCBase.h>
#include <jw/JCVector3.h>

JC_BEGIN

typedef struct
{
    JCFloat x;
    JCFloat y;
    JCFloat z;
    JCFloat w;
    
}JCVector4;

typedef union
{
    JCVector4 vector;
    JCFloat v[4];
}JCVector4V;

typedef JCVector4* JCVector4Ref;
typedef const JCVector4* JCVector4RefC;

JCVector4 JCVector4Zero();
JCVector4 JCVector4Identity();

JCVector4 JCVector4Make(JCFloat x, JCFloat y, JCFloat z, JCFloat w);
JCVector4 JCVector4FromVector3(JCVector3 v);
JCVector3 JCVector4ToVector3(JCVector4 v);
void JCVector4Setv(JCVector4Ref vector, JCVector4RefC other);
void JCVector4Setf(JCVector4Ref vector, JCFloat x, JCFloat y, JCFloat z, JCFloat w);

// array[0] = vector.x
// array[1] = vector.y
// array[2] = vector.z
// array[3] = vector.w
void JCVector4ToArray(JCVector4 vector, JCOut float* array);

JC_END

#endif /* defined(__jw__JCVector4__) */
