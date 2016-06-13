//
//  JCVertex3.h
//  June Winter
//
//  Created by GavinLo on 14-10-15.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCVertex3__
#define __jw__JCVertex3__

#include <jw/JCBase.h>
#include <jw/JCVector2.h>
#include <jw/JCVector3.h>
#include <jw/JCVector4.h>
#include <jw/JCColor.h>
#include <jw/JCSkeleton.h>

JC_BEGIN

typedef enum {
    
    JCMaxTexCoordSetsPreVertex = 4,
    
}JCVertex3Constants;

typedef struct {
    
    JCVector3 position;
    JCVector3 normal;
    JCVector4 tangent;
    JCVector3 binormal;
    JCColor color;
    JCVector3 texCoords[JCMaxTexCoordSetsPreVertex];
    JCUInt numTexCoords;
    JCBoneInfluence boneWeights[JCMaxBonesPreVertex];
    JCUInt numBoneWeights;
    
}JCVertex3;

typedef JCVertex3* JCVertex3Ref;
typedef const JCVertex3* JCVertex3RefC;

JCVertex3 JCVertex3Make();

JC_END

#endif /* defined(__jw__JCVertex3__) */
