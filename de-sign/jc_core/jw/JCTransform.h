//
//  JCTransform.h
//  June Winter
//
//  Created by GavinLo on 14/10/28.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCTransform__
#define __jw__JCTransform__

#include <jw/JCBase.h>
#include <jw/JCVector3.h>
#include <jw/JCQuaternion.h>
#include <jw/JCMatrix4.h>

JC_BEGIN

struct _JCTransform;

/**
 * 几何变换，当中矩阵运算使用“行矩阵”
 */
struct _JCTransform {
    
    JCVector3 position;
    JCQuaternion orientation;
    JCVector3 scale;
    
    JCVector3 derivedPosition;
    JCQuaternion derivedOrientation;
    JCVector3 derivedScale;
    
    struct _JCTransform* parent;
    bool inheritOrientation;
    bool inheritScale;
    
    JCMatrix4 matrix;
    bool isDirty;
};

typedef struct _JCTransform JCTransform;
typedef JCTransform* JCTransformRef;
typedef const JCTransform* JCTransformRefC;

JCTransform JCTransformMake();
JCTransform JCTransformGetTransform(JCTransformRef transform, bool relativeToWorld);
void JCTransformSetTransform(JCTransformRef transform, JCTransformRef other, bool relativeToWorld);
void JCTransformResetTransform(JCTransformRef transform);
void JCTransformResetOrientation(JCTransformRef transform);
void JCTransformSetPositionRelativeToParent(JCTransformRef transform, JCVector3 p);
JCVector3 JCTransformConvertPositionWorldToParent(JCTransformRef transform, JCVector3 worldPosition);
void JCTransformTranslateRelativeToParent(JCTransformRef transform, JCVector3 dv);
JCVector3 JCTransformConvertTranslationWorldToParent(JCTransformRef transform, JCVector3 worldTranslation);
JCVector3 JCTransformConvertTranslationLocalToParent(JCTransformRef transform, JCVector3 localTranslation);

void JCTransformSetOrientationRelativeToLocal(JCTransformRef transform, JCQuaternion q);
void JCTransformRotateRelativeToLocal(JCTransformRef transform, JCQuaternion dq);
JCQuaternion JCTransformConvertOrientationWorldToLocal(JCTransformRef transform, JCQuaternion worldOrientation);

void JCTransformSetScale(JCTransformRef transform, JCVector3 s);
void JCTransformScale(JCTransformRef transform, JCVector3 ds);

void JCTransformSetParent(JCTransformRef transform, JCTransformRef parent);
void JCTransformUpdate(JCTransformRef transform);
void JCTransformUpdateParent(JCTransformRef transform);
void JCTransformSetDirty(JCTransformRef transform, bool isDirty);

JC_END

#endif /* defined(__jw__JCTransform__) */
