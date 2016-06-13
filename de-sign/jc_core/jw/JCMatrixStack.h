//
//  JCMatrixStack.h
//  June Winter
//
//  Created by GavinLo on 14-10-14.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCMatrixStack__
#define __jw__JCMatrixStack__

#include <jw/JCBase.h>
#include <jw/JCMatrix3.h>
#include <jw/JCMatrix4.h>

JC_BEGIN

typedef enum {
    
    JCMatrixStackDepthMax = 32,
    JCMatrixStackMatrixSize = JCMatrix4NumComponents,
    JCMatrixStackOffsetUnderflow = -JCMatrixStackMatrixSize,
    JCMatrixStackOffsetOverflow = JCMatrixStackDepthMax * JCMatrixStackMatrixSize,
    
}JCMatrixStackConstants;

typedef struct
{
    JCFloat matrixStack[JCMatrixStackDepthMax * JCMatrixStackMatrixSize];
    int matrixStackOffset;
    
    JCFloat temp[2 * JCMatrixStackMatrixSize];
    
}JCMatrixStack;

JCMatrixStack JCMatrixStackMake();
JCMatrix4 JCMatrixStackGetMatrix(const JCMatrixStack* stack);
void JCMatrixStackLoadIdentity(JCMatrixStack* stack);
void JCMatrixStackMultiplyMatrix(JCMatrixStack* stack, JCMatrix4 matrix);
JCMatrix3 JCGetNormalMatrix(JCMatrix4 src);
bool JCMatrixStackOrthof(JCMatrixStack* stack, JCFloat left, JCFloat right, JCFloat bottom, JCFloat top, JCFloat zNear, JCFloat zFar);
bool JCMatrixStackOrtho2D(JCMatrixStack* stack, JCFloat left, JCFloat right, JCFloat bottom, JCFloat top);
bool JCMatrixStackPerspective(JCMatrixStack* stack, JCFloat fovy, JCFloat aspect, JCFloat zNear, JCFloat zFar);
bool JCMatrixStackPushMatrix(JCMatrixStack* stack);
bool JCMatrixStackPopMatrix(JCMatrixStack* stack);
void JCMatrixStackReset(JCMatrixStack* stack);

JC_END

#endif /* defined(__jw__JCMatrixStack__) */
