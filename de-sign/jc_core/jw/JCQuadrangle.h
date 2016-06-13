//
//  JCQuadrangle.h
//  jc_core
//
//  Created by ddeyes on 16/5/23.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef JCQuadrangle_h
#define JCQuadrangle_h

#include <jw/JCBase.h>
#include <jw/JCVector3.h>

JC_BEGIN

typedef enum {
    
    JCQuadrangleNumPoints = 4,
    
}JCQuadrangleConstants;

typedef struct {
    
    JCVector3 point[JCQuadrangleNumPoints];
    
}JCQuadrangle;

typedef JCQuadrangle* JCQuadrangleRef;
typedef const JCQuadrangle* JCQuadrangleRefC;

JCQuadrangle JCQuadrangleMake(JCVector3 p1, JCVector3 p2, JCVector3 p3, JCVector3 p4, bool sort);

JC_END

#endif /* JCQuadrangle_h */
