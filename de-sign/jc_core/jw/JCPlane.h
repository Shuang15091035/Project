//
//  JCPlane.h
//  June Winter
//
//  Created by GavinLo on 15/3/15.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCPlane__
#define __jw__JCPlane__

#include <jw/JCBase.h>
#include <jw/JCVector3.h>

JC_BEGIN

typedef struct {
    
    /**
     * 平面的法线
     */
    JCVector3 normal;
    
    /**
     * 平面距离原点的有向距离
     */
    JCFloat distance;
    
}JCPlane;

typedef JCPlane* JCPlaneRef;
typedef const JCPlane* JCPlaneRefC;

JCPlane JCPlaneUnitYZero();
JCPlane JCPlaneMake(JCVector3 normal, JCFloat distance);

JC_END

#endif /* defined(__jw__JCPlane__) */
