//
//  JCQuaternion.h
//  June Winter
//
//  Created by GavinLo on 14-10-13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef jw_JCQuaternion_h
#define jw_JCQuaternion_h

#include <jw/JCBase.h>
#include <jw/JCVector3.h>
#include <jw/JCMatrix3.h>

JC_BEGIN

typedef struct {
    JCFloat w;
    JCFloat x;
    JCFloat y;
    JCFloat z;
}JCQuaternion;

typedef union {
    JCQuaternion quaternion;
    JCFloat q[4];
}JCQuaternionQ;

typedef JCQuaternion* JCQuaternionRef;
typedef const JCQuaternion* JCQuaternionRefC;

typedef struct {
    JCVector3 x;
    JCVector3 y;
    JCVector3 z;
}JCAxes;

JCQuaternion JCQuaternionZero();
JCQuaternion JCQuaternionIdentity();

JCQuaternion JCQuaternionMake(JCFloat w, JCFloat x, JCFloat y, JCFloat z);
JCQuaternion JCQuaternionFromAngleAxis(JCFloat radians, JCVector3 axis);
void JCQuaternionToAngleAxis(JCQuaternionRefC quaternion, JCOut JCFloat* radians, JCOut JCVector3Ref axis);
JCQuaternion JCQuaternionFromRotationMatrix(JCMatrix3 rotMatrix);
JCMatrix3 JCQuaternionToRotationMatrix(JCQuaternionRefC quaternion);
JCQuaternion JCQuaternionFromAxes(JCVector3 xAxis, JCVector3 yAxis, JCVector3 zAxis);
void JCQuaternionToAxes(JCQuaternionRefC quaternion, JCOut JCVector3Ref xAxis, JCOut JCVector3Ref yAxis, JCOut JCVector3Ref zAxis);
JCAxes JCQuaternionGetAxes(JCQuaternionRefC quaternion);
JCQuaternion JCQuaternionFromEulerAngles(JCVector3 eulerAngles);
JCVector3 JCQuaternionToEulerAngles(JCQuaternionRefC quaternion, bool reprojectAxis);
void JCQuaternionSetf(JCQuaternionRef quaternion, JCFloat w, JCFloat x, JCFloat y, JCFloat z);
void JCQuaternionSetq(JCQuaternionRef quaternion, JCQuaternionRefC other);
JCQuaternion JCQuaternionNegative(JCQuaternionRefC quaternion);
JCQuaternion JCQuaternionAddq(JCQuaternionRefC lq, JCQuaternionRefC rq);
JCQuaternion JCQuaternionSubq(JCQuaternionRefC lq, JCQuaternionRefC rq);
JCQuaternion JCQuaternionMulq(JCQuaternionRefC lq, JCQuaternionRefC rq);
JCVector3 JCQuaternionMulv(JCQuaternionRefC quaternion, JCVector3 v);
JCQuaternion JCQuaternionMulf(JCQuaternionRefC quaternion, JCFloat scalar);
JCQuaternion JCQuaternionInverse(JCQuaternionRefC quaternion);
JCQuaternion JCQuaternionNormalize(JCQuaternionRefC quaternion);
JCFloat JCQuaternionSquareLength(JCQuaternionRefC quaternion);
JCFloat JCQuaternionLength(JCQuaternionRefC quaternion);
JCFloat JCQuaternionDotProduct(JCQuaternionRefC lq, JCQuaternionRefC rq);
JCQuaternion JCQuaternionNlerp(JCQuaternionRefC from, JCQuaternionRefC to, JCFloat t, bool shortestPath);
JCFloat JCQuaternionGetRoll(JCQuaternionRefC quaternion, bool reprojectAxis);
JCFloat JCQuaternionGetPitch(JCQuaternionRefC quaternion, bool reprojectAxis);
JCFloat JCQuaternionGetYaw(JCQuaternionRefC quaternion, bool reprojectAxis);

JC_END

#endif
