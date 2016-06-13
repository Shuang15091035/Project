//
//  JCBounds3.h
//  June Winter
//
//  Created by GavinLo on 14-5-2.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCBounds3__
#define __jw__JCBounds3__

#include <jw/JCVector3.h>
#include <jw/JCMatrix4.h>

JC_BEGIN

typedef enum
{
    JCBoundsExtentNull,
    JCBoundsExtentFinite,
    JCBoundsExtentInfinite,
    
}JCBoundsExtent;

typedef struct
{
    JCBoundsExtent extent;
    JCVector3 min;
    JCVector3 max;
    
}JCBounds3;

typedef JCBounds3* JCBounds3Ref;
typedef const JCBounds3* JCBounds3RefC;

JCBounds3 JCBounds3Null();
JCBounds3 JCBounds3Make(JCBoundsExtent extent, JCVector3 min, JCVector3 max);
void JCBounds3SetBounds(JCBounds3Ref bounds, JCBounds3RefC other);
void JCBounds3SetExtents(JCBounds3Ref bounds, JCVector3 min, JCVector3 max);
JCVector3 JCBounds3GetSize(JCBounds3RefC bounds);
JCVector3 JCBounds3GetCenter(JCBounds3RefC bounds);
JCBounds3 JCBounds3Mergeb(JCBounds3RefC bounds, JCBounds3RefC other);
JCBounds3 JCBounds3Mergev(JCBounds3RefC bounds, JCVector3RefC point);
JCBounds3 JCBounds3Transform(JCBounds3RefC bounds, JCMatrix4RefC matrix);
JCBounds3 JCBounds3Scale(JCBounds3RefC bounds, JCVector3 scale);
bool JCBounds3Collide(JCBounds3RefC lb, JCBounds3RefC rb);
bool JCBounds3Collidef(JCBounds3RefC bounds, float minX, float minY, float minZ, float maxX, float maxY, float maxZ);

JC_END

#endif /* defined(__jw__JCBounds3__) */
