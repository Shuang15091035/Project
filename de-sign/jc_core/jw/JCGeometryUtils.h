//
//  JCGeometryUtils.h
//  June Winter
//
//  Created by GavinLo on 14/12/10.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCGeometryUtils__
#define __jw__JCGeometryUtils__

#include <jw/JCBase.h>
#include <jw/JCRay3.h>
#include <jw/JCBounds3.h>
#include <jw/JCPlane.h>

JC_BEGIN

typedef struct {
    
    bool hit;
    float distance;
    
}JCRayBounds3IntersectResult;

JCRayBounds3IntersectResult JCRayBounds3IntersectResultMake(bool hit, float distance);

typedef struct {
    
    bool hit;
    float distance;
    JCVector3 point;
    
}JCRayPlaneIntersectResult;

JCRayPlaneIntersectResult JCRayPlaneIntersectResultMake(bool hit, float distance);
JCVector3 JCRayPlaneIntersectResultGetHitPoint(const JCRayPlaneIntersectResult* result, JCRay3RefC ray);

JCRayBounds3IntersectResult JCRayBounds3Intersect(JCRay3RefC ray, JCBounds3RefC bounds);
JCRayPlaneIntersectResult JCRayPlaneIntersect(JCRay3RefC ray, JCPlaneRefC plane);

JC_END

#endif /* defined(__jw__JCGeometryUtils__) */
