//
//  JCVector2.h
//  June Winter
//
//  Created by GavinLo on 14/12/12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCVector2__
#define __jw__JCVector2__

#include <jw/JCBase.h>

JC_BEGIN

typedef struct
{
    JCFloat x;
    JCFloat y;
    
}JCVector2;

typedef union
{
    JCVector2 vector;
    JCFloat v[2];
}JCVector2V;

typedef JCVector2* JCVector2Ref;
typedef const JCVector2* JCVector2RefC;

JCVector2 JCVector2Zero();
JCVector2 JCVector2Identity();
JCVector2 JCVector2UnitX();
JCVector2 JCVector2UnitY();
JCVector2 JCVector2UnitNX();
JCVector2 JCVector2UnitNY();

JCVector2 JCVector2Make(JCFloat x, JCFloat y);
void JCVector2Setv(JCVector2Ref vector, JCVector2RefC other);
void JCVector2Setf(JCVector2Ref vector, JCFloat x, JCFloat y);
JCVector2 JCVector2Addv(JCVector2RefC lv, JCVector2RefC rv);
JCVector2 JCVector2Addf(JCVector2RefC vector, JCFloat x, JCFloat y);
JCVector2 JCVector2Mulv(JCVector2RefC lv, JCVector2RefC rv);
JCVector2 JCVector2Muls(JCVector2RefC vector, JCFloat scalar);

JC_END

#endif /* defined(__jw__JCVector2__) */
