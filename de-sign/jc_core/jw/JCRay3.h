//
//  JCRay3.h
//  June Winter
//
//  Created by GavinLo on 14/12/10.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCRay3__
#define __jw__JCRay3__

#include <jw/JCBase.h>
#include <jw/JCVector3.h>

JC_BEGIN

typedef struct
{
    JCVector3 origin;
    JCVector3 direction;
    
}JCRay3;

typedef JCRay3* JCRay3Ref;
typedef const JCRay3* JCRay3RefC;

JCRay3 JCRay3Make(JCVector3 origin, JCVector3 direction);

JC_END

#endif /* defined(__jw__JCRay3__) */
