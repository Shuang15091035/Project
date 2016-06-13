//
//  JCVector3.h
//  June Winter
//
//  Created by GavinLo on 14-10-13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef jw_JCVector3_h
#define jw_JCVector3_h

#include <jw/JCBase.h>

JC_BEGIN

typedef struct {
    
    JCFloat x;
    JCFloat y;
    JCFloat z;
    
}JCVector3;

typedef union {
    
    JCVector3 vector;
    JCFloat v[3];
    
}JCVector3U;

typedef JCVector3* JCVector3Ref;
typedef const JCVector3* JCVector3RefC;

JCVector3 JCVector3Zero();
JCVector3 JCVector3Identity();
JCVector3 JCVector3UnitX();
JCVector3 JCVector3UnitY();
JCVector3 JCVector3UnitZ();
JCVector3 JCVector3UnitNX();
JCVector3 JCVector3UnitNY();
JCVector3 JCVector3UnitNZ();

JCVector3 JCVector3Make(JCFloat x, JCFloat y, JCFloat z);
JCVector3 JCVector3Scalar(JCFloat scalar);
void JCVector3Setv(JCVector3Ref vector, JCVector3RefC other);
void JCVector3Setf(JCVector3Ref vector, JCFloat x, JCFloat y, JCFloat z);
JCVector3 JCVector3Negative(JCVector3RefC vector);
JCVector3 JCVector3Addv(JCVector3RefC lv, JCVector3RefC rv);
JCVector3 JCVector3Addf(JCVector3RefC vector, JCFloat x, JCFloat y, JCFloat z);
JCVector3 JCVector3Subv(JCVector3RefC lv, JCVector3RefC rv);
JCVector3 JCVector3Subf(JCVector3RefC lv, JCFloat x, JCFloat y, JCFloat z);
JCVector3 JCVector3Mulv(JCVector3RefC lv, JCVector3RefC rv);
JCVector3 JCVector3Muls(JCVector3RefC vector, JCFloat scalar);
JCVector3 JCVector3Divv(JCVector3RefC lv, JCVector3RefC rv);
JCVector3 JCVector3Divs(JCVector3RefC vector, JCFloat scalar);
JCFloat JCVector3DotProductv(JCVector3RefC lv, JCVector3RefC rv);
JCFloat JCVector3DotProductf(JCVector3RefC lv, JCFloat x, JCFloat y, JCFloat z);
JCVector3 JCVector3CrossProductv(JCVector3RefC lv, JCVector3RefC rv);
JCVector3 JCVector3CrossProductf(JCVector3RefC lv, JCFloat x, JCFloat y, JCFloat z);
JCFloat JCVector3SquareLength(JCVector3RefC vector);
JCFloat JCVector3Length(JCVector3RefC vector);
JCFloat JCVector3SquareDistance(JCVector3RefC lv, JCVector3RefC rv);
JCFloat JCVector3Distance(JCVector3RefC lv, JCVector3RefC rv);
JCVector3 JCVector3Normalize(JCVector3RefC vector);
JCVector3 JCVector3MakeFloorv(JCVector3RefC vector, JCVector3RefC cmp);
JCVector3 JCVector3MakeFloorf(JCVector3RefC vector, JCFloat x, JCFloat y, JCFloat z);
JCVector3 JCVector3MakeCeilv(JCVector3RefC vector, JCVector3RefC cmp);
JCVector3 JCVector3MakeCeilf(JCVector3RefC vector, JCFloat x, JCFloat y, JCFloat z);
JCVector3 JCVector3Lerp(JCVector3RefC from, JCVector3RefC to, JCFloat t);

bool JCVector3Equals(JCVector3RefC lv, JCVector3RefC rv);
bool JCVector3Equalsf(JCVector3RefC vector, JCFloat x, JCFloat y, JCFloat z);
bool JCVector3GreaterThan(JCVector3RefC lv, JCVector3RefC rv);
bool JCVector3LessThan(JCVector3RefC lv, JCVector3RefC rv);
bool JCVector3GreaterThanEqual(JCVector3RefC lv, JCVector3RefC rv);
bool JCVector3LessThanEqual(JCVector3RefC lv, JCVector3RefC rv);
bool JCVector3IsZero(JCVector3RefC vector);

// array[0] = vector.x
// array[1] = vector.y
// array[2] = vector.z
void JCVector3ToArray(JCVector3 vector, JCOut float* array);

// warp vector => (float)[min, max] => (byte)[0, 255]
// bytes[0] = vector.x
// bytes[1] = vector.y
// bytes[2] = vector.z
void JCVector3WarpBytes(JCVector3 vector, float min, float max, JCOut JCByte* bytes);

JCVector3 JCVector3Random(JCVector3 min, JCVector3 max);

JC_END

#endif
