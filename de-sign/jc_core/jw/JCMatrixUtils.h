//
//  JCMatrixUtils.h
//  June Winter
//
//  Created by GavinLo on 14-10-14.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCMatrixUtils__
#define __jw__JCMatrixUtils__

#include <jw/JCBase.h>

JC_BEGIN

#define JCIndex3(i, j) ((j) + 3 * (i))
#define JCIndex4(i, j) ((j) + 4 * (i))

void JCMatrix3SetIdentityM(JCFloat* matrix, int offset);
void JCMatrix4SetIdentityM(JCFloat* matrix, int offset);
void JCMatrix4MultiplyMM(JCFloat* result, int resultOffset, const JCFloat* lhs, int lhsOffset, const JCFloat* rhs, int rhsOffset);
void JCMatrix4MultiplyMV(JCFloat* result, int resultOffset, const JCFloat* lhs, int lhsOffset, const JCFloat* rhs, int rhsOffset);
bool JCMatrix4InvertM(JCFloat* result, int resultOffset, const JCFloat* matrix, int offset);
void JCMatrix3TransposeM(JCFloat* result, int resultOffset, const JCFloat* matrix, int offset);
void JCMatrix4TransposeM(JCFloat* result, int resultOffset, const JCFloat* matrix, int offset);
bool JCMatrixUtilsOrthoM(JCFloat* result, int resultOffset, JCFloat left, JCFloat right, JCFloat bottom, JCFloat top, JCFloat near, JCFloat far);
bool JCMatrixUtilsPerspectiveM(JCFloat* result, int resultOffset, JCFloat fovy, JCFloat aspect, JCFloat zNear, JCFloat zFar);

JC_END

#endif /* defined(__jw__JCMatrixUtils__) */
